import 'dart:ui';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/obstacle/base_obstacle.dart';
import 'package:chroma_switch/game/components/obstacle/straight_segment.dart';

/// Horizontal bars moving across the screen
class HorizontalBars extends BaseObstacle with HasGameReference<ChromaGame> {
  final double baseMoveSpeed; // Pixels per second

  double _currentMoveSpeed = 0;
  final List<StraightSegment> segments = [];
  final List<double> _directions = []; // 1 or -1 for each row

  HorizontalBars({
    this.baseMoveSpeed = 100.0, // Default speed
    super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    _createBars();
  }

  void _createBars() {
    final colors = AppColors.gameColors.toList()..shuffle();
    segments.clear();
    _directions.clear();
    removeAll(children);

    final barWidth = GameConstants.ringOuterRadius * 1.5;
    final barHeight = GameConstants.ringThickness;
    final size = Vector2(barWidth, barHeight);

    // Create 2 rows of bars
    for (int i = 0; i < 2; i++) {
      final yOffset = i == 0 ? -40.0 : 40.0;
      final direction = i == 0 ? 1.0 : -1.0;

      final segment = StraightSegment(
        color: colors[i],
        size: size,
        anchor: Anchor.center,
      );

      segment.position = Vector2(0, yOffset);

      segments.add(segment);
      _directions.add(direction);
      add(segment);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move bars horizontally
    // Oscillate using sine wave for smooth containment or just ping-pong?
    // Let's do simple ping-pong within a range.

    final limit = GameConstants.ringOuterRadius - 20; // Some bounds

    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final direction = _directions[i];

      segment.position.x += _currentMoveSpeed * direction * dt;

      // Ping-pong bounce
      if (segment.position.x > limit && direction > 0) {
        _directions[i] = -1.0;
      } else if (segment.position.x < -limit && direction < 0) {
        _directions[i] = 1.0;
      }
    }
  }

  @override
  List<Color> get validColors => segments.map((s) => s.color).toList();

  @override
  void reset({Vector2? position, double difficultyMultiplier = 1.0}) {
    if (position != null) {
      this.position = position;
    }

    _currentMoveSpeed = baseMoveSpeed * difficultyMultiplier;

    _createBars();
  }
}
