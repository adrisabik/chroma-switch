import 'package:flutter/material.dart';

/// App Text Styles for Chroma Switch
///
/// "Cyberpunk Zen" typography following the design system.
/// Uses custom fonts: Orbitron (titles), Exo 2 (buttons), RobotoMono (scores).
///
/// Note: Custom fonts must be added to pubspec.yaml and assets/fonts/
/// For now, we use system fonts with similar characteristics.
class AppTextStyles {
  AppTextStyles._();

  // ============================================
  // Title Styles (Orbitron or similar)
  // ============================================

  /// Large title for game logo / main menu
  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 4.0,
  );

  /// Medium title for section headers
  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.5,
  );

  /// Small title for labels
  static const TextStyle titleSmall = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  // ============================================
  // Score Styles (RobotoMono or similar)
  // ============================================

  /// Large score display (main HUD)
  static const TextStyle scoreLarge = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 64.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Medium score display
  static const TextStyle scoreMedium = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  /// Small score / stats display
  static const TextStyle scoreSmall = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  // ============================================
  // Button Styles (Exo 2 or similar)
  // ============================================

  /// Primary button text
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Exo2',
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );

  /// Secondary button text
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: 'Exo2',
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.white70,
    letterSpacing: 0.5,
  );

  // ============================================
  // Body / Label Styles
  // ============================================

  /// Body text
  static const TextStyle body = TextStyle(
    fontFamily: 'Exo2',
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  /// Label text (smaller, secondary)
  static const TextStyle label = TextStyle(
    fontFamily: 'Exo2',
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  /// Caption text (smallest)
  static const TextStyle caption = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: Colors.white54,
  );
}
