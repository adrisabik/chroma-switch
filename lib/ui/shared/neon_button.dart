import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/core/theme/text_styles.dart';

/// Neon-styled button with glow effect and haptic feedback
///
/// Used throughout the game for interactive UI elements.
/// Matches the "Cyberpunk Zen" aesthetic.
class NeonButton extends StatefulWidget {
  /// Button text
  final String text;

  /// Callback when button is tapped
  final VoidCallback onTap;

  /// Button glow color (defaults to cyan)
  final Color color;

  /// Optional width constraint
  final double? width;

  const NeonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = AppColors.cyan,
    this.width,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: _isPressed
              ? widget.color.withValues(alpha: 0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.color, width: 2),
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: _isPressed ? 0.6 : 0.4),
              blurRadius: _isPressed ? 20 : 12,
              spreadRadius: _isPressed ? 2 : 0,
            ),
          ],
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: AppTextStyles.buttonPrimary.copyWith(
            color: widget.color,
            shadows: [
              Shadow(
                color: widget.color.withValues(alpha: 0.8),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
