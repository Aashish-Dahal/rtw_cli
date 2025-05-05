import '../models/config.dart';

abstract class Generator {
  String generate(ComponentConfig config);
}
