import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finance_tracker_app/core/network/dio_client.dart';

class MockAdapter extends Mock implements HttpClientAdapter {}

class _StreamResponseBody extends ResponseBody {
  _StreamResponseBody(String body, int statusCode, {Map<String, List<String>>? headers})
      : super.fromString(body, statusCode, headers: headers);
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  group('DioClient', () {
    test('attaches Authorization header', () async {
      final adapter = MockAdapter();

      when(() => adapter.fetch(any(), any(), any())).thenAnswer((invocation) async {
        final options = invocation.positionalArguments[0] as RequestOptions;

        expect(options.headers['Authorization'], 'Bearer test_token');

        return _StreamResponseBody('{"ok":true}', 200);
      });

      final client = DioClient(
        baseUrl: 'https://example.com',
        anonKey: 'anon',
        tokenProvider: () async => 'test_token',
      );

      client.dio.httpClientAdapter = adapter;

      final res = await client.dio.get('/ping');
      expect(res.statusCode, 200);
    });

    test('uses anonKey when tokenProvider returns null', () async {
      final adapter = MockAdapter();

      when(() => adapter.fetch(any(), any(), any())).thenAnswer((invocation) async {
        final options = invocation.positionalArguments[0] as RequestOptions;

        expect(options.headers['Authorization'], 'Bearer anon');

        return _StreamResponseBody('{"ok":true}', 200);
      });

      final client = DioClient(
        baseUrl: 'https://example.com',
        anonKey: 'anon',
        tokenProvider: () async => null,
      );

      client.dio.httpClientAdapter = adapter;

      final res = await client.dio.get('/ping');
      expect(res.statusCode, 200);
    });
  });
}
