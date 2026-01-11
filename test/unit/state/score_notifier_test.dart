import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_switch/state/score_notifier.dart';

void main() {
  late ScoreNotifier notifier;

  setUp(() {
    notifier = ScoreNotifier();
  });

  group('ScoreNotifier', () {
    test('starts at zero', () {
      expect(notifier.score, equals(0));
      expect(notifier.highScore, equals(0));
    });

    test('increments score by 1', () {
      notifier.increment();

      expect(notifier.score, equals(1));
    });

    test('increments score multiple times', () {
      notifier.increment();
      notifier.increment();
      notifier.increment();

      expect(notifier.score, equals(3));
    });

    test('incrementBy adds specific amount', () {
      notifier.incrementBy(5);

      expect(notifier.score, equals(5));
    });

    test('resets score to zero', () {
      notifier.increment();
      notifier.increment();
      notifier.reset();

      expect(notifier.score, equals(0));
    });

    test('reset does not affect high score', () {
      notifier.incrementBy(10);
      notifier.updateHighScoreIfNeeded();
      notifier.reset();

      expect(notifier.score, equals(0));
      expect(notifier.highScore, equals(10));
    });

    test('setHighScore updates high score', () {
      notifier.setHighScore(100);

      expect(notifier.highScore, equals(100));
    });

    test('updateHighScoreIfNeeded updates when score is higher', () {
      notifier.setHighScore(10);
      notifier.incrementBy(15);

      final updated = notifier.updateHighScoreIfNeeded();

      expect(updated, isTrue);
      expect(notifier.highScore, equals(15));
    });

    test('updateHighScoreIfNeeded does not update when score is lower', () {
      notifier.setHighScore(20);
      notifier.incrementBy(10);

      final updated = notifier.updateHighScoreIfNeeded();

      expect(updated, isFalse);
      expect(notifier.highScore, equals(20));
    });

    test('isNewHighScore is true when score exceeds high score', () {
      notifier.setHighScore(5);
      notifier.incrementBy(10);

      expect(notifier.isNewHighScore, isTrue);
    });

    test('isNewHighScore is false when score is zero', () {
      expect(notifier.isNewHighScore, isFalse);
    });

    test('isNewHighScore is false when score equals high score', () {
      notifier.setHighScore(10);
      notifier.incrementBy(10);

      expect(notifier.isNewHighScore, isFalse);
    });

    test('notifies listeners on increment', () {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.increment();

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on incrementBy', () {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.incrementBy(5);

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on reset', () {
      int notifyCount = 0;
      notifier.increment();

      notifier.addListener(() => notifyCount++);
      notifier.reset();

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on setHighScore', () {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.setHighScore(100);

      expect(notifyCount, equals(1));
    });
  });
}
