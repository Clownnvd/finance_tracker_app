import 'dart:async';
import 'dart:io';

import 'exceptions.dart';

class ExceptionMapper {
  static AppException map(dynamic e) {
    if (e is AppException) return e;
    if (e is SocketException) return const NetworkException('No internet connection');
    if (e is TimeoutException) return const TimeoutRequestException();
    return AppException(e.toString());
  }
}
