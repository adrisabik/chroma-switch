import 'package:get_it/get_it.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// Global GetIt instance
final getIt = GetIt.instance;

/// Setup all dependencies for the application
///
/// This function MUST be called before runApp().
///
/// Architecture Notes:
/// - Core services are registered as lazy singletons
/// - State notifiers bridge Flame components to Riverpod
/// - Flame components access state via GetIt (NOT Riverpod watchers)
void setupDependencies() {
  // ============================================
  // State Bridge (Flame → Riverpod)
  // ============================================

  // GameStateNotifier - manages menu/playing/gameOver states
  getIt.registerLazySingleton<GameStateNotifier>(() => GameStateNotifier());

  // ScoreNotifier - manages current score and high score
  getIt.registerLazySingleton<ScoreNotifier>(() => ScoreNotifier());

  // ============================================
  // Core Services (to be added in later sprints)
  // ============================================

  // TODO: Sprint 4.2 - AudioService
  // getIt.registerLazySingleton<AudioService>(() => AudioService());

  // TODO: Sprint 4.4 - StorageService
  // getIt.registerLazySingleton<StorageService>(() => StorageService());
}
