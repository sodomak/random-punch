import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import 'settings_screen.dart';
import 'training_screen.dart';
import 'about_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            ElevatedButton(
              onPressed: () async {
                final settings = await SettingsService().loadSettings('Default');
                if (settings != null && mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TrainingScreen(settings: settings),
                    ),
                  );
                }
              },
              child: Text(l10n.startTraining),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                      onLocaleChanged: widget.onLocaleChanged,
                    ),
                  ),
                );
              },
              child: Text(l10n.settings),
            ),
          ],
        ),
      ),
    );
  }
}