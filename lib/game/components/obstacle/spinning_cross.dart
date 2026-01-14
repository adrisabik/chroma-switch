import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/obstacle/base_obstacle.dart';
import 'package:chroma_switch/game/components/obstacle/straight_segment.dart';

/// A rotating cross obstacle made of 4 straight segments
class SpinningCross extends BaseObstacle with HasGameReference<ChromaGame> {
  final double baseRotationSpeed;

  double _currentRotationSpeed;
  double _currentAngle = 0.0;

  final List<StraightSegment> segments = [];

  SpinningCross({
    this.baseRotationSpeed = GameConstants.baseRotationSpeed,
    super.position,
  }) : _currentRotationSpeed = baseRotationSpeed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    anchor = Anchor.center;
    _createSegments();
  }

  void _createSegments() {
    final colors = AppColors.gameColors.toList()..shuffle();
    segments.clear();
    removeAll(children);

    final armLength =
        GameConstants.ringOuterRadius * 0.9; // Slightly smaller than ring
    final thickness = GameConstants.ringThickness;
    final size = Vector2(armLength, thickness);

    for (int i = 0; i < 4; i++) {
      // Calculate position offset for each arm to radiate from center
      // 0: Right, 1: Down, 2: Left, 3: Up
      final angle = (pi / 2) * i;

      // Position is offset by half length so it spins around center
      // But StraightSegment anchor is usually top-left. Let's set it to center-left

      final segment = StraightSegment(
        color: colors[i],
        size: size,
        anchor: Anchor.centerLeft, // Pivot at the start of the bar
      );

      // Rotate the segment itself
      segment.angle = angle;

      // We essentially just place them all at 0,0 (center of this component)
      // but rotated.
      segment.position = Vector2.zero();

      segments.add(segment);
      add(segment);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _currentAngle += _currentRotationSpeed * dt;
    angle = _currentAngle;
  }

  @override
  List<Color> get validColors => segments.map((s) => s.color).toList();

  @override
  void reset({Vector2? position, double difficultyMultiplier = 1.0}) {
    _currentAngle = 0.0;
    angle = 0.0; // Reset visual rotation

    if (position != null) {
      this.position = position;
    }

    final isReverse = Random().nextBool();
    final direction = isReverse ? -1.0 : 1.0;
    _currentRotationSpeed =
        baseRotationSpeed * difficultyMultiplier * direction;

    _createSegments();

    // Random initial rotation
    randomizeRotation();
  }

  void randomizeRotation() {
    final random = Random();
    _currentAngle = random.nextDouble() * 2 * pi;
    angle = _currentAngle;
  }
}
