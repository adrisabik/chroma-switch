import 'dart:math';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/obstacle/ring_segment.dart';

/// A complete obstacle ring composed of 4 colored segments
///
/// The ring contains 4 RingSegment children, each spanning 90° (π/2).
/// The ring rotates at a configurable speed to add difficulty.
///
/// Key behaviors:
/// - Composed of 4 color segments (cyan, magenta, yellow, purple)
/// - Rotates continuously at `rotationSpeed` rad/s
/// - Can be reset for object pooling
class ObstacleRing extends PositionComponent with HasGameReference<ChromaGame> {
  /// Rotation speed in radians per second
  final double rotationSpeed;

  /// The 4 ring segments
  late List<RingSegment> segments;

  /// Current rotation angle
  double _currentAngle = 0.0;

  ObstacleRing({
    this.rotationSpeed = GameConstants.baseRotationSpeed,
    super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Anchor at center for proper rotation
    anchor = Anchor.center;

    // Create 4 segments, each 90° (π/2) apart with shuffled colors
    final colors = AppColors.gameColors.toList()..shuffle();
    segments = [];

    for (int i = 0; i < 4; i++) {
      final segment = RingSegment(
        color: colors[i],
        startAngle: (pi / 2) * i, // 0, π/2, π, 3π/2
      );
      segments.add(segment);
      await add(segment);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply rotation
    _currentAngle += rotationSpeed * dt;
    angle = _currentAngle;
  }

  /// Reset the ring for object pooling
  ///
  /// Called when recycling the ring instead of creating a new one.
  void reset({Vector2? newPosition, double? newRotationSpeed}) {
    _currentAngle = 0.0;
    angle = 0.0;

    if (newPosition != null) {
      position = newPosition;
    }
  }

  /// Randomize the starting rotation
  void randomizeRotation() {
    final random = Random();
    _currentAngle = random.nextDouble() * 2 * pi;
    angle = _currentAngle;
  }

  /// Reverse the rotation direction
  void reverseRotation() {
    // This would require modifying rotationSpeed, but it's final
    // For now, this is a placeholder for future difficulty scaling
  }
}
