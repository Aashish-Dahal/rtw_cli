import 'dart:io';

import '../models/config.dart';
import '../utils/utils.dart';
import 'generator.dart';

class AppRouterGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final className = Utils.toClassName(config.name);
    final enumValue = config.name;

    final importPath =
        config.featureName != null
            ? "import '../../pages/${config.featureName}/page/${config.name}_page.dart';"
            : "import '../../pages/${config.featureName}/page/${config.featureName}_page.dart';";

    final routeContent = '''
      GoRoute(
        path: AppPage.$enumValue.toPath,
        name: AppPage.$enumValue.toName,
        builder: (context, state) => const ${className}Page(),
      ),
''';

    final file = File(config.filePath ?? '');
    if (!file.existsSync()) {
      final initialContent = '''
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
$importPath

import 'app_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  GoRouter get router => _goRouter;
  AppRouter();

  final _goRouter = GoRouter(
    initialLocation: AppPage.$enumValue.toPath,
    navigatorKey: rootNavigatorKey,
    routes: <RouteBase>[
$routeContent
    ],
    errorBuilder: (context, state) => const Scaffold(body: Center(child: Text('Route Not Found'))),
  );
}
''';
      return initialContent;
    }

    String existingContent = file.readAsStringSync();

    // Check if route already exists
    if (existingContent.contains('AppPage.$enumValue.toPath')) {
      print('Route for $enumValue already exists in ${config.filePath}.');
    }

    // Add import
    if (!existingContent.contains(importPath)) {
      final importLines = existingContent.split('\n');
      int lastImportIndex = importLines.lastIndexWhere(
        (line) => line.startsWith('import '),
      );
      if (lastImportIndex == -1) lastImportIndex = 0;
      importLines.insert(lastImportIndex + 1, importPath);
      existingContent = importLines.join('\n');
    }

    // Add route
    final routesIndex = existingContent.indexOf('routes: <GoRoute>[');
    if (routesIndex == -1) {
      print('Error: ${config.filePath} does not contain routes list.');
      exit(1);
    }
    final routesEndIndex = existingContent.indexOf('],', routesIndex);
    if (routesEndIndex == -1) {
      print('Error: ${config.filePath} routes list is malformed.');
      exit(1);
    }
    existingContent = existingContent.replaceRange(
      routesEndIndex,
      routesEndIndex,
      routeContent,
    );

    return existingContent;
  }
}
