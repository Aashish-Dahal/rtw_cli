import 'dart:io';

import '../models/config.dart';
import '../utils/utils.dart';
import 'file_service.dart';

class InjectorService {
  final FileService _fileService;

  InjectorService({FileService? fileService})
    : _fileService = fileService ?? FileService();

  void updateInjector(ComponentConfig config, String type) {
    final injectorPath = '../lib/app/injector.dart';
    final className = Utils.toClassName(config.name);
    final implName =
        '$className${type == 'service' ? 'ApiServiceImpl' : 'RepositoryImpl'}';
    final importPath =
        type == 'service'
            ? config.featureName != null
                ? "import 'services/${config.name}_service.dart';"
                : "import 'services/${config.name}_service.dart';"
            : config.featureName != null
            ? "import 'repository/${config.name}_repo.dart';"
            : "import 'repository/${config.name}_repo.dart';";
    final registration = '''
  sl.registerSingleton<$className${type == 'service' ? 'ApiService' : 'Repository'}>($implName());
''';

    final file = File(injectorPath);
    String existingContent = file.readAsStringSync();

    if (!existingContent.contains(importPath)) {
      final importLines = existingContent.split('\n');
      int lastImportIndex = importLines.lastIndexWhere(
        (line) => line.startsWith('import '),
      );
      if (lastImportIndex == -1) lastImportIndex = 0;
      importLines.insert(lastImportIndex + 1, importPath);
      existingContent = importLines.join('\n');
    }

    final sectionMarker = type == 'service' ? '// Services' : '// Repositories';
    if (!existingContent.contains(sectionMarker)) {
      existingContent = existingContent.replaceFirst(
        'void _initServiceLocator() {',
        'void _initServiceLocator() {\n  $sectionMarker',
      );
    }

    final lines = existingContent.split('\n');
    final sectionIndex = lines.indexWhere(
      (line) => line.contains(sectionMarker),
    );
    if (sectionIndex != -1) {
      lines.insert(sectionIndex + 1, registration.trim());
      existingContent = lines.join('\n');
    } else {
      existingContent = existingContent.replaceFirst(
        '}',
        '$registration\n  }',
        existingContent.lastIndexOf('void _initServiceLocator()'),
      );
    }

    _fileService.writeFile(injectorPath, existingContent);
    print('💉 Updated $injectorPath with $type: $className');
  }
}
