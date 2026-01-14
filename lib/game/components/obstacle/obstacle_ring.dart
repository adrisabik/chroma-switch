import 'dart:math';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/obstacle/base_obstacle.dart';
import 'package:chroma_switch/game/components/obstacle/ring_segment.dart';
import 'package:flutter/painting.dart';

/// A complete obstacle ring composed of 4 colored segments
///
/// The ring contains 4 RingSegment children, each spanning 90° (π/2).
/// The ring rotates at a configurable speed to add difficulty.
class ObstacleRing extends BaseObstacle with HasGameReference<ChromaGame> {
  /// Base rotation speed in radians per second
  final double baseRotationSpeed;

  /// Current rotation speed including direction
  double _currentRotationSpeed;

  /// The 4 ring segments
  List<RingSegment> segments = [];

  /// Current rotation angle
  double _currentAngle = 0.0;

  ObstacleRing({
    this.baseRotationSpeed = GameConstants.baseRotationSpeed,
    super.position,
  }) : _currentRotationSpeed = baseRotationSpeed;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Anchor at center for proper rotation
    anchor = Anchor.center;

    // Create 4 segments, each 90° (π/2) apart with shuffled colors
    _createSegments();
  }

  void _createSegments() {
    final colors = AppColors.gameColors.toList()..shuffle();
    segments.clear();
    // Remove existing children if any (for safety, though usually clear on reset)
    removeAll(children);

    for (int i = 0; i < 4; i++) {
      final segment = RingSegment(
        color: colors[i],
        startAngle: (pi / 2) * i, // 0, π/2, π, 3π/2
      );
      segments.add(segment);
      add(segment);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply rotation
    _currentAngle += _currentRotationSpeed * dt;
    angle = _currentAngle;
  }

  @override
  List<Color> get validColors => segments.map((s) => s.color).toList();

  @override
  void reset({Vector2? position, double difficultyMultiplier = 1.0}) {
    _currentAngle = 0.0;
    angle = 0.0;

    if (position != null) {
      this.position = position;
    }

    // Randomize rotation direction
    final isReverse = Random().nextBool();
    final direction = isReverse ? -1.0 : 1.0;

    _currentRotationSpeed =
        baseRotationSpeed * difficultyMultiplier * direction;

    // Reshuffle colors for variety
    // We need to re-create segments or update their colors.
    // Re-creating is safer to ensure state consistency.
    // Optimization: In a tight loop, we might just update colors,
    // but recreating 4 components is negligible here.
    _createSegments();

    // Random initial rotation
    randomizeRotation();
  }

  /// Randomize the starting rotation
  void randomizeRotation() {
    final random = Random();
    _currentAngle = random.nextDouble() * 2 * pi;
    angle = _currentAngle;
  }

  /// Reverse the rotation direction
  void reverseRotation() {
    _currentRotationSpeed = -_currentRotationSpeed;
  }
}
