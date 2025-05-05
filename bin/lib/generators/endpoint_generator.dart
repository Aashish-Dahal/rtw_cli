import 'dart:io';

import '../models/config.dart';
import 'generator.dart';

class EndpointGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final endpointName = config.name;
    final endpointPath =
        config.featureName != null
            ? '/${config.featureName}/${config.name}'
            : '/${config.name}';
    final content = '''
static const String $endpointName = '$endpointPath';
''';

    final file = File(config.filePath ?? '');
    if (!file.existsSync()) {
      return '''
class ApiEndpoints {
$content
}
''';
    }

    String existingContent = file.readAsStringSync().trim();
    if (existingContent.endsWith('}')) {
      existingContent = existingContent.substring(
        0,
        existingContent.length - 1,
      );
      existingContent += content;
      existingContent += '}';
    } else {
      print('❌ Error: ${config.filePath} does not end with a closing brace.');
      exit(1);
    }

    return existingContent;
  }
}
