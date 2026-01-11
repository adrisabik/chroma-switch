import 'package:flame/components.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/game/components/player_ball.dart';

/// Camera that follows the player upward only
///
/// The camera smoothly follows the player's upward movement but
/// never moves downward. This creates the "endless climbing" feel.
///
/// Key behaviors:
/// - Only moves up, never down
/// - Smooth interpolation with GameConstants.cameraFollowSpeed
/// - Detects fall death when player is below camera viewport
class GameCamera extends Component with HasGameReference<ChromaGame> {
  /// Reference to the player ball
  PlayerBall? _player;

  /// Highest Y position the camera has reached (most negative)
  double _highestY = 0;

  /// Callback for when player falls below camera (death)
  void Function()? onPlayerFall;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Get player reference
    _player = game.playerBall;

    // Initialize camera position
    _highestY = game.size.y / 2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_player == null) return;

    final playerY = _player!.position.y;

    // Only follow upward (lower Y values)
    if (playerY < _highestY) {
      // Smooth interpolation toward player
      final targetY = playerY;
      final currentY = game.camera.viewfinder.position.y;

      final newY =
          currentY +
          (targetY - currentY) * GameConstants.cameraFollowSpeed * dt;

      game.camera.viewfinder.position = Vector2(game.size.x / 2, newY);

      _highestY = playerY;
    }

    // Check for fall death
    final cameraBottom =
        game.camera.viewfinder.position.y +
        game.size.y / 2 +
        GameConstants.deathZoneOffset;
    if (playerY > cameraBottom) {
      onPlayerFall?.call();
    }
  }

  /// Reset camera for new game
  void reset() {
    _highestY = game.size.y / 2;
    game.camera.viewfinder.position = Vector2(game.size.x / 2, game.size.y / 2);
  }
}
