import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

/// Audio service for playing sound effects and background music
///
/// Uses FlameAudio for efficient game audio playback.
/// Preloads all audio assets to prevent first-play delay.
class AudioService {
  /// Whether audio is enabled
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  /// Currently playing BGM track
  String? _currentBgm;

  /// Initialize the audio service and preload assets
  Future<void> init() async {
    try {
      // Preload sound effects
      await FlameAudio.audioCache.loadAll([
        'sfx/jump.wav',
        'sfx/collect.wav',
        'sfx/crash.wav',
      ]);

      // Preload background music
      await FlameAudio.audioCache.load('music/bgm.mp3');

      debugPrint('AudioService initialized');
    } catch (e) {
      debugPrint('AudioService init error: $e');
    }
  }

  /// Play a sound effect
  ///
  /// [name] - Asset name without path (e.g., 'jump.wav')
  void playSfx(String name) {
    if (!_soundEnabled) return;

    try {
      FlameAudio.play('sfx/$name');
    } catch (e) {
      debugPrint('Error playing SFX: $e');
    }
  }

  /// Play jump sound (high-pitch blip)
  void playJump() => playSfx('jump.wav');

  /// Play collect sound (C Major chime)
  void playCollect() => playSfx('collect.wav');

  /// Play crash sound (digital crunch)
  void playCrash() => playSfx('crash.wav');

  /// Start playing background music
  ///
  /// [name] - Asset name without path (e.g., 'bgm.mp3')
  void playBgm(String name) {
    if (!_musicEnabled) return;
    if (_currentBgm == name) return; // Already playing

    try {
      stopBgm(); // Stop any current track
      FlameAudio.bgm.play('music/$name');
      _currentBgm = name;
    } catch (e) {
      debugPrint('Error playing BGM: $e');
    }
  }

  /// Stop background music
  void stopBgm() {
    try {
      FlameAudio.bgm.stop();
      _currentBgm = null;
    } catch (e) {
      debugPrint('Error stopping BGM: $e');
    }
  }

  /// Pause background music
  void pauseBgm() {
    try {
      FlameAudio.bgm.pause();
    } catch (e) {
      debugPrint('Error pausing BGM: $e');
    }
  }

  /// Resume background music
  void resumeBgm() {
    if (!_musicEnabled) return;

    try {
      FlameAudio.bgm.resume();
    } catch (e) {
      debugPrint('Error resuming BGM: $e');
    }
  }

  /// Toggle sound effects on/off
  void toggleSound() {
    _soundEnabled = !_soundEnabled;
  }

  /// Toggle music on/off
  void toggleMusic() {
    _musicEnabled = !_musicEnabled;
    if (!_musicEnabled) {
      stopBgm();
    }
  }

  /// Whether sound effects are enabled
  bool get soundEnabled => _soundEnabled;

  /// Whether music is enabled
  bool get musicEnabled => _musicEnabled;

  /// Dispose of audio resources
  void dispose() {
    stopBgm();
    FlameAudio.audioCache.clearAll();
  }
}
