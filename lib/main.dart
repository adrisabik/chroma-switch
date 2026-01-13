import 'package:chroma_switch/ui/hud/score_hud.dart';
import 'package:chroma_switch/ui/overlays/game_over_overlay.dart';
import 'package:chroma_switch/ui/overlays/start_overlay.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chroma_switch/core/di/service_locator.dart';
import 'package:chroma_switch/core/theme/app_colors.dart';
import 'package:chroma_switch/game/chroma_game.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dependency injection
  setupDependencies();

  runApp(
    // Wrap with ProviderScope for Riverpod
    const ProviderScope(child: ChromaSwitchApp()),
  );
}

/// Root application widget
class ChromaSwitchApp extends StatelessWidget {
  const ChromaSwitchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chroma Switch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const GameScreen(),
    );
  }
}

/// Main game screen with Flame GameWidget
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ChromaGame _game;

  @override
  void initState() {
    super.initState();
    _game = ChromaGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          'start': (context, game) => StartOverlay(game: _game),
          'gameOver': (context, game) => GameOverOverlay(game: _game),
          'hud': (context, game) => ScoreHud(game: _game),
        },
      ),
    );
  }
}
