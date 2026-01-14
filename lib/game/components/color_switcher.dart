import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/neon_paint.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/player_ball.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// A collectible orb that changes the player's color
///
/// The ColorSwitcher appears between obstacles and changes the player's
/// color when collected. It ensures the new color is valid for passing
/// through the next obstacle.
///
/// Key behaviors:
/// - Renders as a pulsing neon orb with 4 rotating color segments
/// - Changes player color on collision
/// - Ensures new color works with next obstacle (color safety)
/// - Increments score and triggers screen flash
class ColorSwitcher extends PositionComponent
    with HasGameReference<ChromaGame>, CollisionCallbacks {
  /// Colors that are valid for passing through the next obstacle
  /// If empty, any different color is valid (fallback logic in _selectNewColor)
  final List<Color> nextValidColors = [];

  /// Radius of the color switcher orb
  final double radius;

  /// Rotation angle for animation
  double _rotationAngle = 0.0;

  /// Pulse scale for breathing animation
  double _pulseScale = 1.0;
  double _pulseDirection = 1.0;

  ColorSwitcher({
    List<Color>? validColors,
    this.radius = GameConstants.colorSwitcherRadius,
    super.position,
  }) {
    if (validColors != null) {
      nextValidColors.addAll(validColors);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set size and anchor
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    // Add circular hitbox
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Rotate the color segments
    _rotationAngle += dt * 2.0; // 2 rad/s rotation

    // Pulsing animation (0.9 to 1.1 scale)
    _pulseScale += _pulseDirection * dt * 0.5;
    if (_pulseScale > 1.1) {
      _pulseScale = 1.1;
      _pulseDirection = -1.0;
    } else if (_pulseScale < 0.9) {
      _pulseScale = 0.9;
      _pulseDirection = 1.0;
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayerBall) {
      // Pick a new color (different from current, valid for next obstacle)
      final newColor = _selectNewColor(other.currentColor);
      other.setColor(newColor);

      // Visual feedback - screen flash
      game.flashScreen();

      // Update score
      getIt<ScoreNotifier>().increment();

      // Remove self
      removeFromParent();
    }
  }

  /// Select a new color for the player
  ///
  /// Prioritizes colors that work with the next obstacle.
  /// Falls back to any different color if no valid colors available.
  Color _selectNewColor(Color currentColor) {
    List<Color> availableColors;

    if (nextValidColors.isNotEmpty) {
      // Filter to colors that are valid AND different from current
      availableColors = nextValidColors
          .where((c) => c != currentColor)
          .toList();
    } else {
      availableColors = [];
    }

    // Fallback: any different color
    if (availableColors.isEmpty) {
      availableColors = AppColors.gameColors
          .where((c) => c != currentColor)
          .toList();
    }

    // Pick random from available
    final random = Random();
    return availableColors[random.nextInt(availableColors.length)];
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final scaledRadius = radius * _pulseScale;

    // Draw 4 color segments (rotating)
    final colors = AppColors.gameColors;
    for (int i = 0; i < 4; i++) {
      final startAngle = _rotationAngle + (i * pi / 2);
      final sweepAngle = pi / 2;

      // Outer glow
      final glowPaint = getNeonPaint(
        colors[i],
        blurRadius: 10.0,
        strokeWidth: 4.0,
      );

      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: scaledRadius),
        startAngle,
        sweepAngle,
        false,
        glowPaint,
      );

      // Solid core
      final corePaint = getCorePaint(colors[i])
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

      canvas.drawArc(
        Rect.fromCircle(center: Offset.zero, radius: scaledRadius - 2),
        startAngle,
        sweepAngle,
        false,
        corePaint,
      );
    }

    // Center glow
    canvas.drawCircle(
      Offset.zero,
      scaledRadius * 0.3,
      Paint()
        ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0),
    );
  }
}
