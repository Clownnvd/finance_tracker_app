import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();

class DioClient {
  final Dio dio;

  DioClient({
    required String baseUrl,
    required String anonKey,
    required TokenProvider tokenProvider,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {
              'apikey': anonKey,
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await tokenProvider();
          options.headers['Authorization'] = 'Bearer ${token ?? anonKey}';
          handler.next(options);
        },
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    );
  }
}
