import 'dart:developer';

import '../error/exceptions.dart';
import '../error/exception_mapper.dart';
import 'base_response.dart';

abstract class BaseRepository {
  Future<BaseResponse<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return BaseResponse<T>(data: result);
    } catch (error, stack) {
      final mapped = ExceptionMapper.map(error);

      log(
        'Repository Error: ${mapped.message}',
        name: 'BaseRepository',
        stackTrace: stack,
      );

      return BaseResponse<T>(error: mapped.message);
    }
  }
}
