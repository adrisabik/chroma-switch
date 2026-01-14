import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:chroma_switch/core/theme/neon_paint.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/player_ball.dart';

class StraightSegment extends PositionComponent
    with CollisionCallbacks, HasGameReference<ChromaGame> {
  final Color color;

  /// Dimensions of the segment

  /// Corner radius for rounded rectangle
  final double cornerRadius;

  StraightSegment({
    required this.color,
    required Vector2 size,
    this.cornerRadius = 5.0,
    super.position,
    super.angle,
    super.anchor,
  }) : super(size: size);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(size: size));
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    if (other is PlayerBall && other.currentColor != color) {
      game.triggerGameOver();
    }
    super.onCollisionStart(points, other);
  }

  @override
  void render(Canvas canvas) {
    final rrect = RRect.fromRectAndRadius(
      size.toRect(),
      Radius.circular(cornerRadius),
    );

    // Draw with neon glow
    canvas.drawRRect(rrect, getNeonPaint(color));
  }
}
