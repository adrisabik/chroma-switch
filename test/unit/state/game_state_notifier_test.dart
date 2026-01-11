import 'package:flutter_test/flutter_test.dart';
import 'package:chroma_switch/state/game_state_notifier.dart';

void main() {
  late GameStateNotifier notifier;

  setUp(() {
    notifier = GameStateNotifier();
  });

  group('GameStateNotifier', () {
    test('starts in menu state', () {
      expect(notifier.status, equals(GameStatus.menu));
      expect(notifier.isMenu, isTrue);
      expect(notifier.isPlaying, isFalse);
      expect(notifier.isGameOver, isFalse);
    });

    test('transitions to playing on startGame', () {
      notifier.startGame();

      expect(notifier.status, equals(GameStatus.playing));
      expect(notifier.isPlaying, isTrue);
      expect(notifier.isMenu, isFalse);
    });

    test('transitions to gameOver on setGameOver from playing', () {
      notifier.startGame();
      notifier.setGameOver();

      expect(notifier.status, equals(GameStatus.gameOver));
      expect(notifier.isGameOver, isTrue);
      expect(notifier.isPlaying, isFalse);
    });

    test('does not transition to gameOver from menu', () {
      // Cannot go directly from menu to gameOver
      notifier.setGameOver();

      expect(notifier.status, equals(GameStatus.menu));
    });

    test('returns to menu on returnToMenu', () {
      notifier.startGame();
      notifier.setGameOver();
      notifier.returnToMenu();

      expect(notifier.status, equals(GameStatus.menu));
      expect(notifier.isMenu, isTrue);
    });

    test('notifies listeners on startGame', () {
      int notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.startGame();

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on setGameOver', () {
      int notifyCount = 0;
      notifier.startGame();

      notifier.addListener(() => notifyCount++);
      notifier.setGameOver();

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on returnToMenu', () {
      int notifyCount = 0;
      notifier.startGame();
      notifier.setGameOver();

      notifier.addListener(() => notifyCount++);
      notifier.returnToMenu();

      expect(notifyCount, equals(1));
    });

    test('does not notify if already in playing state', () {
      int notifyCount = 0;
      notifier.startGame();

      notifier.addListener(() => notifyCount++);
      notifier.startGame(); // Already playing

      expect(notifyCount, equals(0));
    });

    test('reset returns to menu state', () {
      notifier.startGame();
      notifier.setGameOver();
      notifier.reset();

      expect(notifier.status, equals(GameStatus.menu));
    });
  });
}
