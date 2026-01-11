import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/text_styles.dart';
import 'package:chroma_switch/game/chroma_game.dart';
import 'package:chroma_switch/state/score_notifier.dart';
import 'package:chroma_switch/core/di/service_locator.dart';

/// Real-time score display in top-right corner
///
/// Shows current score during gameplay with neon glow effect.
class ScoreHud extends ConsumerWidget {
  /// Reference to the game instance
  final ChromaGame game;

  const ScoreHud({super.key, required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListenableBuilder(
      listenable: getIt<ScoreNotifier>(),
      builder: (context, _) {
        final score = getIt<ScoreNotifier>().score;

        return Positioned(
          top: 48,
          right: 24,
          child: Text(
            '$score',
            style: AppTextStyles.scoreLarge.copyWith(
              color: AppColors.textPrimary,
              shadows: [
                Shadow(
                  color: AppColors.cyan.withValues(alpha: 0.6),
                  blurRadius: 15,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
