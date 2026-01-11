import 'package:get_it/get_it.dart';
import 'package:chroma_switch/core/services/audio_service.dart';
import 'package:chroma_switch/core/services/storage_service.dart';
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
  // Core Services
  // ============================================

  // AudioService - manages SFX and BGM playback
  getIt.registerLazySingleton<AudioService>(() => AudioService());

  // StorageService - manages high score persistence
  getIt.registerLazySingleton<StorageService>(() => StorageService());

  // ============================================
  // State Bridge (Flame → Riverpod)
  // ============================================

  // GameStateNotifier - manages menu/playing/gameOver states
  getIt.registerLazySingleton<GameStateNotifier>(() => GameStateNotifier());

  // ScoreNotifier - manages current score and high score
  getIt.registerLazySingleton<ScoreNotifier>(() => ScoreNotifier());
}

/// Initialize async services
///
/// Called after setupDependencies() to initialize services that
/// require async initialization (e.g., SharedPreferences, audio preload).
Future<void> initializeServices() async {
  await getIt<StorageService>().init();
  await getIt<AudioService>().init();
}
