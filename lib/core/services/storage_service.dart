import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting game data using SharedPreferences
///
/// Handles high score storage and retrieval across app restarts.
class StorageService {
  /// SharedPreferences instance
  SharedPreferences? _prefs;

  /// Key for high score storage
  static const String _highScoreKey = 'high_score';

  /// Initialize the storage service
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint('StorageService initialized');
    } catch (e) {
      debugPrint('StorageService init error: $e');
    }
  }

  /// Get the stored high score
  ///
  /// Returns 0 if no high score has been saved yet.
  int getHighScore() {
    return _prefs?.getInt(_highScoreKey) ?? 0;
  }

  /// Save a new high score
  ///
  /// Only saves if the new score is greater than the current high score.
  /// Returns true if the score was saved (new high score achieved).
  Future<bool> saveHighScore(int score) async {
    final currentHighScore = getHighScore();

    if (score > currentHighScore) {
      await _prefs?.setInt(_highScoreKey, score);
      debugPrint('New high score saved: $score');
      return true;
    }

    return false;
  }

  /// Clear all stored data (for testing/debugging)
  Future<void> clear() async {
    await _prefs?.clear();
    debugPrint('StorageService cleared');
  }
}
