import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.help),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            title: l10n.quickStartGuide,
            items: [
              '${l10n.startTraining}: ${l10n.helpStartTraining}',
              '${l10n.getReady}: ${l10n.helpGetReady}',
              l10n.helpTraining,
              l10n.helpBreaks,
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: l10n.settings,
            subsections: {
              l10n.trainingSetup: [
                '${l10n.roundLength}: ${l10n.helpRoundLength}',
                '${l10n.breakLength}: ${l10n.helpBreakLength}',
                '${l10n.countdownLength}: ${l10n.helpCountdownLength}',
                '${l10n.numberOfRounds}: ${l10n.helpNumberOfRounds}',
              ],
              l10n.numbersConfiguration: [
                '${l10n.numbersToShow}: ${l10n.helpNumbersToShow}',
                '${l10n.fixedCount}: ${l10n.helpFixedCount}',
                '${l10n.randomRange}: ${l10n.helpRandomRange}',
                '${l10n.intervalBetweenNumbers}: ${l10n.helpIntervalBetweenNumbers}',
              ],
            },
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: l10n.statistics,
            items: [
              l10n.helpStatsProgress,
              l10n.helpStatsTime,
              l10n.helpStatsCombos,
              l10n.helpStatsFilter,
            ],
          ),
          const SizedBox(height: 24),
          _buildSection(
            title: l10n.sound,
            items: [
              l10n.helpVoiceAnnouncements,
              l10n.helpSoundEffects,
              l10n.helpMutableAudio,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    List<String>? items,
    Map<String, List<String>>? subsections,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (items != null)
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  '• $item',
                  style: const TextStyle(fontSize: 16),
                ),
              )),
        if (subsections != null)
          ...subsections.entries.map((entry) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ...entry.value.map((item) => Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 8),
                        child: Text(
                          '• $item',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                ],
              )),
      ],
    );
  }
} 