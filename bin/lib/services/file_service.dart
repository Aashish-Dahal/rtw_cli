import 'dart:io';

class FileService {
  void writeFile(String filePath, String content) {
    final file = File(filePath);
    if (file.existsSync()) {
      print('📄 File $filePath exists. Overwriting with new content.');
    }
    final parentDir = file.parent;
    if (!parentDir.existsSync()) {
      parentDir.createSync(recursive: true);
    }
    file.writeAsStringSync(content, mode: FileMode.write);
  }
}
