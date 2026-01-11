import 'dart:math';

import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/game/chroma_game.dart';

/// Camera shake effect triggered on death
///
/// Shakes the camera for a configurable duration with
/// intensity that decreases over time.
class ScreenShake extends Component with HasGameReference<ChromaGame> {
  /// Remaining shake time in seconds
  double _remaining = 0;

  /// Current shake intensity
  double _intensity = 0;

  /// Original camera position to restore after shake
  Vector2 _originalPosition = Vector2.zero();

  /// Whether shake is currently active
  bool get isActive => _remaining > 0;

  /// Trigger a screen shake effect
  ///
  /// [intensity] - Maximum pixel offset (default from GameConstants)
  /// [duration] - Shake duration in seconds (default from GameConstants)
  void trigger({double? intensity, double? duration}) {
    _intensity = intensity ?? GameConstants.shakeIntensity;
    _remaining = duration ?? GameConstants.shakeDuration;
    _originalPosition = game.camera.viewfinder.position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_remaining > 0) {
      _remaining -= dt;

      // Calculate intensity falloff
      final progress = (_remaining / GameConstants.shakeDuration).clamp(
        0.0,
        1.0,
      );
      final currentIntensity = _intensity * progress;

      // Apply random offset
      final random = Random();
      final offsetX = (random.nextDouble() - 0.5) * 2 * currentIntensity;
      final offsetY = (random.nextDouble() - 0.5) * 2 * currentIntensity;

      game.camera.viewfinder.position =
          _originalPosition + Vector2(offsetX, offsetY);

      // Restore original position when done
      if (_remaining <= 0) {
        game.camera.viewfinder.position = _originalPosition;
      }
    }
  }

  /// Reset the shake effect
  void reset() {
    if (_remaining > 0) {
      game.camera.viewfinder.position = _originalPosition;
    }
    _remaining = 0;
  }
}
