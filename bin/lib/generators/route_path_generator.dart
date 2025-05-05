import 'dart:io';

import '../models/config.dart';
import '../utils/utils.dart';
import 'generator.dart';

class RoutePathGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final enumValue = config.name;
    final path =
        config.featureName != null ? '/${config.name}' : '/${config.name}';
    final nameCapitalized = Utils.toClassName(config.name);

    final enumContent = '''
  $enumValue,
''';

    final toPathContent = '''
      case AppPage.$enumValue:
        return '$path';
''';

    final toNameContent = '''
      case AppPage.$enumValue:
        return '$nameCapitalized';
''';

    final file = File(config.filePath ?? '');
    if (!file.existsSync()) {
      final initialContent = '''
enum AppPage {
$enumContent
}

extension AppPageExtension on AppPage {
  String get toPath {
    switch (this) {
$toPathContent
    }
  }

  String get toName {
    switch (this) {
$toNameContent
    }
  }
}
''';
      return initialContent;
    }

    String existingContent = file.readAsStringSync();

    // Check if enum value already exists
    if (existingContent.contains('AppPage.$enumValue')) {
      print('Enum value $enumValue already exists in ${config.filePath}');
    }

    // Update enum
    final enumIndex = existingContent.indexOf('enum AppPage {');
    if (enumIndex == -1) {
      print('Error: ${config.filePath} does not contain AppPage enum.');
      exit(1);
    }
    final enumEndIndex = existingContent.indexOf('}', enumIndex);
    existingContent = existingContent.replaceRange(
      enumEndIndex,
      enumEndIndex,
      enumContent,
    );

    // Update toPath
    final toPathIndex = existingContent.indexOf('String get toPath {');
    if (toPathIndex == -1) {
      print('Error: ${config.filePath} does not contain toPath getter.');
      exit(1);
    }
    final toPathSwitchEndIndex = existingContent.indexOf('}', toPathIndex);
    existingContent = existingContent.replaceRange(
      toPathSwitchEndIndex,
      toPathSwitchEndIndex,
      toPathContent,
    );

    // Update toName
    final toNameIndex = existingContent.indexOf('String get toName {');
    if (toNameIndex == -1) {
      print('Error: ${config.filePath} does not contain toName getter.');
      exit(1);
    }
    final toNameSwitchEndIndex = existingContent.indexOf('}', toNameIndex);
    existingContent = existingContent.replaceRange(
      toNameSwitchEndIndex,
      toNameSwitchEndIndex,
      toNameContent,
    );

    return existingContent;
  }
}
