import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = true;
  static const String _muteKey = 'isMuted';

  SoundService() {
    _loadMuteState();
  }

  Future<void> _loadMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool(_muteKey) ?? false;
  }

  Future<void> _saveMuteState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_muteKey, _isMuted);
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      if (kIsWeb) {
        // Web-specific initialization
        await AudioPlayer.clearAssetCache();
      }
      _isInitialized = true;
      debugPrint('SoundService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SoundService: $e');
      _isInitialized = false;
    }
  }

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    _saveMuteState();
    developer.log('SoundService mute toggled: $_isMuted');
  }

  Future<AudioPlayer> _createPlayer(String assetPath) async {
    final player = AudioPlayer();
    await player.setLoopMode(LoopMode.off);
    await player.setAsset(assetPath);
    return player;
  }

  Future<void> playCountdown() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/countdown.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing countdown sound: $e', error: e);
    }
  }

  Future<void> playStart() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/start.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing start sound: $e', error: e);
    }
  }

  Future<void> playEnd() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/end.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing end sound: $e', error: e);
    }
  }

  Future<void> playFinish() async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = await _createPlayer('assets/sounds/finish.mp3');
      await player.seek(Duration.zero);
      await player.play();
      player.dispose();
    } catch (e) {
      developer.log('Error playing finish sound: $e', error: e);
    }
  }

  Future<AudioPlayer?> playNumber(int number, String languageCode) async {
    if (_isMuted || !_isInitialized) {
      debugPrint('Sound skipped: muted=$_isMuted, initialized=$_isInitialized');
      return null;
    }
    
    final player = AudioPlayer();
    try {
      String assetPath = 'assets/sounds/$languageCode/$number.mp3';
      debugPrint('Web platform: ${kIsWeb}');
      debugPrint('Attempting to play sound: $assetPath');
      
      try {
        await player.setAsset(assetPath);
        debugPrint('Asset loaded successfully: $assetPath');
        await player.play();
        debugPrint('Successfully started playing: $assetPath');
        return player;
      } catch (e) {
        debugPrint('Primary language sound failed ($languageCode): $e');
        if (languageCode != 'en') {
          String fallbackPath = 'assets/sounds/en/$number.mp3';
          debugPrint('Attempting fallback sound: $fallbackPath');
          await player.setAsset(fallbackPath);
          await player.play();
          debugPrint('Successfully playing fallback: $fallbackPath');
          return player;
        }
        throw e;
      }
    } catch (e) {
      debugPrint('Error playing any sound: $e');
      await player.dispose();
      return null;
    }
  }

  void dispose() {
    _isInitialized = false;
    developer.log('Disposing SoundService');
  }

} 