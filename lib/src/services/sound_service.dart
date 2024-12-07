import 'dart:developer' as developer;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  bool _isMuted = false;
  bool _isInitialized = false;
  String? _currentLanguage;
  static const String _muteKey = 'isMuted';
  final Map<String, AudioPlayer> _players = {};

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
      // Dispose of any existing players
      for (var player in _players.values) {
        await player.dispose();
      }
      _players.clear();
      
      _isInitialized = false;
      await AudioPlayer.clearAssetCache();
      
      // Initialize all required audio players
      await _initializePlayer('countdown', 'assets/sounds/countdown.mp3');
      await _initializePlayer('start', 'assets/sounds/start.mp3');
      await _initializePlayer('end', 'assets/sounds/end.mp3');
      await _initializePlayer('finish', 'assets/sounds/finish.mp3');
      
      _currentLanguage = languageCode;
      _isInitialized = true;
      debugPrint('SoundService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SoundService: $e');
      _isInitialized = false;
    }
  }

  Future<void> _initializePlayer(String key, String assetPath) async {
    final player = AudioPlayer();
    await player.setAsset(assetPath);
    _players[key] = player;
  }

  Future<void> _playSound(String key) async {
    if (_isMuted || !_isInitialized) return;
    try {
      final player = _players[key];
      if (player != null) {
        await player.seek(Duration.zero);
        await player.play();
      }
    } catch (e) {
      debugPrint('Error playing sound $key: $e');
    }
  }

  Future<void> playNumber(int number, String languageCode) async {
    if (_isMuted || !_isInitialized) return;
    
    try {
      final player = AudioPlayer();
      String assetPath = 'assets/sounds/$languageCode/$number.mp3';
      
      await player.setAsset(assetPath);
      await player.seek(Duration.zero);
      await player.play();
      
      await player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      
      await player.dispose();
    } catch (e) {
      debugPrint('Error playing number sound: $e');
      if (languageCode != 'en') {
        // Try fallback to English
        try {
          final player = AudioPlayer();
          await player.setAsset('assets/sounds/en/$number.mp3');
          await player.seek(Duration.zero);
          await player.play();
          await player.playerStateStream.firstWhere(
            (state) => state.processingState == ProcessingState.completed
          );
          await player.dispose();
        } catch (e) {
          debugPrint('Fallback sound failed: $e');
        }
      }
    }
  }

  Future<void> playCountdown() async => _playSound('countdown');
  Future<void> playStart() async => _playSound('start');
  Future<void> playEnd() async => _playSound('end');
  Future<void> playFinish() async => _playSound('finish');

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    _saveMuteState();
  }

  void dispose() {
    for (var player in _players.values) {
      player.dispose();
    }
    _players.clear();
    _isInitialized = false;
    _currentLanguage = null;
  }
} 