import '../models/config.dart';
import '../utils/utils.dart';
import 'generator.dart';

class PageGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final className = Utils.toClassName(config.name);
    return config.type == 'stateless'
        ? '''
import 'package:flutter/material.dart';
import '../../../widgets/organisms/${className.toLowerCase()}_page_view.dart';


class ${className}Page extends StatelessWidget {
  const ${className}Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar( title: const Text("$className Page")),
         body:${className}PageView(),
    );
  }
}
'''
        : '''
import 'package:flutter/material.dart';
import '../../../widgets/organisms/${className.toLowerCase()}_page_view.dart';


class ${className}Page extends StatefulWidget {
  const ${className}Page({super.key});

  @override
  State<${className}Page> createState() => _${className}PageState();
}

class _${className}PageState extends State<${className}Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar( title: const Text("$className Page")),
         body:${className}PageView(),
    );
    
  }
}
''';
  }

  (String, String) widgetGenerate(ComponentConfig config) {
    final className = Utils.toClassName(config.name);
    final filePath =
        'lib/app/widgets/organisms/${className.toLowerCase()}_page_view.dart';
    final content = '''
import 'package:flutter/material.dart';

class ${className}PageView extends StatelessWidget {
  const ${className}PageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
''';
    return (filePath, content);
  }
}
