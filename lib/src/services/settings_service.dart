import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/training_settings.dart';

class SettingsService {
  static const String _settingsKey = 'training_settings';
  static const String _activeSettingKey = 'active_setting';
  static const String _languageKey = 'language_code';
  
  Future<void> saveSettings(TrainingSettings settings, String name) async {
    final prefs = await SharedPreferences.getInstance();
    final allSettings = await getSettingsList();
    
    // Convert settings to JSON
    final settingsJson = {
      'roundLength': settings.roundLength.inSeconds,
      'breakLength': settings.breakLength.inSeconds,
      'countdownLength': settings.countdownLength.inSeconds,
      'selectedNumbers': settings.selectedNumbers,
      'isFixedNumberCount': settings.isFixedNumberCount,
      'fixedNumberCount': settings.fixedNumberCount,
      'minNumberCount': settings.minNumberCount,
      'maxNumberCount': settings.maxNumberCount,
      'minInterval': settings.minInterval.inSeconds,
      'maxInterval': settings.maxInterval.inSeconds,
      'name': name,
    };
    
    // Update or add settings
    allSettings[name] = settingsJson;
    
    // Save all settings
    await prefs.setString(_settingsKey, jsonEncode(allSettings));
    // Set as active setting
    await prefs.setString(_activeSettingKey, name);
  }

  Future<TrainingSettings?> loadSettings(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final allSettings = await getSettingsList();
    
    final settingsJson = allSettings[name];
    if (settingsJson == null) return null;
    
    return TrainingSettings(
      roundLength: Duration(seconds: settingsJson['roundLength'] as int),
      breakLength: Duration(seconds: settingsJson['breakLength'] as int),
      countdownLength: Duration(seconds: settingsJson['countdownLength'] as int),
      selectedNumbers: List<int>.from(settingsJson['selectedNumbers'] as List),
      isFixedNumberCount: settingsJson['isFixedNumberCount'] as bool,
      fixedNumberCount: settingsJson['fixedNumberCount'] as int,
      minNumberCount: settingsJson['minNumberCount'] as int,
      maxNumberCount: settingsJson['maxNumberCount'] as int,
      minInterval: Duration(seconds: settingsJson['minInterval'] as int),
      maxInterval: Duration(seconds: settingsJson['maxInterval'] as int),
      name: settingsJson['name'] as String,
    );
  }

  Future<Map<String, dynamic>> getSettingsList() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey);
    if (settingsJson == null) return {};
    return Map<String, dynamic>.from(jsonDecode(settingsJson));
  }

  Future<String?> getActiveSettingName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeSettingKey);
  }

  Future<void> deleteSettings(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final allSettings = await getSettingsList();
    
    allSettings.remove(name);
    await prefs.setString(_settingsKey, jsonEncode(allSettings));
    
    // If this was the active setting, clear the active setting
    final activeSetting = await getActiveSettingName();
    if (activeSetting == name) {
      await prefs.remove(_activeSettingKey);
    }
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
