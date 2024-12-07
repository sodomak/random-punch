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
  String get statistics;
  String get day;
  String get week;
  String get month;
  String get all;
  String get totalTrainings;
  String get totalTrainingTime;
  String get totalBreakTime;
  String get combinationsThrown;
  String get punchesThrown;
  String get roundsCompleted;
  String get resetStats;
  String get resetStatsConfirmation;
  String get reset;
  String get cancel;
  String get totalTime;
  String get appearance;
  String get trainingSetup;
  String get numbersConfiguration;
  String get help;
  String get quickStartGuide;
  String get helpStartTraining;
  String get helpGetReady;
  String get helpTraining;
  String get helpBreaks;
  String get helpRoundLength;
  String get helpBreakLength;
  String get helpCountdownLength;
  String get helpNumberOfRounds;
  String get helpNumbersToShow;
  String get helpFixedCount;
  String get helpRandomRange;
  String get helpIntervalBetweenNumbers;
  String get helpStatsProgress;
  String get helpStatsTime;
  String get helpStatsCombos;
  String get helpStatsFilter;
  String get helpVoiceAnnouncements;
  String get helpSoundEffects;
  String get helpMutableAudio;
  String get debugMode;
  String get shareLogs;
  String get enableDebugMode;
  String get noLogsAvailable;
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
  @override
  String get statistics => 'Statistics';
  @override
  String get day => 'Day';
  @override
  String get week => 'Week';
  @override
  String get month => 'Month';
  @override
  String get all => 'All';
  @override
  String get totalTrainings => 'Total Trainings';
  @override
  String get totalTrainingTime => 'Total Training Time';
  @override
  String get totalBreakTime => 'Total Break Time';
  @override
  String get combinationsThrown => 'Combinations Thrown';
  @override
  String get punchesThrown => 'Punches Thrown';
  @override
  String get roundsCompleted => 'Rounds Completed';
  @override
  String get resetStats => 'Reset Statistics';
  @override
  String get resetStatsConfirmation => 'Are you sure you want to reset all statistics? This action cannot be undone.';
  @override
  String get reset => 'Reset';
  @override
  String get cancel => 'Cancel';
  @override
  String get totalTime => 'Total Time';
  @override
  String get appearance => 'Appearance';
  @override
  String get trainingSetup => 'Training Setup';
  @override
  String get numbersConfiguration => 'Numbers Configuration';
  @override
  String get help => 'Help';
  @override
  String get quickStartGuide => 'Quick Start Guide';
  @override
  String get helpStartTraining => 'Click the "Start Training" button on the home screen';
  @override
  String get helpGetReady => 'A countdown will begin before your training starts';
  @override
  String get helpTraining => 'Follow the numbers displayed and perform corresponding techniques';
  @override
  String get helpBreaks => 'Rest between rounds when indicated';
  @override
  String get helpRoundLength => 'Set the duration of each training round';
  @override
  String get helpBreakLength => 'Set the duration of rest periods between rounds';
  @override
  String get helpCountdownLength => 'Set the initial countdown duration before training starts';
  @override
  String get helpNumberOfRounds => 'Set how many rounds you want to train';
  @override
  String get helpNumbersToShow => 'Choose between fixed count or random range';
  @override
  String get helpFixedCount => 'Always shows the same number of digits';
  @override
  String get helpRandomRange => 'Shows a varying number of digits within your set range';
  @override
  String get helpIntervalBetweenNumbers => 'Set how quickly new numbers appear';
  @override
  String get helpStatsProgress => 'Track your training progress with detailed statistics';
  @override
  String get helpStatsTime => 'View total training time, breaks, and rounds completed';
  @override
  String get helpStatsCombos => 'Monitor combinations and punches thrown';
  @override
  String get helpStatsFilter => 'Filter statistics by day, week, month, or all-time';
  @override
  String get helpVoiceAnnouncements => 'Voice announcements of numbers in English or Czech';
  @override
  String get helpSoundEffects => 'Sound effects for training events (start, end, breaks)';
  @override
  String get helpMutableAudio => 'Mutable audio for quiet training sessions';
  @override
  String get debugMode => 'Debug Mode';
  @override
  String get shareLogs => 'Share Debug Logs';
  @override
  String get enableDebugMode => 'Enable debug mode in settings to share logs';
  @override
  String get noLogsAvailable => 'No debug logs available';
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
  @override
  String get statistics => 'Statistiky';
  @override
  String get day => 'Den';
  @override
  String get week => 'Týden';
  @override
  String get month => 'Měsíc';
  @override
  String get all => 'Vše';
  @override
  String get totalTrainings => 'Celkový počet tréninků';
  @override
  String get totalTrainingTime => 'Celkový čas tréninků';
  @override
  String get totalBreakTime => 'Celkový čas pauzy';
  @override
  String get combinationsThrown => 'Celkový počet kombinací';
  @override
  String get punchesThrown => 'Celkový počet úderů';
  @override
  String get roundsCompleted => 'Celkový počet kol';
  @override
  String get resetStats => 'Resetovat statistiky';
  @override
  String get resetStatsConfirmation => 'Opravdu chcete resetovat všechny statistiky? Tuto akci nelze vrátit zpět.';
  @override
  String get reset => 'Resetovat';
  @override
  String get cancel => 'Zrušit';
  @override
  String get totalTime => 'Celkový čas';
  @override
  String get appearance => 'Vzhled';
  @override
  String get trainingSetup => 'Nastavení tréninku';
  @override
  String get numbersConfiguration => 'Konfigurace čísel';
  @override
  String get help => 'Návod';
  @override
  String get quickStartGuide => 'Rychlý návod';
  @override
  String get helpStartTraining => 'Klikněte na tlačítko "Začít Trénink" na hlavní obrazovce';
  @override
  String get helpGetReady => 'Počítač se začne odpočítávat před začátkem tréninku';
  @override
  String get helpTraining => 'Následujte zobrazená čísla a provádějte odpovídající techniky';
  @override
  String get helpBreaks => 'Odpočinek mezi koly, když je to naznačeno';
  @override
  String get helpRoundLength => 'Nastavte dobu trvání každého tréninkového kola';
  @override
  String get helpBreakLength => 'Nastavte dobu odpočinku mezi koly';
  @override
  String get helpCountdownLength => 'Nastavte dobu počátečního odpočtu před začátkem tréninku';
  @override
  String get helpNumberOfRounds => 'Nastavte, kolik kol chcete trénovat';
  @override
  String get helpNumbersToShow => 'Vyberte mezi pevným počtem nebo náhodným rozsahem';
  @override
  String get helpFixedCount => 'Vždy ukazuje stejný počet číslic';
  @override
  String get helpRandomRange => 'Ukazuje různý počet číslic v rámci nastaveného rozsahu';
  @override
  String get helpIntervalBetweenNumbers => 'Nastavte, jak rychle se objevují nové čísla';
  @override
  String get helpStatsProgress => 'Sledujte postup tréninku s podrobnými statistikami';
  @override
  String get helpStatsTime => 'Zobrazte celkový čas tréninků, pauz a dokončených kol';
  @override
  String get helpStatsCombos => 'Monitorujte kombinace a údery';
  @override
  String get helpStatsFilter => 'Filtrovat statistiky podle dne, týdne, měsíce nebo celé doby';
  @override
  String get helpVoiceAnnouncements => 'Zvukové zprávy o číslech v angličtině nebo češtině';
  @override
  String get helpSoundEffects => 'Zvukové efekty pro tréninkové události (začátek, konec, pauzy)';
  @override
  String get helpMutableAudio => 'Měnitelný zvuk pro tišší tréninky';
  @override
  String get debugMode => 'Ladící režim';
  @override
  String get shareLogs => 'Sdílet protokoly';
  @override
  String get enableDebugMode => 'Pro sdílení protokolů povolte ladící režim v nastavení';
  @override
  String get noLogsAvailable => 'Žádné protokoly nejsou k dispozici';
} 