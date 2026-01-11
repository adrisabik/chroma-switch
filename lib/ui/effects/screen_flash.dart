import 'package:flutter/material.dart';

/// White flash overlay shown briefly on color collection
///
/// Provides visual feedback when player collects a ColorSwitcher.
/// Flash duration is 50ms with quick fade-out.
class ScreenFlash extends StatefulWidget {
  /// Whether the flash is currently active
  final bool isActive;

  /// Callback when flash animation completes
  final VoidCallback? onComplete;

  const ScreenFlash({super.key, this.isActive = false, this.onComplete});

  @override
  State<ScreenFlash> createState() => _ScreenFlashState();
}

class _ScreenFlashState extends State<ScreenFlash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.7,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(ScreenFlash oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive && !oldWidget.isActive) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        if (_opacityAnimation.value == 0) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.white.withValues(alpha: _opacityAnimation.value),
            ),
          ),
        );
      },
    );
  }
}
