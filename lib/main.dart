import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/screens/home_screen.dart';
import 'src/l10n/app_localizations.dart';
import 'src/services/settings_service.dart';
import 'src/services/theme_service.dart';
import 'src/services/sound_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    FlutterError.onError = (FlutterErrorDetails details) async {
      // Log to file
      await _logError(details.exception, details.stack);
      // Print to console
      FlutterError.dumpErrorToConsole(details);
    };

    runApp(const MyApp());
  }, (error, stack) async {
    // Handle errors not caught by Flutter
    await _logError(error, stack);
    if (kDebugMode) {
      print('Error: $error\nStack trace: $stack');
    }
  });
}

Future<void> _logError(dynamic error, StackTrace? stack) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/error_log.txt');
    final timestamp = DateTime.now().toIso8601String();
    
    await file.writeAsString(
      '$timestamp\nError: $error\nStack trace: $stack\n\n',
      mode: FileMode.append,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Failed to write error log: $e');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  bool _isDarkMode = false;
  final _soundService = SoundService();
  final _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await _soundService.initialize();
    await _loadThemeSettings();
    await _loadLanguageSettings();
  }

  Future<void> _loadThemeSettings() async {
    try {
      final isDark = await _themeService.isDarkMode();
      setState(() {
        _isDarkMode = isDark;
      });
    } catch (e) {
      debugPrint('Error loading theme settings: $e');
    }
  }

  Future<void> _loadLanguageSettings() async {
    try {
      final settingsService = SettingsService();
      final savedLanguage = await settingsService.getLanguage();
      debugPrint('Loading saved language: $savedLanguage');
      setState(() {
        _locale = Locale(savedLanguage, '');
      });
      debugPrint('Set locale to: ${_locale.languageCode}');
    } catch (e) {
      debugPrint('Error loading language settings: $e');
    }
  }

  void _setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    try {
      final settingsService = SettingsService();
      await settingsService.setLanguage(locale.languageCode);
      debugPrint('Saved language: ${locale.languageCode}');
    } catch (e) {
      debugPrint('Error saving language setting: $e');
    }
  }

  void _setThemeMode(bool isDarkMode) async {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    try {
      await _themeService.setThemeMode(isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme settings: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Punch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: _locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('cs', ''),
      ],
      localizationsDelegates: const [
        _AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(
        onLocaleChanged: _setLocale,
        onThemeChanged: _setThemeMode,
        isDarkMode: _isDarkMode,
        soundService: _soundService,
      ),
    );
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'cs'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'cs':
        return AppLocalizationsCs();
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
