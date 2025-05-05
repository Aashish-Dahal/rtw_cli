import 'dart:convert';
import 'dart:io';

class FlutterSubCommand {
  static void execute(List<String> args, command) async {
    if (command == "flutter") {
      print('Running: flutter ${args.join(' ')}');
      final process = await Process.start('flutter', args, runInShell: true);

      process.stdout
          .transform(utf8.decoder)
          .listen((data) => stdout.write(data));
      process.stderr
          .transform(utf8.decoder)
          .listen((data) => stderr.write(data));

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        print('Command failed with exit code $exitCode');
        exit(exitCode);
      }
    } else {
      print('Running: dart ${args.join(' ')}');
      final process = await Process.start('dart', args, runInShell: true);

      process.stdout
          .transform(utf8.decoder)
          .listen((data) => stdout.write(data));
      process.stderr
          .transform(utf8.decoder)
          .listen((data) => stderr.write(data));

      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        print('Command failed with exit code $exitCode');
        exit(exitCode);
      }
    }
  }
}
