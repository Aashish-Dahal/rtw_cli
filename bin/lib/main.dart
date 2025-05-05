import 'dart:io';

import 'package:args/args.dart';

import 'commands/generate_command.dart';

void main(List<String> arguments) {
  final parser =
      ArgParser()
        ..addCommand('generate')
        ..addCommand('pub')
        ..addCommand('clean')
        ..addCommand('fix')
        ..addCommand('format')
        ..addCommand('build')
        ..addCommand('doctor')
        ..addOption(
          'feature',
          abbr: 'f',
          help: 'Feature name for modular structure',
        );

  final generateParser =
      parser.commands['generate']!
        ..addCommand('page')
        ..addCommand('service')
        ..addCommand('repository')
        ..addCommand('endpoint')
        ..addCommand('all');

  generateParser.commands['page']?.addOption(
    'type',
    abbr: 't',
    allowed: ['stateless', 'stateful'],
    defaultsTo: 'stateless',
    help: 'Widget type (stateless or stateful)',
  );

  generateParser.commands['all']?.addOption(
    'type',
    abbr: 't',
    allowed: ['stateless', 'stateful'],
    defaultsTo: 'stateless',
    help: 'Widget type (stateless or stateful)',
  );

  try {
    final results = parser.parse(arguments);

    if (results.command?.name == 'generate' ||
        results.command?.name == "pub" ||
        results.command?.name == "build" ||
        results.command?.name == "clean" ||
        results.command?.name == "fix" ||
        results.command?.name == "format" ||
        results.command?.name == "doctor") {
      final command = GenerateCommand();
      if (results.command != null) {
        command.execute(results);
      } else {
        print('❌ Null Error');
      }
    } else {
      print('❌ Unknown command.');
      printUsage(parser);
      exit(1);
    }
  } catch (e) {
    print('❌ Error: $e');
    printUsage(parser);
    exit(1);
  }
}

void printUsage(ArgParser parser) {
  print(
    '⚠️ Usage: rtw generate <component> <name> [--type stateless|stateful] [--feature <feature_name>]',
  );
  print('⚠️ Components: page, service, repository, endpoint');
  print(
    '⚠️Example: rtw generate page user_profile --type stateless --feature user',
  );
  print(parser.usage);
}
