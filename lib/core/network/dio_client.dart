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

          // ✅ Supabase expects Authorization Bearer token
          // - if logged in: use accessToken
          // - else: use anonKey (very important for /auth/v1/*)
          options.headers['Authorization'] = 'Bearer ${token ?? anonKey}';

          return handler.next(options);
        },
        onError: (e, handler) {
          // log để nhìn ra lỗi thật
          // ignore: avoid_print
          print('❌ ${e.requestOptions.method} ${e.requestOptions.uri}');
          // ignore: avoid_print
          print('Status: ${e.response?.statusCode}');
          // ignore: avoid_print
          print('Data: ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }
}
