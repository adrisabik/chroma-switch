import 'dart:math';
import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_switch/core/constants/game_constants.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/components/obstacle/ring_segment.dart';
import 'package:chroma_switch/game/components/obstacle/obstacle_ring.dart';

void main() {
  group('RingSegment', () {
    test('initializes with correct color', () {
      final segment = RingSegment(color: AppColors.cyan, startAngle: 0);
      expect(segment.color, equals(AppColors.cyan));
    });

    test('initializes with correct start angle', () {
      final segment = RingSegment(color: AppColors.magenta, startAngle: pi / 2);
      expect(segment.startAngle, equals(pi / 2));
    });

    test('has default sweep angle of pi/2 (90 degrees)', () {
      final segment = RingSegment(color: AppColors.yellow, startAngle: 0);
      expect(segment.sweepAngle, equals(pi / 2));
    });

    test('uses default radii from GameConstants', () {
      final segment = RingSegment(color: AppColors.purple, startAngle: 0);
      expect(segment.outerRadius, equals(GameConstants.ringOuterRadius));
      expect(segment.innerRadius, equals(GameConstants.ringInnerRadius));
    });

    test('accepts custom radii', () {
      final segment = RingSegment(
        color: AppColors.cyan,
        startAngle: 0,
        outerRadius: 150.0,
        innerRadius: 100.0,
      );
      expect(segment.outerRadius, equals(150.0));
      expect(segment.innerRadius, equals(100.0));
    });

    test('can create segments for all game colors', () {
      for (final color in AppColors.gameColors) {
        final segment = RingSegment(color: color, startAngle: 0);
        expect(segment.color, equals(color));
      }
    });
  });

  group('ObstacleRing', () {
    test('uses default rotation speed from GameConstants', () {
      final ring = ObstacleRing();
      expect(ring.rotationSpeed, equals(GameConstants.baseRotationSpeed));
    });

    test('accepts custom rotation speed', () {
      final ring = ObstacleRing(rotationSpeed: 2.5);
      expect(ring.rotationSpeed, equals(2.5));
    });

    test('accepts position parameter', () {
      final ring = ObstacleRing(position: Vector2(100, 200));
      expect(ring.position.x, equals(100));
      expect(ring.position.y, equals(200));
    });

    test('reset restores angle to zero', () {
      final ring = ObstacleRing();
      ring.angle = 1.5;
      ring.reset();
      expect(ring.angle, equals(0.0));
    });

    test('reset can update position', () {
      final ring = ObstacleRing(position: Vector2(0, 0));
      ring.reset(newPosition: Vector2(50, 100));
      expect(ring.position.x, equals(50));
      expect(ring.position.y, equals(100));
    });
  });
}
