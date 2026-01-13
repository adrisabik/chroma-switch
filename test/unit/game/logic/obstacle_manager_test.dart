import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_switch/game/logic/obstacle_manager.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/state/score_notifier.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';
import 'package:chroma_switch/core/services/storage_service.dart';
import 'package:chroma_switch/core/services/audio_service.dart';

class ManualMockStorageService implements StorageService {
  @override
  Future<void> init() async {}
  @override
  Future<void> clear() async {}
  @override
  int getHighScore() => 0;
  @override
  Future<bool> saveHighScore(int score) async => true;
}

class ManualMockAudioService implements AudioService {
  @override
  Future<void> init() async {}
  @override
  void playJump() {}
  @override
  void playCollect() {}
  @override
  void playCrash() {}
  @override
  void dispose() {}
  @override
  void pauseBgm() {}
  @override
  void playBgm(String name) {}
  @override
  void playSfx(String name) {}
  @override
  void resumeBgm() {}
  @override
  void stopBgm() {}
  @override
  void toggleMusic() {}
  @override
  void toggleSound() {}
  @override
  bool get musicEnabled => true;
  @override
  bool get soundEnabled => true;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ObstacleManager obstacleManager;
  late ChromaGame game;

  setUp(() async {
    // Reset GetIt
    await getIt.reset();

    // Register manual mocks
    getIt.registerSingleton<StorageService>(ManualMockStorageService());
    getIt.registerSingleton<AudioService>(ManualMockAudioService());
    getIt.registerSingleton<ScoreNotifier>(ScoreNotifier());
    getIt.registerSingleton<GameStateNotifier>(GameStateNotifier());

    game = ChromaGame();
    // We need to set a size for the game so calculations work
    game.onGameResize(Vector2(400, 800));

    obstacleManager = ObstacleManager();
    await game.add(obstacleManager);
  });

  group('ObstacleManager', () {
    test('initializes _nextSpawnY relative to player position', () async {
      // Player starts at game.size.y / 2 = 400
      // Expected _nextSpawnY = 400 - spawnDistance (300) = 100

      // Wait for components to load
      await game.ready();

      expect(obstacleManager.activeObstacles.isNotEmpty, isTrue);
      // The first obstacle should be at 100
      expect(obstacleManager.activeObstacles.first.position.y, equals(100));
    });

    test('spawns 3 initial obstacles', () async {
      await game.ready();
      expect(obstacleManager.activeObstacles.length, equals(3));
    });

    test('spawns color switchers between obstacles', () async {
      await game.ready();
      // Total 3 obstacles, so 2 switchers between them
      expect(obstacleManager.activeSwitchers.length, equals(2));
    });

    test('reset clears and respawns obstacles', () async {
      await game.ready();
      final firstObstacleId = obstacleManager.activeObstacles.first.hashCode;

      obstacleManager.reset();

      expect(obstacleManager.activeObstacles.length, equals(3));
      expect(
        obstacleManager.activeObstacles.first.hashCode,
        isNot(equals(firstObstacleId)),
      );
      expect(obstacleManager.activeObstacles.first.position.y, equals(100));
    });

    group('Camera Boundary Logic', () {
      test('update spawns more obstacles if camera moves up', () async {
        await game.ready();
        final initialCount = obstacleManager.activeObstacles.length;

        // Move camera up (viewfinder Y decreases)
        // Initial viewfinder: 400 (center of 800 height)
        // Move viewfinder to -400 (viewport: -800 to 0)
        game.camera.viewfinder.position = Vector2(200, -400);

        // Update obstacle manager
        obstacleManager.update(0.1);

        expect(
          obstacleManager.activeObstacles.length,
          greaterThan(initialCount),
        );
      });
    });
  });
}
