import 'dart:io';

import 'package:path/path.dart' as path;

import '../models/config.dart';

class PathService {
  final String basePath = "lib/app";
  String getFilePath(ComponentConfig config, {String? defaultPath}) {
    String base;
    switch (config.command) {
      case 'page':
        base =
            config.featureName != null
                ? '$basePath/pages/${config.featureName}/page'
                : '$basePath/pages';
        Directory(base).createSync(recursive: true);
        config.filePath = path.join(base, '${config.name}_page.dart');
        break;
      case 'service':
        base =
            config.featureName != null
                ? '$basePath/services/'
                : '$basePath/services/';
        Directory(base).createSync(recursive: true);
        config.filePath = path.join(base, '${config.name}_service.dart');
        break;
      case 'repository':
        base =
            config.featureName != null
                ? '$basePath/repository/'
                : '$basePath/repository/';
        Directory(base).createSync(recursive: true);
        config.filePath = path.join(base, '${config.name}_repo.dart');
        break;
      case 'endpoint':
        base =
            config.featureName != null
                ? '$basePath/config/api/api_endpoints.dart'
                : '$basePath/config/api/api_endpoints.dart';

        config.filePath = base;
        break;
      default:
        base =
            config.featureName != null
                ? '$basePath/${config.featureName}'
                : 'lib/';
        config.filePath = defaultPath ?? base;
        break;
    }
    return config.filePath!;
  }
}
