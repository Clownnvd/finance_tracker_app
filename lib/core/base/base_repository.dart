import 'dart:developer';

import '../error/exceptions.dart';
import 'base_response.dart';

abstract class BaseRepository {
  Future<BaseResponse<T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return BaseResponse<T>(data: result);
    } on AppException catch (e) {
      log('AppException: ${e.message}', name: 'BaseRepository');
      return BaseResponse<T>(error: e.message);
    } catch (e) {
      log('Unknown error: $e', name: 'BaseRepository');
      return BaseResponse<T>(error: 'Unexpected error');
    }
  }
}
