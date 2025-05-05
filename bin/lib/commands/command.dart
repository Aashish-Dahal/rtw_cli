import 'package:args/args.dart';

abstract class Command {
  void execute(ArgResults results);
}
