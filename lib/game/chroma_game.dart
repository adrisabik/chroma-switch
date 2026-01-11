import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';

/// Main Flame game class for Chroma Switch
///
/// This is the core game loop that runs at 60 FPS.
///
/// Architecture Notes:
/// - Never use Riverpod watchers inside update() - causes frame drops
/// - Access GetIt services directly for state updates
/// - Use HasCollisionDetection mixin for collision callbacks
class ChromaGame extends FlameGame with HasCollisionDetection {
  ChromaGame();

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // TODO: Sprint 1.2 - Add player ball
    // TODO: Sprint 2.2 - Add obstacle manager
    // TODO: Sprint 3.2 - Add camera follow

    debugPrint('ChromaGame loaded');
  }

  /// Trigger game over state
  /// Called when player collides with wrong color segment or falls
  void triggerGameOver() {
    // TODO: Sprint 2.2 - Implement death sequence
    // - Spawn death particles
    // - Screen shake
    // - Update game state notifier
    debugPrint('Game Over triggered');
  }

  /// Restart the game
  void restart() {
    // TODO: Sprint 1.2 - Implement restart
    // - Reset player position
    // - Clear obstacles
    // - Reset score
    debugPrint('Game restarting');
  }

  /// Flash the screen white (on color collect)
  void flashScreen() {
    // TODO: Sprint 4.1 - Implement screen flash
    debugPrint('Screen flash');
  }
}
