import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import '../services/sound_service.dart';
import 'settings_screen.dart';
import 'training_screen.dart';
import 'about_screen.dart';
import 'stats_screen.dart';
import 'help_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;
  final void Function(bool) onThemeChanged;
  final bool isDarkMode;
  final SoundService soundService;

  const HomeScreen({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.isDarkMode,
    required this.soundService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return GestureDetector(
      onTapDown: (_) => widget.soundService.handleUserInteraction(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  widget.soundService.toggleMute();
                });
              },
              icon: Icon(
                widget.soundService.isMuted ? Icons.volume_off : Icons.volume_up,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'help':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                    break;
                  case 'about':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'help',
                  child: Text(l10n.help),
                ),
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
                        builder: (context) => TrainingScreen(
                          settings: settings,
                          soundService: widget.soundService,
                        ),
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
                          onLocaleChanged: widget.onLocaleChanged,
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: widget.isDarkMode,
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
              const SizedBox(height: 32),
              // Stats Button
              SizedBox(
                width: 180,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StatsScreen()),
                    );
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: Text(l10n.statistics),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}