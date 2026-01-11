import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flame/collisions.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/components/player_ball.dart';

void main() {
  group('PlayerBall', () {
    test('initializes with cyan color by default', () {
      final playerBall = PlayerBall();
      expect(playerBall.currentColor, equals(AppColors.cyan));
    });

    test('initializes with custom color when provided', () {
      final playerBall = PlayerBall(initialColor: AppColors.magenta);
      expect(playerBall.currentColor, equals(AppColors.magenta));
    });

    test('has correct radius from GameConstants', () {
      final playerBall = PlayerBall();
      expect(playerBall.radius, equals(GameConstants.ballRadius));
      expect(playerBall.radius, equals(20.0));
    });

    test('jump sets velocity to jump impulse', () {
      final playerBall = PlayerBall();
      // Initialize velocity manually for unit test
      playerBall.velocity = Vector2.zero();

      playerBall.jump();

      expect(playerBall.velocity.y, equals(GameConstants.jumpImpulse));
      expect(playerBall.velocity.y, equals(-350.0));
      expect(playerBall.velocity.y, lessThan(0));
    });

    test('setColor changes current color', () {
      final playerBall = PlayerBall();
      expect(playerBall.currentColor, equals(AppColors.cyan));

      playerBall.setColor(AppColors.purple);
      expect(playerBall.currentColor, equals(AppColors.purple));

      playerBall.setColor(AppColors.yellow);
      expect(playerBall.currentColor, equals(AppColors.yellow));
    });

    test('gravity constant is correct', () {
      // Verify game constants are as expected
      expect(GameConstants.gravity, equals(800.0));
      expect(GameConstants.jumpImpulse, equals(-350.0));
      expect(GameConstants.ballRadius, equals(20.0));
    });

    test('player ball mixes in CollisionCallbacks', () {
      final playerBall = PlayerBall();
      // Verify it can be cast to CollisionCallbacks
      expect(playerBall, isA<CollisionCallbacks>());
    });

    test('multiple jumps reset velocity each time', () {
      final playerBall = PlayerBall();
      playerBall.velocity = Vector2.zero();

      // First jump
      playerBall.jump();
      expect(playerBall.velocity.y, equals(GameConstants.jumpImpulse));

      // Simulate gravity pulling down
      playerBall.velocity.y = 200; // Falling

      // Second jump should reset to jump impulse
      playerBall.jump();
      expect(playerBall.velocity.y, equals(GameConstants.jumpImpulse));
    });

    test('can cycle through all game colors', () {
      final playerBall = PlayerBall();

      for (final color in AppColors.gameColors) {
        playerBall.setColor(color);
        expect(playerBall.currentColor, equals(color));
      }
    });
  });
}
