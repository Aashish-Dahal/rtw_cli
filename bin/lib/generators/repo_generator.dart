import '../models/config.dart';
import '../utils/utils.dart';
import 'generator.dart';

class RepositoryGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final className = Utils.toClassName(config.name);
    return '''
import 'package:fpdart/fpdart.dart' show Either;
import '../config/api/api_error.dart' show Failure;
import '../config/api/api_response.dart' show ApiResponse;
import '../service/${config.name}_service.dart';


abstract class ${className}Repository {
  Future<Either<Failure, ApiResponse<dynamic>>> performAction();
}

class ${className}RepositoryImpl implements ${className}Repository {  
  final ${className}ApiService _${className.toLowerCase()}ApiService;

  ${className}RepositoryImpl({required ${className}ApiService ${className.toLowerCase()}ApiService}) : _${className.toLowerCase()}ApiService = ${className.toLowerCase()}ApiService;
  @override
  Future<Either<Failure, ApiResponse>> performAction() {
    // TODO: implement performAction
    throw UnimplementedError();
  }
}
''';
  }
}
