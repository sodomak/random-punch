import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';
import 'training_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChanged;
  final void Function(bool) onThemeChanged;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'about',
                child: Text(l10n.about),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start Training Button
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  final settings = await SettingsService().loadSettings('Default');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingScreen(settings: settings),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(24),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, size: 64),
                    const SizedBox(height: 8),
                    Text(
                      l10n.startTraining,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Settings Button
            SizedBox(
              width: 180,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        onLocaleChanged: onLocaleChanged,
                        onThemeChanged: onThemeChanged,
                        isDarkMode: isDarkMode,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.settings, size: 28),
                label: Text(
                  l10n.settings,
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}