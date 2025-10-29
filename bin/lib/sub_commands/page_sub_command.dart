import '../generators/app_router_generator.dart';
import '../generators/page_generator.dart';
import '../generators/route_path_generator.dart';
import '../models/config.dart';
import '../services/file_service.dart';
import '../services/path_service.dart';
import 'sub_command.dart';

class PageSubCommand implements SubCommand {
  final FileService _fileService;
  final PathService _pathService;
  final String _type;

  PageSubCommand({
    required FileService fileService,
    required PathService pathService,
    required String type,
  }) : _fileService = fileService,
       _pathService = pathService,
       _type = type;

  @override
  void execute(String name, String? featureName, String command) {
    final config = ComponentConfig(
      name: name,
      featureName: featureName,
      command: command,
      type: _type,
    );
    final generator = PageGenerator();
    final routePathGenerator = RoutePathGenerator();
    final appRouterGenerator = AppRouterGenerator();

    final routePath = "lib/app/config/routes/route_path.dart";
    final appRouterPath = "lib/app/config/routes/app_routes.dart";

    final content = generator.generate(config);
    final routeContent = routePathGenerator.generate(
      config..filePath = routePath,
    );
    final appRouterContent = appRouterGenerator.generate(
      config..filePath = appRouterPath,
    );
    final filePath = _pathService.getFilePath(config);

    _fileService.writeFile(filePath, content);
    _fileService.writeFile(routePath, routeContent);
    _fileService.writeFile(appRouterPath, appRouterContent);

    String message = '\x1B[32m 📃 Page generated: $filePath \x1B[0m';
    int boxWidth = message.length + 4;

    String startBorder = '╔${'═' * (boxWidth - 2)}╗';
    String boxContent = ' $message ';
    String endBorder = '╚${'═' * (boxWidth - 2)}╝';

    print(startBorder);
    print(boxContent);
    print(endBorder);
  }
}
