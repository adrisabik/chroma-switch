import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/text_styles.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/state/score_notifier.dart';
import 'package:chroma_switch/ui/shared/neon_button.dart';

/// Start screen overlay with title, high score, and "Tap to Play"
///
/// Displayed when game is in initial state before first tap.
class StartOverlay extends ConsumerWidget {
  /// Reference to the game instance
  final ChromaGame game;

  const StartOverlay({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highScore = getIt<ScoreNotifier>().highScore;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background.withValues(alpha: 0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Game Title
          Text(
            'CHROMA',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.cyan,
              shadows: [
                Shadow(
                  color: AppColors.cyan.withValues(alpha: 0.8),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          Text(
            'SWITCH',
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

          // High Score
          if (highScore > 0) ...[
            Text(
              'HIGH SCORE',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$highScore',
              style: AppTextStyles.scoreLarge.copyWith(
                color: AppColors.yellow,
                shadows: [
                  Shadow(
                    color: AppColors.yellow.withValues(alpha: 0.8),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],

          // Play Button
          NeonButton(
            text: 'TAP TO PLAY',
            onTap: () {
              game.startPlaying();
            },
            color: AppColors.cyan,
          ),
        ],
      ),
    );
  }
}
