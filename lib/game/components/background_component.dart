import 'dart:ui';
import 'package:flutter/painting.dart';

import 'package:flame/components.dart';

import 'package:chroma_switch/game/chroma_game.dart';

class BackgroundComponent extends PositionComponent
    with HasGameReference<ChromaGame> {
  // Use HSL to shift hue easily
  double _hue = 0.0;

  @override
  int get priority => -100; // Render behind everything element

  @override
  Future<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();
    // Assuming AppColors.background is the base dark color
  }

  @override
  void update(double dt) {
    if (game.camera.viewfinder.position.y.isNaN) return;

    // Ensure size matches game size (if resizable)
    // For fixed resolution logic, this might be okay, but let's sync
    // Sync position with camera to always cover screen?
    // Or just be a HUD-like component that ignores camera?
    // Flame 1.20+ CameraComponent world vs viewport.
    // If added to World, it moves with camera. We want it static relative to VIEWPORT.
    // But if we add it to game directly (not world), it might work as overlay if it's a HUD.
    // However, simplest is to just fill the rect that the camera sees.

    // Slow hue shift
    _hue += dt * 5.0; // 5 degrees per second
    if (_hue >= 360.0) _hue -= 360.0;
  }

  @override
  void render(Canvas canvas) {
    // We want to fill the entire visible area
    // Since this component is in the World (presumably), we need to cover the camera view.

    final visibleRect = game.camera.visibleWorldRect;

    // Base dark background with slight tint
    // AppColors.background is likely very dark.
    // Let's generate a color from HSL but keep it very dark/low saturation.

    final color = HSLColor.fromAHSL(1.0, _hue, 0.2, 0.1).toColor();
    // 0.2 Saturation, 0.1 Lightness = Dark subtle color

    canvas.drawRect(visibleRect, Paint()..color = color);
  }
}
