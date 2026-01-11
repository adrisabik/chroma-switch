import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/components/color_switcher.dart';

void main() {
  group('ColorSwitcher', () {
    test('uses default radius from GameConstants', () {
      final switcher = ColorSwitcher();
      expect(switcher.radius, equals(GameConstants.colorSwitcherRadius));
    });

    test('accepts custom radius', () {
      final switcher = ColorSwitcher(radius: 25.0);
      expect(switcher.radius, equals(25.0));
    });

    test('accepts position parameter', () {
      final switcher = ColorSwitcher(position: Vector2(100, 200));
      expect(switcher.position.x, equals(100));
      expect(switcher.position.y, equals(200));
    });

    test('accepts nextValidColors parameter', () {
      final validColors = [AppColors.cyan, AppColors.magenta];
      final switcher = ColorSwitcher(nextValidColors: validColors);
      expect(switcher.nextValidColors, equals(validColors));
    });

    test('nextValidColors is null by default', () {
      final switcher = ColorSwitcher();
      expect(switcher.nextValidColors, isNull);
    });

    test('can create switcher for all game color combinations', () {
      for (final color in AppColors.gameColors) {
        final switcher = ColorSwitcher(nextValidColors: [color]);
        expect(switcher.nextValidColors, contains(color));
      }
    });

    test('radius matches colorSwitcherRadius constant', () {
      expect(GameConstants.colorSwitcherRadius, isPositive);
      expect(GameConstants.colorSwitcherRadius, greaterThan(10.0));
    });
  });
}
