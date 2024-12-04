import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print('Usage: dart tools/update_version.dart <version>');
    print('Example: dart tools/update_version.dart 1.0.1');
    exit(1);
  }

  final newVersion = args[0];
  if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(newVersion)) {
    print('Error: Version must be in format X.Y.Z (e.g., 1.0.1)');
    exit(1);
  }

  // Update version.dart
  final versionFile = File('lib/src/version.dart');
  versionFile.writeAsStringSync(
    '// This file is generated automatically\n'
    'const String appVersion = \'$newVersion\';'
  );

  // Update pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();
  final updatedPubspec = pubspecContent.replaceFirst(
    RegExp(r'version: \d+\.\d+\.\d+\+\d+'),
    'version: $newVersion+1'
  );
  pubspecFile.writeAsStringSync(updatedPubspec);

  print('Version updated to $newVersion');
  print('Please commit these changes and push to trigger the release workflow.');
} 