import 'dart:math';
import 'package:flutter/material.dart';

/// Chroma Switch Color Palette
///
/// "Cyberpunk Zen" - Dark, atmospheric, clean.
/// Think *Tron* meets *Geometry Wars*.
class AppColors {
  AppColors._();

  // ============================================
  // Game Colors (Neon)
  // ============================================

  /// Cyan - Primary game color
  static const Color cyan = Color(0xFF00E5FF);

  /// Magenta - Primary game color
  static const Color magenta = Color(0xFFFF4081);

  /// Yellow - Primary game color
  static const Color yellow = Color(0xFFFFE045);

  /// Purple - Primary game color
  static const Color purple = Color(0xFF7C4DFF);

  // ============================================
  // Background & Surface Colors
  // ============================================

  /// Main game background
  static const Color background = Color(0xFF212121);

  /// Overlay/modal backgrounds
  static const Color darkSurface = Color(0xFF121212);

  // ============================================
  // Text Colors
  // ============================================

  /// Primary text (white)
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary/subtitle text
  static const Color textSecondary = Color(0xFFB0B0B0);

  // ============================================
  // Utility Methods
  // ============================================

  /// List of all game colors used for obstacles and player
  static List<Color> get gameColors => [cyan, magenta, yellow, purple];

  /// Random generator instance for color selection
  static final Random _random = Random();

  /// Get a random game color
  static Color getRandomColor() {
    return gameColors[_random.nextInt(gameColors.length)];
  }

  /// Get a random color excluding the specified color
  static Color getRandomColorExcluding(Color exclude) {
    final available = gameColors.where((c) => c != exclude).toList();
    return available[_random.nextInt(available.length)];
  }
}
