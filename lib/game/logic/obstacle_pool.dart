import 'package:chroma_switch/game/components/obstacle/obstacle_ring.dart';
import 'package:chroma_switch/game/components/obstacle/spinning_cross.dart';
import 'package:chroma_switch/game/components/obstacle/horizontal_bars.dart';
import 'package:chroma_switch/game/components/color_switcher.dart';

/// Object pool for game components to avoid GC pressure
class ObstaclePool {
  final List<ObstacleRing> _ringPool = [];
  final List<SpinningCross> _crossPool = [];
  final List<HorizontalBars> _barPool = [];
  final List<ColorSwitcher> _switcherPool = [];

  /// Maximum pool size to prevent memory bloat
  static const int maxPoolSize = 10;

  /// Acquire an obstacle ring
  ObstacleRing acquireRing() {
    if (_ringPool.isNotEmpty) {
      return _ringPool.removeLast();
    }
    return ObstacleRing();
  }

  /// Release an obstacle ring
  void releaseRing(ObstacleRing obstacle) {
    if (_ringPool.length < maxPoolSize) {
      obstacle.reset();
      _ringPool.add(obstacle);
    }
  }

  /// Acquire a spinning cross
  SpinningCross acquireCross() {
    if (_crossPool.isNotEmpty) {
      return _crossPool.removeLast();
    }
    return SpinningCross();
  }

  /// Release a spinning cross
  void releaseCross(SpinningCross obstacle) {
    if (_crossPool.length < maxPoolSize) {
      obstacle.reset();
      _crossPool.add(obstacle);
    }
  }

  /// Acquire horizontal bars
  HorizontalBars acquireBar() {
    if (_barPool.isNotEmpty) {
      return _barPool.removeLast();
    }
    return HorizontalBars();
  }

  /// Release horizontal bars
  void releaseBar(HorizontalBars obstacle) {
    if (_barPool.length < maxPoolSize) {
      obstacle.reset();
      _barPool.add(obstacle);
    }
  }

  /// Acquire a color switcher
  ColorSwitcher acquireSwitcher() {
    if (_switcherPool.isNotEmpty) {
      return _switcherPool.removeLast();
    }
    return ColorSwitcher();
  }

  /// Release a color switcher
  void releaseSwitcher(ColorSwitcher switcher) {
    if (_switcherPool.length < maxPoolSize) {
      _switcherPool.add(switcher);
    }
  }

  /// Clear all pooled objects
  void clear() {
    _ringPool.clear();
    _crossPool.clear();
    _barPool.clear();
    _switcherPool.clear();
  }

  // Deprecated single-type methods kept for temporary compat if needed,
  // but better to remove to force refactor.
}
