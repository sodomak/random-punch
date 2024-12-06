import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = false;
  String? _currentLanguage;
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

  Future<void> initialize([String? languageCode]) async {
    if (_isInitialized && languageCode == _currentLanguage) return;
    
    try {
      // Clear any existing resources
      await AudioPlayer.clearAssetCache();
      
      if (kIsWeb) {
        // Pre-initialize audio context and test with the current language
        final testPlayer = AudioPlayer();
        final testPath = languageCode != null ? 
          'assets/sounds/$languageCode/1.mp3' : 
          'assets/sounds/countdown.mp3';
          
        await testPlayer.setAsset(testPath);
        await testPlayer.seek(Duration.zero);
        await testPlayer.setVolume(0);
        await testPlayer.play();
        await testPlayer.stop();
        await testPlayer.dispose();
        
        debugPrint('Web audio context initialized successfully for language: $languageCode');
      }
      _currentLanguage = languageCode;
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
      await player.dispose();
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
      await player.dispose();
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
      await player.dispose();
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
      await player.dispose();
    } catch (e) {
      developer.log('Error playing finish sound: $e', error: e);
    }
  }

  Future<AudioPlayer?> playNumber(int number, String languageCode) async {
    if (_isMuted || !_isInitialized) {
      debugPrint('Sound skipped: muted=$_isMuted, initialized=$_isInitialized');
      return null;
    }
    
    try {
      String assetPath = 'assets/sounds/$languageCode/$number.mp3';
      debugPrint('Attempting to play sound: $assetPath');
      
      final player = await _createPlayer(assetPath);
      await player.seek(Duration.zero);
      await player.play();
      
      // Wait for completion
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      await player.dispose();
      debugPrint('Successfully played and disposed: $assetPath');
      return null;
      
    } catch (e) {
      debugPrint('Primary language sound failed ($languageCode): $e');
      if (languageCode != 'en') {
        try {
          String fallbackPath = 'assets/sounds/en/$number.mp3';
          debugPrint('Attempting fallback sound: $fallbackPath');
          
          final player = await _createPlayer(fallbackPath);
          await player.seek(Duration.zero);
          await player.play();
          
          // Wait for completion
          await player.playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.completed
          );
          await player.dispose();
          debugPrint('Successfully played and disposed fallback: $fallbackPath');
          return null;
        } catch (e) {
          debugPrint('Fallback sound failed: $e');
          return null;
        }
      }
      debugPrint('Error playing any sound: $e');
      return null;
    }
  }

  void dispose() {
    _isInitialized = false;
    developer.log('Disposing SoundService');
  }
} 