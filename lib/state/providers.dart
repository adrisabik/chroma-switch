import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// Provider for game state (menu/playing/gameOver)
///
/// Usage in Flutter widgets:
/// ```dart
/// final gameState = ref.watch(gameStateProvider);
/// if (gameState.isGameOver) {
///   // Show game over overlay
/// }
/// ```
final gameStateProvider = ChangeNotifierProvider<GameStateNotifier>((ref) {
  return getIt<GameStateNotifier>();
});

/// Provider for current score
///
/// Usage in Flutter widgets:
/// ```dart
/// final scoreNotifier = ref.watch(scoreProvider);
/// Text('Score: ${scoreNotifier.score}')
/// ```
final scoreProvider = ChangeNotifierProvider<ScoreNotifier>((ref) {
  return getIt<ScoreNotifier>();
});
