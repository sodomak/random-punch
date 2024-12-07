import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../services/settings_service.dart';
import '../models/training_settings.dart';
import '../widgets/time_settings_field.dart';
import '../widgets/number_settings_field.dart';

class SettingsScreen extends StatefulWidget {
  final void Function(Locale) onLocaleChanged;
  final void Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onLocaleChanged,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsService = SettingsService();

  final _roundMinutes = TextEditingController(text: '3');
  final _roundSeconds = TextEditingController(text: '0');
  final _breakMinutes = TextEditingController(text: '1');
  final _breakSeconds = TextEditingController(text: '0');
  final _countdownSeconds = TextEditingController(text: '10');
  final _fixedNumberCount = TextEditingController(text: '1');
  final _minNumberCount = TextEditingController(text: '1');
  final _maxNumberCount = TextEditingController(text: '4');
  final _minInterval = TextEditingController(text: '3');
  final _maxInterval = TextEditingController(text: '10');
  final _numberOfRounds = TextEditingController(text: '3');
  
  bool _isFixedNumberCount = true;
  final Set<int> _selectedNumbers = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  late bool _isDarkMode;
  bool _isDebugMode = false;

  @override
  void dispose() {
    _saveSettings();
    
    _roundMinutes.dispose();
    _roundSeconds.dispose();
    _breakMinutes.dispose();
    _breakSeconds.dispose();
    _countdownSeconds.dispose();
    _fixedNumberCount.dispose();
    _minNumberCount.dispose();
    _maxNumberCount.dispose();
    _minInterval.dispose();
    _maxInterval.dispose();
    _numberOfRounds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _isDarkMode = widget.isDarkMode;
    _loadDebugMode();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.loadSettings('Default');
    if (settings != null && mounted) {
      setState(() {
        _roundMinutes.text = (settings.roundLength.inMinutes).toString();
        _roundSeconds.text = (settings.roundLength.inSeconds % 60).toString();
        _breakMinutes.text = (settings.breakLength.inMinutes).toString();
        _breakSeconds.text = (settings.breakLength.inSeconds % 60).toString();
        _countdownSeconds.text = settings.countdownLength.inSeconds.toString();
        _selectedNumbers.clear();
        _selectedNumbers.addAll(settings.selectedNumbers);
        _isFixedNumberCount = settings.isFixedNumberCount;
        _fixedNumberCount.text = settings.fixedNumberCount.toString();
        _minNumberCount.text = settings.minNumberCount.toString();
        _maxNumberCount.text = settings.maxNumberCount.toString();
        _minInterval.text = settings.minInterval.inSeconds.toString();
        _maxInterval.text = settings.maxInterval.inSeconds.toString();
        _numberOfRounds.text = settings.numberOfRounds.toString();
      });
    }
  }

  Future<void> _saveSettings() async {
    final settings = TrainingSettings(
      roundLength: Duration(
        minutes: int.parse(_roundMinutes.text),
        seconds: int.parse(_roundSeconds.text),
      ),
      breakLength: Duration(
        minutes: int.parse(_breakMinutes.text),
        seconds: int.parse(_breakSeconds.text),
      ),
      countdownLength: Duration(seconds: int.parse(_countdownSeconds.text)),
      selectedNumbers: _selectedNumbers.toList()..sort(),
      isFixedNumberCount: _isFixedNumberCount,
      fixedNumberCount: int.parse(_fixedNumberCount.text),
      minNumberCount: int.parse(_minNumberCount.text),
      maxNumberCount: int.parse(_maxNumberCount.text),
      minInterval: Duration(seconds: int.parse(_minInterval.text)),
      maxInterval: Duration(seconds: int.parse(_maxInterval.text)),
      numberOfRounds: int.parse(_numberOfRounds.text),
    );

    try {
      await _settingsService.saveSettings('Default', settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save settings')),
        );
      }
    }
  }

  Duration get roundLength => Duration(
        minutes: int.parse(_roundMinutes.text),
        seconds: int.parse(_roundSeconds.text),
      );

  Duration get breakLength => Duration(
        minutes: int.parse(_breakMinutes.text),
        seconds: int.parse(_breakSeconds.text),
      );

  Widget _buildLanguageSelector(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          label: const Text('English'),
          selected: Localizations.localeOf(context).languageCode == 'en',
          onSelected: (selected) {
            if (selected) widget.onLocaleChanged(const Locale('en', ''));
          },
        ),
        ChoiceChip(
          label: const Text('Čeština'),
          selected: Localizations.localeOf(context).languageCode == 'cs',
          onSelected: (selected) {
            if (selected) widget.onLocaleChanged(const Locale('cs', ''));
          },
        ),
      ],
    );
  }

  Widget _buildThemeSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(_isDarkMode ? l10n.darkTheme : l10n.lightTheme),
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
              widget.onThemeChanged(value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildNumberSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(10, (index) {
        return FilterChip(
          label: Text('$index'),
          selected: _selectedNumbers.contains(index),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedNumbers.add(index);
              } else {
                _selectedNumbers.remove(index);
              }
            });
          },
        );
      }),
    );
  }

  Widget _buildNumberCountSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: Text(l10n.fixedCount),
                value: true,
                groupValue: _isFixedNumberCount,
                onChanged: (value) {
                  setState(() {
                    _isFixedNumberCount = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: Text(l10n.randomRange),
                value: false,
                groupValue: _isFixedNumberCount,
                onChanged: (value) {
                  setState(() {
                    _isFixedNumberCount = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isFixedNumberCount)
          NumberSettingsField(
            label: l10n.numberOfDigits,
            value: int.parse(_fixedNumberCount.text),
            onChanged: (value) => setState(() => _fixedNumberCount.text = value.toString()),
            minValue: 1,
            maxValue: _selectedNumbers.length,
          )
        else
          Row(
            children: [
              Expanded(
                child: NumberSettingsField(
                  label: l10n.minimumDigits,
                  value: int.parse(_minNumberCount.text),
                  onChanged: (value) => setState(() => _minNumberCount.text = value.toString()),
                  minValue: 1,
                  maxValue: _selectedNumbers.length,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: NumberSettingsField(
                  label: l10n.maximumDigits,
                  value: int.parse(_maxNumberCount.text),
                  onChanged: (value) => setState(() => _maxNumberCount.text = value.toString()),
                  minValue: int.parse(_minNumberCount.text),
                  maxValue: _selectedNumbers.length,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildIntervalSelector() {
    return Row(
      children: [
        Expanded(
          child: NumberSettingsField(
            label: 'Min',
            value: int.parse(_minInterval.text),
            onChanged: (value) => setState(() => _minInterval.text = value.toString()),
            minValue: 1,
            maxValue: int.parse(_maxInterval.text),
            suffix: 'sec',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NumberSettingsField(
            label: 'Max',
            value: int.parse(_maxInterval.text),
            onChanged: (value) => setState(() => _maxInterval.text = value.toString()),
            minValue: int.parse(_minInterval.text),
            maxValue: 60,
            suffix: 'sec',
          ),
        ),
      ],
    );
  }

  Future<void> _loadDebugMode() async {
    final debugMode = await _settingsService.isDebugMode();
    setState(() {
      _isDebugMode = debugMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appearance,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildLanguageSelector(context),
                  const SizedBox(height: 16),
                  _buildThemeSelector(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.trainingSetup,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  NumberSettingsField(
                    label: l10n.countdownLength,
                    value: int.parse(_countdownSeconds.text),
                    onChanged: (value) => setState(() => _countdownSeconds.text = value.toString()),
                    maxValue: 60,
                    suffix: 'sec',
                  ),
                  const SizedBox(height: 16),
                  TimeSettingsField(
                    label: l10n.roundLength,
                    duration: roundLength,
                    onChanged: (duration) {
                      setState(() {
                        _roundMinutes.text = duration.inMinutes.toString();
                        _roundSeconds.text = (duration.inSeconds % 60).toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TimeSettingsField(
                    label: l10n.breakLength,
                    duration: breakLength,
                    onChanged: (duration) {
                      setState(() {
                        _breakMinutes.text = duration.inMinutes.toString();
                        _breakSeconds.text = (duration.inSeconds % 60).toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  NumberSettingsField(
                    label: l10n.numberOfRounds,
                    value: int.parse(_numberOfRounds.text),
                    onChanged: (value) => setState(() => _numberOfRounds.text = value.toString()),
                    minValue: 1,
                    maxValue: 99,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.numbersConfiguration,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(l10n.selectNumbers),
                  _buildNumberSelector(),
                  const SizedBox(height: 16),
                  _buildNumberCountSelector(l10n),
                  const SizedBox(height: 16),
                  Text(l10n.intervalBetweenNumbers),
                  _buildIntervalSelector(),
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(l10n.debugMode),
            trailing: Switch(
              value: _isDebugMode,
              onChanged: (bool value) async {
                await _settingsService.setDebugMode(value);
                setState(() {
                  _isDebugMode = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
