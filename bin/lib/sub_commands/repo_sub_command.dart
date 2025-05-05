import '../generators/repo_generator.dart';
import '../models/config.dart';
import '../services/file_service.dart';
import '../services/injector_service.dart';
import '../services/path_service.dart';
import 'sub_command.dart';

class RepositorySubCommand implements SubCommand {
  final FileService _fileService;
  final InjectorService _injectorService;
  final PathService _pathService;

  RepositorySubCommand({
    required FileService fileService,
    required InjectorService injectorService,
    required PathService pathService,
  }) : _fileService = fileService,
       _injectorService = injectorService,
       _pathService = pathService;

  @override
  void execute(String name, String? featureName, String command) {
    final config = ComponentConfig(
      name: name,
      featureName: featureName,
      command: command,
    );
    final generator = RepositoryGenerator();
    final content = generator.generate(config);
    final filePath = _pathService.getFilePath(config);
    _fileService.writeFile(filePath, content);
    print('📦 Repository generated: $filePath');
    _injectorService.updateInjector(config, 'repository');
  }
}
