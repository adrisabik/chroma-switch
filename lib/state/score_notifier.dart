import 'package:flutter/foundation.dart';

/// Manages the game score
///
/// This notifier bridges Flame components to Riverpod.
/// When collecting a color switcher, Flame calls `increment()`.
/// Riverpod providers listen to rebuild the score HUD.
class ScoreNotifier extends ChangeNotifier {
  int _score = 0;
  int _highScore = 0;

  /// Current game score
  int get score => _score;

  /// Highest score achieved (loaded from storage)
  int get highScore => _highScore;

  /// Whether current score is a new high score
  bool get isNewHighScore => _score > _highScore && _score > 0;

  /// Increment score by 1 (on collecting color switcher)
  void increment() {
    _score++;
    notifyListeners();
  }

  /// Increment score by a specific amount
  void incrementBy(int amount) {
    _score += amount;
    notifyListeners();
  }

  /// Reset score to 0 (on game restart)
  void reset() {
    _score = 0;
    notifyListeners();
  }

  /// Set high score (loaded from persistent storage)
  void setHighScore(int value) {
    _highScore = value;
    notifyListeners();
  }

  /// Update high score if current score is higher
  /// Returns true if high score was updated
  bool updateHighScoreIfNeeded() {
    if (_score > _highScore) {
      _highScore = _score;
      notifyListeners();
      return true;
    }
    return false;
  }
}
