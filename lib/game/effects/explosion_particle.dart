import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';

/// Death effect particle that bursts radially from player position
///
/// Each particle has:
/// - Random velocity in all directions
/// - Gravity affecting downward movement
/// - Lifetime that controls fade-out
///
/// 25 particles are spawned on death for dramatic effect.
class ExplosionParticle extends PositionComponent {
  /// Color of the particle (matches player's color at death)
  final Color color;

  /// Velocity vector updated each frame
  late Vector2 velocity;

  /// Remaining lifetime in seconds
  late double lifetime;

  /// Initial lifetime for calculating opacity
  late double initialLifetime;

  ExplosionParticle({required Vector2 position, required this.color})
    : super(position: position) {
    // Random velocity in all directions
    final random = Random();
    final angle = random.nextDouble() * 2 * pi;
    final speed = 100 + random.nextDouble() * 200;
    velocity = Vector2(cos(angle), sin(angle)) * speed;

    // Random lifetime between 1.0 and 2.0 seconds
    lifetime = 1.0 + random.nextDouble();
    initialLifetime = lifetime;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity (half strength for floaty feel)
    velocity.y += GameConstants.gravity * 0.5 * dt;

    // Update position
    position += velocity * dt;

    // Decrease lifetime
    lifetime -= dt;

    // Remove when lifetime expires
    if (lifetime <= 0) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate opacity based on remaining lifetime
    final opacity = (lifetime / initialLifetime).clamp(0.0, 1.0);

    // Draw glowing particle
    canvas.drawCircle(
      Offset.zero,
      3.0,
      Paint()
        ..color = color.withValues(alpha: opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4.0),
    );

    // Draw solid core
    canvas.drawCircle(
      Offset.zero,
      2.0,
      Paint()..color = color.withValues(alpha: opacity * 0.8),
    );
  }
}
