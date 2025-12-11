import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'exceptions.dart';

class ExceptionMapper {
  static AppException map(dynamic error) {
    if (error is sb.AuthException) {
      return AuthException(error.message);
    }

    if (error is SocketException) {
      return const NetworkException('No internet connection');
    }

    if (error is TimeoutException) {
      return const TimeoutRequestException();
    }

    if (error is ValidationException) {
      return error;
    }

    if (error is AppException) {
      return error;
    }

    return const ServerException('Unexpected server error');
  }
}
