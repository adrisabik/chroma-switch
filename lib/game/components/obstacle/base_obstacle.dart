import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

/// Base class for all obstacles in the game
abstract class BaseObstacle extends PositionComponent {
  BaseObstacle({super.position});

  /// Reset the obstacle for recycling in the object pool
  ///
  /// [position] - New position for the obstacle
  /// [difficultyMultiplier] - value from 0.0 to 1.0+ indicating current difficulty
  void reset({Vector2? position, double difficultyMultiplier = 1.0});

  /// Returns the list of colors that are safe to pass through this obstacle
  ///
  /// Used by ObstacleManager to ensure ColorSwitcher gives a safe color
  List<Color> get validColors;
}
