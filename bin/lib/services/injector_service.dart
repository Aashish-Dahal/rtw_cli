import 'dart:io';
import '../models/config.dart';
import '../utils/utils.dart';
import 'file_service.dart';

class InjectorService {
  final FileService _fileService;

  InjectorService({FileService? fileService})
    : _fileService = fileService ?? FileService();

  /// Update injector file by adding service or repository registration inside _registerFeatureServices
  void updateInjector(ComponentConfig config, String type) {
    final injectorPath = 'lib/app/injector.dart';
    final className = Utils.toClassName(config.name);

    final implName =
        type == 'service'
            ? '${className}ApiServiceImpl'
            : '${className}RepositoryImpl';

    final importPath =
        type == 'service'
            ? config.featureName != null
                ? "import 'features/${config.featureName}/services/${config.name}_service.dart';"
                : "import 'services/${config.name}_service.dart';"
            : config.featureName != null
            ? "import 'features/${config.featureName}/repository/${config.name}_repo.dart';"
            : "import 'repository/${config.name}_repo.dart';";

    final registration =
        type == 'service'
            ? 'sl.registerLazySingleton<${className}ApiService>(() => $implName(dioService: sl<DioService>()));'
            : 'sl.registerLazySingleton<${className}Repository>(() => $implName(${className.toLowerCase()}ApiService:${className}ApiService));';

    final file = File(injectorPath);
    if (!file.existsSync()) {
      print('Error: $injectorPath does not exist.');
      return;
    }

    String content = file.readAsStringSync();

    // Add import if missing
    if (!content.contains(importPath)) {
      final lines = content.split('\n');
      int lastImportIndex = lines.lastIndexWhere(
        (line) => line.startsWith('import '),
      );
      lastImportIndex = lastImportIndex < 0 ? 0 : lastImportIndex;
      lines.insert(lastImportIndex + 1, importPath);
      content = lines.join('\n');
    }

    // Find _registerFeatureServices function
    final registerFnIndex = content.indexOf('void _registerFeatureServices()');
    if (registerFnIndex == -1) {
      print('Error: _registerFeatureServices() not found in $injectorPath.');
      return;
    }

    // Find opening brace of _registerFeatureServices
    final openBraceIndex = content.indexOf('{', registerFnIndex);
    if (openBraceIndex == -1) {
      print(
        'Error: Could not find opening brace of _registerFeatureServices().',
      );
      return;
    }

    // Insert registration after opening brace
    final insertIndex = openBraceIndex + 1;
    content = content.replaceRange(
      insertIndex,
      insertIndex,
      '\n  $registration',
    );

    // Write updated content back
    _fileService.writeFile(injectorPath, content);

    print('💉 Updated $injectorPath with $type: $className');
  }
}
