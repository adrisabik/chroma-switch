import 'dart:ui';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/color_switcher.dart';
import 'package:chroma_switch/game/components/obstacle/obstacle_ring.dart';
import 'package:chroma_switch/game/logic/obstacle_pool.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// Manages infinite spawning and recycling of obstacles
///
/// Handles the spawning of ObstacleRings and ColorSwitchers above
/// the camera viewport, and recycles them when they fall below.
///
/// Difficulty scaling is applied based on current score.
class ObstacleManager extends Component with HasGameReference<ChromaGame> {
  final ObstaclePool _pool = ObstaclePool();
  final List<ObstacleRing> _activeObstacles = [];
  final List<ColorSwitcher> _activeSwitchers = [];

  /// Y position for next obstacle spawn (negative = above screen)
  double _nextSpawnY = 0;

  /// Base gap between obstacles
  final double baseSpawnGap = GameConstants.spawnDistance;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set initial spawn relative to starting player position (center of screen)
    // This ensures the first obstacle is visible or just above the screen
    _nextSpawnY = (game.size.y / 2) - GameConstants.spawnDistance;

    // Spawn initial obstacles
    _spawnInitialObstacles();
  }

  /// Spawn initial set of obstacles at game start
  void _spawnInitialObstacles() {
    // Spawn first 3 obstacles above screen
    for (int i = 0; i < 3; i++) {
      _spawnNextObstacle();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Check if we need to spawn more obstacles
    final cameraTop = game.camera.viewfinder.position.y - (game.size.y / 2);
    if (_nextSpawnY > cameraTop - baseSpawnGap * 2) {
      _spawnNextObstacle();
    }

    // Recycle obstacles below camera
    _recycleOffscreenObstacles();
  }

  /// Spawn the next obstacle and color switcher
  void _spawnNextObstacle() {
    final currentScore = getIt<ScoreNotifier>().score;

    // Get difficulty multipliers
    final rotationMultiplier = getRotationMultiplier(currentScore);
    final gapMultiplier = getSpawnGapMultiplier(currentScore);

    // Calculate spawn position
    final spawnY = _nextSpawnY;
    final spawnX = game.size.x / 2;

    // Spawn obstacle ring
    final obstacle = _pool.acquireObstacle();
    obstacle.position = Vector2(spawnX, spawnY);
    // Apply difficulty-scaled rotation speed
    obstacle.reset(
      newRotationSpeed: GameConstants.baseRotationSpeed * rotationMultiplier,
    );

    _activeObstacles.add(obstacle);
    game.add(obstacle);

    // Spawn color switcher at midpoint between this and previous obstacle
    if (_activeObstacles.length > 1) {
      final prevObstacle = _activeObstacles[_activeObstacles.length - 2];
      final switcherY = (prevObstacle.position.y + spawnY) / 2;

      final switcher = _pool.acquireSwitcher();
      switcher.position = Vector2(spawnX, switcherY);

      // Set valid colors based on next obstacle's segments
      switcher.nextValidColors?.clear();
      // All colors are valid since ring has all 4 colors
      // ignore: unused_local_variable
      final validColors = obstacle.segments.map((s) => s.color).toList();

      _activeSwitchers.add(switcher);
      game.add(switcher);
    }

    // Update next spawn position with difficulty-adjusted gap
    _nextSpawnY = spawnY - (baseSpawnGap * gapMultiplier);
  }

  /// Get the colors of the next obstacle the player will encounter
  ///
  /// Used for color switcher "color safety" logic to ensure the player
  /// receives a color that can actually pass through the next ring.
  List<Color> getNextObstacleColors() {
    if (_activeObstacles.isEmpty) return AppColors.gameColors;

    // The "next" obstacle is the one at the highest Y (least negative)
    // that the player hasn't passed yet.
    return _activeObstacles.first.segments.map((s) => s.color).toList();
  }

  /// Recycle obstacles that have fallen below the camera
  void _recycleOffscreenObstacles() {
    final cameraBottom = game.camera.viewfinder.position.y + (game.size.y / 2);
    final deathZone = cameraBottom + GameConstants.deathZoneOffset;

    // Recycle obstacles
    _activeObstacles.removeWhere((obstacle) {
      if (obstacle.position.y > deathZone) {
        obstacle.removeFromParent();
        _pool.releaseObstacle(obstacle);
        return true;
      }
      return false;
    });

    // Recycle switchers
    _activeSwitchers.removeWhere((switcher) {
      if (switcher.position.y > deathZone) {
        switcher.removeFromParent();
        _pool.releaseSwitcher(switcher);
        return true;
      }
      return false;
    });
  }

  /// Reset manager for new game
  void reset() {
    // Remove all active obstacles
    for (final obstacle in _activeObstacles) {
      obstacle.removeFromParent();
      _pool.releaseObstacle(obstacle);
    }
    _activeObstacles.clear();

    // Remove all active switchers
    for (final switcher in _activeSwitchers) {
      switcher.removeFromParent();
      _pool.releaseSwitcher(switcher);
    }
    _activeSwitchers.clear();

    // Reset spawn position relative to center
    _nextSpawnY = (game.size.y / 2) - GameConstants.spawnDistance;

    // Spawn initial obstacles
    _spawnInitialObstacles();
  }

  // ============================================
  // Difficulty Scaling Functions
  // ============================================

  /// Get rotation speed multiplier based on score (3-tier system)
  ///
  /// - Easy (score < easyThreshold): 0.7x (slower, gentler start)
  /// - Medium (score < mediumThreshold): 1.0x (normal speed)
  /// - Hard (score >= mediumThreshold): 1.5x (challenging)
  double getRotationMultiplier(int score) {
    if (score < GameConstants.easyThreshold) {
      return 0.7; // Easy - slower rotation
    } else if (score < GameConstants.mediumThreshold) {
      return 1.0; // Medium - normal speed
    } else {
      return 1.5; // Hard - fast rotation
    }
  }

  /// Get spawn gap multiplier based on score (3-tier system)
  ///
  /// - Easy (score < easyThreshold): 1.2x (more space)
  /// - Medium (score < mediumThreshold): 1.0x (normal spacing)
  /// - Hard (score >= mediumThreshold): 0.8x (tighter spacing)
  double getSpawnGapMultiplier(int score) {
    if (score < GameConstants.easyThreshold) {
      return 1.2; // Easy - more space between obstacles
    } else if (score < GameConstants.mediumThreshold) {
      return 1.0; // Medium - normal spacing
    } else {
      return 0.8; // Hard - tighter spacing
    }
  }

  /// Get list of active obstacles (for testing/debugging)
  List<ObstacleRing> get activeObstacles => List.unmodifiable(_activeObstacles);

  /// Get list of active switchers (for testing/debugging)
  List<ColorSwitcher> get activeSwitchers =>
      List.unmodifiable(_activeSwitchers);
}
