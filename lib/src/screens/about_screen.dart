import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/settings_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _shareLogs(BuildContext context) async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final settingsService = SettingsService();
      final isDebugMode = await settingsService.isDebugMode();
      
      if (!isDebugMode && !kDebugMode) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.enableDebugMode)),
          );
        }
        return;
      }
      
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/error_log.txt');
      if (await file.exists()) {
        await Share.shareFiles([file.path], text: 'App Debug Logs');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.noLogsAvailable)),
          );
        }
      }
    } catch (e) {
      debugPrint('Error sharing logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.about),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Random Punch',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text('${l10n.version}: $appVersion'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _launchUrl('https://x.com/sodomak'),
              child: Text(
                '${l10n.author}: Sodomak',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _launchUrl('https://github.com/sodomak/random-punch'),
              child: Text(
                'GitHub',
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: Text(l10n.shareLogs),
              onTap: () => _shareLogs(context),
            ),
          ],
        ),
      ),
    );
  }
} 