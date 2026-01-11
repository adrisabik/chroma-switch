import 'package:chroma_switch/game/components/obstacle/obstacle_ring.dart';
import 'package:chroma_switch/game/components/color_switcher.dart';

/// Object pool for game components to avoid GC pressure
///
/// Pools obstacles and color switchers to reuse instead of
/// creating new instances. This is critical for 60 FPS performance.
class ObstaclePool {
  final List<ObstacleRing> _obstaclePool = [];
  final List<ColorSwitcher> _switcherPool = [];

  /// Maximum pool size to prevent memory bloat
  static const int maxPoolSize = 10;

  /// Acquire an obstacle ring from the pool
  ///
  /// Returns a pooled instance if available, otherwise creates new.
  ObstacleRing acquireObstacle() {
    if (_obstaclePool.isNotEmpty) {
      return _obstaclePool.removeLast();
    }
    return ObstacleRing();
  }

  /// Release an obstacle ring back to the pool
  void releaseObstacle(ObstacleRing obstacle) {
    if (_obstaclePool.length < maxPoolSize) {
      obstacle.reset();
      _obstaclePool.add(obstacle);
    }
  }

  /// Acquire a color switcher from the pool
  ColorSwitcher acquireSwitcher() {
    if (_switcherPool.isNotEmpty) {
      return _switcherPool.removeLast();
    }
    return ColorSwitcher();
  }

  /// Release a color switcher back to the pool
  void releaseSwitcher(ColorSwitcher switcher) {
    if (_switcherPool.length < maxPoolSize) {
      _switcherPool.add(switcher);
    }
  }

  /// Clear all pooled objects
  void clear() {
    _obstaclePool.clear();
    _switcherPool.clear();
  }

  /// Current pool sizes for debugging
  int get obstaclePoolSize => _obstaclePool.length;
  int get switcherPoolSize => _switcherPool.length;
}
