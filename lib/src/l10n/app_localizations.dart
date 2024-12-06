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
  String get training;
  String get numberOfRounds;
  String get getReady;
  String get trainingFinished;
  String get repeat;
  String get backToHome;
  String get about;
  String get version;
  String get author;
  String get sound;
  String get soundOn;
  String get soundOff;
  String get pause;
  String get resume;
  String get mute;
  String get unmute;
  String get theme;
  String get lightTheme;
  String get darkTheme;
  String get break_;
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
  @override
  String get training => 'Training';
  @override
  String get numberOfRounds => 'Number of Rounds';
  @override
  String get getReady => 'Get Ready!';
  @override
  String get trainingFinished => 'Training Finished!';
  @override
  String get repeat => 'Repeat';
  @override
  String get backToHome => 'Back to Home';
  @override
  String get about => 'About';
  @override
  String get version => 'Version';
  @override
  String get author => 'Author';
  @override
  String get sound => 'Sound';
  @override
  String get soundOn => 'Sound On';
  @override
  String get soundOff => 'Sound Off';
  @override
  String get pause => 'Pause';
  @override
  String get resume => 'Resume';
  @override
  String get mute => 'Mute';
  @override
  String get unmute => 'Unmute';
  @override
  String get theme => 'Theme';
  @override
  String get lightTheme => 'Light';
  @override
  String get darkTheme => 'Dark';
  @override
  String get break_ => 'Break';
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
  @override
  String get training => 'Trénink';
  @override
  String get numberOfRounds => 'Počet kol';
  @override
  String get getReady => 'Připravte se!';
  @override
  String get trainingFinished => 'Trénink dokončen!';
  @override
  String get repeat => 'Opakovat';
  @override
  String get backToHome => 'Zpět domů';
  @override
  String get about => 'O aplikaci';
  @override
  String get version => 'Verze';
  @override
  String get author => 'Autor';
  @override
  String get sound => 'Zvuk';
  @override
  String get soundOn => 'Zvuk zapnutý';
  @override
  String get soundOff => 'Zvuk vypnutý';
  @override
  String get pause => 'Pozastavit';
  @override
  String get resume => 'Pokračovat';
  @override
  String get mute => 'Ztlumit';
  @override
  String get unmute => 'Zapnout zvuk';
  @override
  String get theme => 'Téma';
  @override
  String get lightTheme => 'Světlé';
  @override
  String get darkTheme => 'Tmavé';
  @override
  String get break_ => 'Pauza';
} 