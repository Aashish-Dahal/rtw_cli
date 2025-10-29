import 'package:path/path.dart' as path;

import '../generators/bloc_generator.dart';
import '../models/config.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import 'sub_command.dart';

class BlocSubCommand implements SubCommand {
  final FileService _fileService;
  final PathService _pathService;

  BlocSubCommand({
    required FileService fileService,
    required PathService pathService,
  }) : _fileService = fileService,
       _pathService = pathService;

  @override
  void execute(String name, String? featureName, String command) {
    final config = ComponentConfig(
      name: name,
      featureName: featureName,
      command: command,
    );
    final generator = BlocGenerator();
    final filePath = _pathService.getFilePath(config);
    final baseDir = path.dirname(filePath);
    final rawName = path.basenameWithoutExtension(filePath);
    final files = generator.generate(config);

    _fileService.writeFile(filePath, files['bloc']!);
    _fileService.writeFile(
      path.join(baseDir, '${rawName}_event.dart'),
      files['event']!,
    );
    _fileService.writeFile(
      path.join(baseDir, '${rawName}_state.dart'),
      files['state']!,
    );
    print('🔗 Bloc generated: $filePath');
  }
}
