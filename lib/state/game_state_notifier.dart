import 'package:flutter/foundation.dart';

/// Game state enumeration
enum GameStatus {
  /// Start menu is displayed
  menu,

  /// Game is actively playing
  playing,

  /// Game over screen is displayed
  gameOver,
}

/// Manages game state transitions
///
/// This notifier bridges Flame components to Riverpod.
/// Flame components call methods on this notifier to update state,
/// and Riverpod providers listen to changes to rebuild Flutter UI.
///
/// Flow:
/// 1. Flame component detects state change (e.g., collision)
/// 2. Flame calls `GetIt.I<GameStateNotifier>().setGameOver()`
/// 3. Notifier calls `notifyListeners()`
/// 4. Riverpod provider rebuilds Flutter widgets
class GameStateNotifier extends ChangeNotifier {
  GameStatus _status = GameStatus.menu;

  /// Current game status
  GameStatus get status => _status;

  /// Whether the game is currently in menu state
  bool get isMenu => _status == GameStatus.menu;

  /// Whether the game is currently playing
  bool get isPlaying => _status == GameStatus.playing;

  /// Whether the game is in game over state
  bool get isGameOver => _status == GameStatus.gameOver;

  /// Start a new game
  void startGame() {
    if (_status != GameStatus.playing) {
      _status = GameStatus.playing;
      notifyListeners();
    }
  }

  /// Trigger game over state
  void setGameOver() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.gameOver;
      notifyListeners();
    }
  }

  /// Return to main menu
  void returnToMenu() {
    _status = GameStatus.menu;
    notifyListeners();
  }

  /// Reset to initial state (for testing)
  void reset() {
    _status = GameStatus.menu;
    notifyListeners();
  }
}
