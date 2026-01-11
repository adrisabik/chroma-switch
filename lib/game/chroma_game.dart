import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/components/player_ball.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// Main Flame game class for Chroma Switch
///
/// This is the core game loop that runs at 60 FPS.
///
/// Architecture Notes:
/// - Never use Riverpod watchers inside update() - causes frame drops
/// - Access GetIt services directly for state updates
/// - Use HasCollisionDetection mixin for collision callbacks
class ChromaGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  /// The player ball component
  late PlayerBall playerBall;

  ChromaGame();

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Start the game in playing state
    getIt<GameStateNotifier>().startGame();

    // Add player ball
    playerBall = PlayerBall();
    await add(playerBall);

    // TODO: Sprint 2.2 - Add obstacle manager
    // TODO: Sprint 3.2 - Add camera follow

    debugPrint('ChromaGame loaded');
  }

  /// Handle tap anywhere on screen to make player jump
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Only jump if game is actively playing
    if (getIt<GameStateNotifier>().isPlaying) {
      playerBall.jump();
    }
  }

  /// Trigger game over state
  /// Called when player collides with wrong color segment or falls
  void triggerGameOver() {
    // Update high score if needed
    getIt<ScoreNotifier>().updateHighScoreIfNeeded();

    // Set game state to game over
    getIt<GameStateNotifier>().setGameOver();

    // TODO: Sprint 4.1 - Add death effects
    // - Spawn death particles
    // - Screen shake

    debugPrint('Game Over triggered');
  }

  /// Restart the game
  void restart() {
    // Reset score
    getIt<ScoreNotifier>().reset();

    // Start new game
    getIt<GameStateNotifier>().startGame();

    // Reset player ball
    playerBall.reset();

    // TODO: Sprint 3.2 - Clear and respawn obstacles

    debugPrint('Game restarting');
  }

  /// Flash the screen white (on color collect)
  void flashScreen() {
    // TODO: Sprint 4.1 - Implement screen flash
    debugPrint('Screen flash');
  }
}
