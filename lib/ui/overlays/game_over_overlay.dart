import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/text_styles.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/state/score_notifier.dart';
import 'package:chroma_switch/ui/shared/neon_button.dart';

/// Game over overlay with final score, high score, and retry button
///
/// Displayed when player dies. Shows if a new high score was achieved.
class GameOverOverlay extends ConsumerWidget {
  /// Reference to the game instance
  final ChromaGame game;

  const GameOverOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreNotifier = getIt<ScoreNotifier>();
    final score = scoreNotifier.score;
    final highScore = scoreNotifier.highScore;
    final isNewHighScore = score >= highScore && score > 0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background.withValues(alpha: 0.9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game Over Title
          Text(
            'GAME OVER',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.magenta,
              shadows: [
                Shadow(
                  color: AppColors.magenta.withValues(alpha: 0.8),
                  blurRadius: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 48),

          // Score
          Text(
            'SCORE',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: AppTextStyles.scoreLarge.copyWith(
              color: isNewHighScore ? AppColors.yellow : AppColors.textPrimary,
              shadows: [
                Shadow(
                  color: (isNewHighScore ? AppColors.yellow : AppColors.cyan)
                      .withValues(alpha: 0.8),
                  blurRadius: 15,
                ),
              ],
            ),
          ),

          if (isNewHighScore) ...[
            const SizedBox(height: 16),
            Text(
              '★ NEW HIGH SCORE ★',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],

          const SizedBox(height: 24),

          // High Score
          Text(
            'BEST: $highScore',
            style: AppTextStyles.scoreMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 48),

          // Retry Button
          NeonButton(
            text: 'TRY AGAIN',
            onTap: () {
              game.overlays.remove('gameOver');
              game.overlays.add('hud');
              game.restart();
            },
            color: AppColors.cyan,
          ),
        ],
      ),
    );
  }
}
