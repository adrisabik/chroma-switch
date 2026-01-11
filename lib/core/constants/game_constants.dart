/// Game Constants for Chroma Switch
///
/// All physics values, dimensions, and gameplay parameters.
/// These values are tuned for balanced, responsive gameplay.
class GameConstants {
  GameConstants._();

  // ============================================
  // Physics
  // ============================================

  /// Gravity applied to the player ball (pixels/second²)
  static const double gravity = 800.0;

  /// Jump impulse velocity (negative = upward)
  static const double jumpImpulse = -350.0;

  /// Player ball radius in pixels
  static const double ballRadius = 20.0;

  // ============================================
  // Obstacles
  // ============================================

  /// Outer radius of obstacle rings
  static const double ringOuterRadius = 120.0;

  /// Inner radius of obstacle rings
  static const double ringInnerRadius = 80.0;

  /// Thickness of ring segments (outer - inner)
  static const double ringThickness = 40.0;

  /// Base rotation speed of rings (radians/second)
  static const double baseRotationSpeed = 1.0;

  /// Vertical distance between spawned obstacles
  static const double spawnDistance = 300.0;

  // ============================================
  // Camera
  // ============================================

  /// How quickly camera follows player
  static const double cameraFollowSpeed = 5.0;

  /// How far below camera bottom before death
  static const double deathZoneOffset = 200.0;

  // ============================================
  // Difficulty Scaling
  // ============================================

  /// Score threshold for easy difficulty (0 to this value)
  static const int easyThreshold = 10;

  /// Score threshold for medium difficulty (easy to this value)
  static const int mediumThreshold = 20;

  // ============================================
  // Visual Effects
  // ============================================

  /// Number of particles spawned on death
  static const int deathParticleCount = 25;

  /// Screen shake intensity in pixels
  static const double shakeIntensity = 8.0;

  /// Screen shake duration in seconds
  static const double shakeDuration = 0.2;

  /// Screen flash duration in seconds (50ms)
  static const double flashDuration = 0.05;

  // ============================================
  // Color Switcher
  // ============================================

  /// Radius of color switcher orb
  static const double colorSwitcherRadius = 15.0;
}
