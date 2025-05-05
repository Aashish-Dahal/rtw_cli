import '../generators/endpoint_generator.dart';
import '../models/config.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import 'sub_command.dart';

class EndpointSubCommand implements SubCommand {
  final FileService _fileService;
  final PathService _pathService;

  EndpointSubCommand({
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
    final generator = EndpointGenerator();
    final filePath = _pathService.getFilePath(config);
    config.filePath = filePath;
    final content = generator.generate(config);

    _fileService.writeFile(filePath, content);
    print('🔗 Endpoint generated: $filePath');
  }
}
