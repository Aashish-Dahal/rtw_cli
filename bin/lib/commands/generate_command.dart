import 'dart:io';

import 'package:args/args.dart';

import '../services/file_service.dart';
import '../services/injector_service.dart';
import '../services/path_service.dart';
import '../sub_commands/endpoint_sub_command.dart';
import '../sub_commands/flutter_sub_command.dart';
import '../sub_commands/page_sub_command.dart';
import '../sub_commands/bloc_sub_command.dart';

import '../sub_commands/repo_sub_command.dart';
import '../sub_commands/service_sub_command.dart';
import '../sub_commands/sub_command.dart';
import 'command.dart';

class GenerateCommand implements Command {
  final FileService _fileService;
  final InjectorService _injectorService;
  final PathService _pathService;

  GenerateCommand({
    FileService? fileService,
    InjectorService? injectorService,
    PathService? pathService,
  }) : _fileService = fileService ?? FileService(),
       _injectorService = injectorService ?? InjectorService(),
       _pathService = pathService ?? PathService();

  @override
  void execute(ArgResults results) {
    if (results.command?.name == 'generate') {
      final generateResults = results.command!;
      final featureName = results['feature'] as String?;
      final subCommand = generateResults.command!.name;
      final name =
          generateResults.command!.rest.isNotEmpty
              ? generateResults.command!.rest[0]
              : null;

      if (name == null) {
        print('❌ Error: Please provide a name for the component.');
        exit(1);
      }

      SubCommand subCommandInstance;
      switch (subCommand) {
        case 'page':
          subCommandInstance = PageSubCommand(
            fileService: _fileService,
            pathService: _pathService,
            type: generateResults.command!['type'] as String,
          );
          break;
        case 'service':
          subCommandInstance = ServiceSubCommand(
            fileService: _fileService,
            injectorService: _injectorService,
            pathService: _pathService,
          );
          break;
        case 'repository':
          subCommandInstance = RepositorySubCommand(
            fileService: _fileService,
            injectorService: _injectorService,
            pathService: _pathService,
          );
          break;
        case 'endpoint':
          subCommandInstance = EndpointSubCommand(
            fileService: _fileService,
            pathService: _pathService,
          );
          break;
        case 'bloc':
          subCommandInstance = BlocSubCommand(
            fileService: _fileService,
            pathService: _pathService,
          );
          break;
        case 'all':
          final pageSubCommand = PageSubCommand(
            fileService: _fileService,
            pathService: _pathService,
            type: generateResults.command?['type'] as String? ?? 'stateless',
          );
          final serviceSubCommand = ServiceSubCommand(
            fileService: _fileService,
            injectorService: _injectorService,
            pathService: _pathService,
          );
          final repositorySubCommand = RepositorySubCommand(
            fileService: _fileService,
            injectorService: _injectorService,
            pathService: _pathService,
          );
          final endpointSubCommand = EndpointSubCommand(
            fileService: _fileService,
            pathService: _pathService,
          );
          final blocSubCommand = BlocSubCommand(
            fileService: _fileService,
            pathService: _pathService,
          );
          pageSubCommand.execute(name, featureName, 'page');
          blocSubCommand.execute(name, featureName, 'bloc');
          serviceSubCommand.execute(name, featureName, 'service');
          repositorySubCommand.execute(name, featureName, 'repository');
          endpointSubCommand.execute(name, featureName, 'endpoint');
          return; // Exit after handling 'all' to avoid further processing
        default:
          print('❌ Unknown subcommand: $subCommand');
          exit(1);
      }

      subCommandInstance.execute(name, featureName, subCommand ?? '');
    } else {
      switch (results.command?.name) {
        case 'pub':
          FlutterSubCommand.execute([
            'pub',
            ...results.command!.rest,
          ], "flutter");
          break;
        case 'clean':
          FlutterSubCommand.execute([
            'clean',
            ...results.command!.rest,
          ], "flutter");
          break;
        case 'build':
          FlutterSubCommand.execute([
            'build',
            ...results.command!.rest,
          ], "flutter");
          break;
        case 'doctor':
          FlutterSubCommand.execute([
            'doctor',
            ...results.command!.rest,
          ], "flutter");
          break;
        case 'fix':
          FlutterSubCommand.execute(['fix', ...results.command!.rest], "dart");
          break;
        case 'format':
          FlutterSubCommand.execute([
            'format',
            ...results.command!.rest,
          ], "dart");
          break;

        default:
          print('❌ Unknown subcommand: ${results.command?.name}');
          exit(1);
      }
    }
  }
}
