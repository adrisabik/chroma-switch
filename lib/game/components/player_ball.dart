import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/neon_paint.dart';
import 'package:chroma_switch/game/chroma_game.dart';

/// Player ball component with gravity physics and neon glow
///
/// The player ball is the main controllable element in the game.
/// It falls due to gravity and jumps when the player taps the screen.
///
/// Key behaviors:
/// - Falls with constant gravity (800 px/s²)
/// - Jumps with impulse (-350 px/s) on tap
/// - Stays horizontally centered
/// - Changes color when collecting ColorSwitcher
class PlayerBall extends PositionComponent
    with HasGameReference<ChromaGame>, CollisionCallbacks {
  /// Current color of the ball (determines safe passage through rings)
  Color currentColor;

  /// Velocity vector (only Y component used for vertical movement)
  late Vector2 velocity;

  /// Ball radius from GameConstants
  final double radius = GameConstants.ballRadius;

  /// Creates a PlayerBall with optional initial color
  PlayerBall({Color? initialColor})
    : currentColor = initialColor ?? AppColors.cyan;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize velocity
    velocity = Vector2.zero();

    // Center the ball on screen
    position = Vector2(game.size.x / 2, game.size.y / 2);

    // Set size for proper anchor calculations
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;

    // Add collision hitbox
    add(CircleHitbox(radius: radius));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    velocity.y += GameConstants.gravity * dt;

    // Update position
    position += velocity * dt;

    // Lock X position to screen center
    position.x = game.size.x / 2;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw core (solid fill)
    canvas.drawCircle(Offset.zero, radius, getCorePaint(currentColor));

    // Draw neon glow effect
    canvas.drawCircle(
      Offset.zero,
      radius,
      getNeonPaint(currentColor, blurRadius: 8.0),
    );
  }

  /// Make the ball jump upward
  void jump() {
    velocity.y = GameConstants.jumpImpulse;
  }

  /// Change the ball's color
  void setColor(Color newColor) {
    currentColor = newColor;
  }

  /// Reset ball to initial state
  void reset() {
    velocity = Vector2.zero();
    position = Vector2(game.size.x / 2, game.size.y / 2);
    currentColor = AppColors.cyan;
  }
}
