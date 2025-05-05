class ComponentConfig {
  final String name;
  final String? featureName;
  final String command;
  final String? type;
  String? filePath;

  ComponentConfig({
    required this.name,
    this.featureName,
    required this.command,
    this.type,
  });
}
