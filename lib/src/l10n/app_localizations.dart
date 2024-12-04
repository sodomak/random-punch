import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appTitle;
  String get startTraining;
  String get settings;
  String get roundLength;
  String get breakLength;
  String get countdownLength;
  String get selectNumbers;
  String get numbersToShow;
  String get intervalBetweenNumbers;
  String get save;
  String get fixedCount;
  String get randomRange;
  String get minimumDigits;
  String get maximumDigits;
  String get numberOfDigits;
}

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'Random Punch';
  @override
  String get startTraining => 'Start Training';
  @override
  String get settings => 'Settings';
  @override
  String get roundLength => 'Round Length (minutes:seconds)';
  @override
  String get breakLength => 'Break Length (minutes:seconds)';
  @override
  String get countdownLength => 'Countdown Length (seconds)';
  @override
  String get selectNumbers => 'Select Numbers';
  @override
  String get numbersToShow => 'Numbers to Show';
  @override
  String get intervalBetweenNumbers => 'Interval Between Numbers (seconds)';
  @override
  String get save => 'Save';
  @override
  String get fixedCount => 'Fixed Count';
  @override
  String get randomRange => 'Random Range';
  @override
  String get minimumDigits => 'Minimum Digits';
  @override
  String get maximumDigits => 'Maximum Digits';
  @override
  String get numberOfDigits => 'Number of Digits to Show';
}

class AppLocalizationsCs extends AppLocalizations {
  @override
  String get appTitle => 'Random Punch';
  @override
  String get startTraining => 'Začít Trénink';
  @override
  String get settings => 'Nastavení';
  @override
  String get roundLength => 'Délka kola (minuty:sekundy)';
  @override
  String get breakLength => 'Délka pauzy (minuty:sekundy)';
  @override
  String get countdownLength => 'Délka odpočtu (sekundy)';
  @override
  String get selectNumbers => 'Vybrat čísla';
  @override
  String get numbersToShow => 'Počet zobrazených čísel';
  @override
  String get intervalBetweenNumbers => 'Interval mezi čísly (sekundy)';
  @override
  String get save => 'Uložit';
  @override
  String get fixedCount => 'Pevný počet';
  @override
  String get randomRange => 'Náhodný rozsah';
  @override
  String get minimumDigits => 'Minimum číslic';
  @override
  String get maximumDigits => 'Maximum číslic';
  @override
  String get numberOfDigits => 'Počet zobrazených číslic';
} 