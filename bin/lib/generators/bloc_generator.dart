import '../models/config.dart';
import '../utils/utils.dart';

class BlocGenerator {
  Map<String, String> generate(ComponentConfig config) {
    final rawName = config.name.toLowerCase();
    final className = Utils.toClassName(config.name);

    return {
      'bloc': _generateBloc(className, rawName),
      'event': _generateEvent(className, rawName),
      'state': _generateState(className, rawName),
    };
  }

  String _generateBloc(String className, String rawName) => '''
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '${rawName}_event.dart';
part '${rawName}_state.dart';

class ${className}Bloc extends Bloc<${className}Event, ${className}State> {
final ${className}Repository ${className.toLowerCase()}Repository;
  ${className}Bloc(this.${className.toLowerCase()}Repository) : super(${className}Initial()) {
    on<${className}Started>(_onStarted);
  }

  void _onStarted(${className}Started event, Emitter<${className}State> emit) {
    // TODO: implement event handler
  }
}
''';

  String _generateEvent(String className, String rawName) => '''
 part of '${rawName}_bloc.dart';

sealed class ${className}Event extends Equatable {
  const ${className}Event();

  @override
  List<Object?> get props => [];
}

class ${className}Started extends ${className}Event {}
''';

  String _generateState(String className, String rawName) => '''
part of '${rawName}_bloc.dart';

sealed class ${className}State extends Equatable {
  const ${className}State();

  @override
  List<Object?> get props => [];
}

class ${className}Initial extends ${className}State {}
''';
}
