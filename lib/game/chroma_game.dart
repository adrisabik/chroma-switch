import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/services/audio_service.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/components/background_component.dart';
import 'package:chroma_switch/game/components/game_camera.dart';
import 'package:chroma_switch/game/components/player_ball.dart';
import 'package:chroma_switch/game/effects/explosion_particle.dart';
import 'package:chroma_switch/game/effects/screen_shake.dart';
import 'package:chroma_switch/game/logic/obstacle_manager.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';
import 'package:chroma_switch/state/score_notifier.dart';

/// Main Flame game class for Chroma Switch
///
/// This is the core game loop that runs at 60 FPS.
///
/// Architecture Notes:
/// - Never use Riverpod watchers inside update() - causes frame drops
/// - Access GetIt services directly for state updates
/// - Use HasCollisionDetection mixin for collision callbacks
class ChromaGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  /// The player ball component
  late PlayerBall playerBall;

  /// Screen shake effect component
  late ScreenShake screenShake;

  /// Game camera that follows player upward
  late GameCamera gameCamera;

  /// Obstacle spawning and recycling manager
  late ObstacleManager obstacleManager;

  /// Whether a flash is currently active
  bool _flashActive = false;

  /// Getter for flash state (used by UI)
  bool get flashActive => _flashActive;

  ChromaGame();

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add dynamic background (behind everything)
    await add(BackgroundComponent());

    // Add screen shake component
    screenShake = ScreenShake();
    await add(screenShake);

    // Add player ball
    playerBall = PlayerBall();
    await add(playerBall);

    // Add game camera (follows player upward)
    gameCamera = GameCamera();
    gameCamera.onPlayerFall = triggerGameOver;
    await add(gameCamera);

    // Add obstacle manager
    obstacleManager = ObstacleManager();
    await add(obstacleManager);

    // Start background music (disabled - no BGM file yet)
    // getIt<AudioService>().playBgm('bgm.mp3');

    // Show start overlay initially
    overlays.add('start');

    debugPrint('ChromaGame loaded');
  }

  /// Handle tap anywhere on screen to make player jump
  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    // Only jump if game is actively playing
    if (getIt<GameStateNotifier>().isPlaying) {
      playerBall.jump();
      getIt<AudioService>().playJump();
    }
  }

  /// Trigger game over state
  /// Called when player collides with wrong color segment or falls
  void triggerGameOver() {
    // Prevent multiple triggers
    if (!getIt<GameStateNotifier>().isPlaying) return;

    // Update high score if needed
    getIt<ScoreNotifier>().updateHighScoreIfNeeded();

    // Set game state to game over
    getIt<GameStateNotifier>().setGameOver();

    // Play crash sound
    getIt<AudioService>().playCrash();

    // Spawn death particles (25 particles)
    _spawnDeathParticles();

    // Trigger screen shake
    screenShake.trigger();

    // Show game over overlay
    overlays.remove('hud');
    overlays.add('gameOver');

    debugPrint('Game Over triggered');
  }

  /// Spawn explosion particles at player position
  void _spawnDeathParticles() {
    final playerPosition = playerBall.position.clone();
    final playerColor = playerBall.currentColor;

    // Spawn 25 particles for dramatic effect
    for (int i = 0; i < 25; i++) {
      add(
        ExplosionParticle(position: playerPosition.clone(), color: playerColor),
      );
    }
  }

  /// Restart the game
  void restart() {
    // Reset score
    getIt<ScoreNotifier>().reset();

    // Start new game
    getIt<GameStateNotifier>().startGame();

    // Reset player ball
    playerBall.reset();

    // Reset camera
    gameCamera.reset();

    // Reset obstacle manager
    obstacleManager.reset();

    // Reset screen shake
    screenShake.reset();

    debugPrint('Game restarting');
  }

  /// Flash the screen white (on color collect)
  void flashScreen() {
    _flashActive = true;
    getIt<AudioService>().playCollect();

    // Reset flash after 50ms
    Future.delayed(const Duration(milliseconds: 50), () {
      _flashActive = false;
    });
  }

  // No changes to startPlaying needed unless Camera logic is there.

  void startPlaying() {
    getIt<GameStateNotifier>().startGame();
    overlays.remove('start');
    overlays.add('hud');
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Dynamic Camera Zoom
    // Zoom in slightly when jumping (velocity < 0)
    // Zoom out when falling (velocity > 0)
    const double baseZoom = 1.0;
    const double maxZoomIn = 1.1; // Jump apex / rise
    const double maxZoomOut = 0.9; // Fast fall

    if (playerBall.isMounted) {
      final vy = playerBall.velocity.y;

      // Target zoom based on vertical velocity
      double targetZoom = baseZoom;

      if (vy < -100) {
        // Rising fast
        targetZoom = maxZoomIn;
      } else if (vy > 200) {
        // Falling fast
        targetZoom = maxZoomOut;
      }

      // Smooth lerp
      final currentZoom = camera.viewfinder.zoom;
      camera.viewfinder.zoom =
          currentZoom + (targetZoom - currentZoom) * dt * 2.0;
    }
  }
}
