import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/neon_paint.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/player_ball.dart';

/// A single arc segment of an obstacle ring
///
/// Each RingSegment represents a 90° arc (π/2 radians) of the ring.
/// The segment has a specific color and triggers game over if the
/// player passes through with a non-matching color.
///
/// Key behaviors:
/// - Renders as an arc with neon glow
/// - Has a PolygonHitbox approximating the arc shape
/// - Checks color matching on collision
class RingSegment extends PositionComponent
    with HasGameReference<ChromaGame>, CollisionCallbacks {
  /// The color of this segment
  final Color color;

  /// Starting angle of the arc in radians
  final double startAngle;

  /// Angular sweep of the arc (default: π/2 = 90°)
  final double sweepAngle;

  /// Outer radius of the ring
  final double outerRadius;

  /// Inner radius of the ring
  final double innerRadius;

  /// Number of vertices to approximate the arc
  static const int _arcSegments = 8;

  RingSegment({
    required this.color,
    required this.startAngle,
    this.sweepAngle = pi / 2,
    this.outerRadius = GameConstants.ringOuterRadius,
    this.innerRadius = GameConstants.ringInnerRadius,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add polygon hitbox approximating the arc
    add(PolygonHitbox(_calculateArcVertices()));
  }

  /// Calculate vertices that approximate the arc shape
  ///
  /// Creates a polygon with vertices along the outer arc,
  /// then the inner arc (in reverse), forming a closed shape.
  List<Vector2> _calculateArcVertices() {
    final vertices = <Vector2>[];

    // Calculate angle step for arc approximation
    final angleStep = sweepAngle / _arcSegments;

    // Outer arc vertices (from start to end)
    for (int i = 0; i <= _arcSegments; i++) {
      final angle = startAngle + (angleStep * i);
      vertices.add(Vector2(cos(angle) * outerRadius, sin(angle) * outerRadius));
    }

    // Inner arc vertices (from end to start, reversed)
    for (int i = _arcSegments; i >= 0; i--) {
      final angle = startAngle + (angleStep * i);
      vertices.add(Vector2(cos(angle) * innerRadius, sin(angle) * innerRadius));
    }

    return vertices;
  }

  // ignore: avoid_renaming_method_parameters - Flame callback override
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBall) {
      // Check if colors match
      if (other.currentColor != color) {
        // Different color = death
        game.triggerGameOver();
      }
      // Same color = pass through safely (no action needed)
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Create the arc rect based on outer radius
    final rect = Rect.fromCircle(
      center: Offset.zero,
      radius: outerRadius - (GameConstants.ringThickness / 2),
    );

    // Draw the arc with neon glow
    final paint = getNeonPaint(
      color,
      strokeWidth: GameConstants.ringThickness,
      blurRadius: 6.0,
    );

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false, // Don't connect to center
      paint,
    );

    // Draw solid core
    final corePaint = getCorePaint(color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = GameConstants.ringThickness - 4;

    canvas.drawArc(rect, startAngle, sweepAngle, false, corePaint);
  }
}
