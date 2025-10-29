import '../models/config.dart';
import '../utils/utils.dart';
import 'generator.dart';

class ServiceGenerator implements Generator {
  @override
  String generate(ComponentConfig config) {
    final className = Utils.toClassName(config.name);
    return '''
import 'package:fpdart/fpdart.dart' show Either;
import '../config/api/api_error.dart' show Failure;
import '../config/api/api_response.dart' show ApiResponse;
import '../../../config/api/dio_service.dart' show DioService;


abstract class ${className}ApiService {
  Future<Either<Failure, ApiResponse<dynamic>>> performAction();
}

class ${className}ApiServiceImpl implements ${className}ApiService {  
  final DioService _dioService;
  ${className}ApiServiceImpl({required DioService dioService}) : _dioService = dioService;

  @override
  Future<Either<Failure, ApiResponse>> performAction() {
    // TODO: implement performAction
    throw UnimplementedError();
  }
}
''';
  }
}
