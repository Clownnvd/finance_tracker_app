import 'package:dio/dio.dart';
import 'package:finance_tracker_app/core/network/dio_client.dart';
import 'package:finance_tracker_app/core/network/supabase_endpoints.dart';

abstract class SettingsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getMine({required String uid});
  Future<List<Map<String, dynamic>>> upsert(Map<String, dynamic> body);
  Future<List<Map<String, dynamic>>> patch({
    required String uid,
    required Map<String, dynamic> body,
  });
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient _client;
  SettingsRemoteDataSourceImpl(this._client);

  Dio get _dio => _client.dio;

  @override
  Future<List<Map<String, dynamic>>> getMine({required String uid}) async {
    final res = await _dio.get(
      SupabaseEndpoints.settings, // "/rest/v1/settings"
      queryParameters: {'user_id': 'eq.$uid'},
    );
    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> upsert(Map<String, dynamic> body) async {
    final res = await _dio.post(
      SupabaseEndpoints.settings,
      data: body,
      options: Options(headers: const {
        'Prefer': 'return=representation,resolution=merge-duplicates',
      }),
    );
    return _asListOfMap(res.data);
  }

  @override
  Future<List<Map<String, dynamic>>> patch({
    required String uid,
    required Map<String, dynamic> body,
  }) async {
    final res = await _dio.patch(
      SupabaseEndpoints.settings,
      queryParameters: {'user_id': 'eq.$uid'},
      data: body,
      options: Options(headers: const {'Prefer': 'return=representation'}),
    );
    return _asListOfMap(res.data);
  }

  List<Map<String, dynamic>> _asListOfMap(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    return <Map<String, dynamic>>[];
  }
}
