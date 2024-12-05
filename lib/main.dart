import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/screens/home_screen.dart';
import 'src/l10n/app_localizations.dart';
import 'src/services/settings_service.dart';
import 'src/services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', '');
  bool _isDarkMode = false;
  final _settingsService = SettingsService();
  final _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadTheme();
  }

  Future<void> _loadLanguage() async {
    final languageCode = await _settingsService.getLanguage();
    setState(() {
      _locale = Locale(languageCode, '');
    });
  }

  Future<void> _loadTheme() async {
    final isDark = await _themeService.isDarkMode();
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _setLocale(Locale locale) async {
    await _settingsService.setLanguage(locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  void _setThemeMode(bool isDark) async {
    await _themeService.setThemeMode(isDark);
    setState(() {
      _isDarkMode = isDark;
    });
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
