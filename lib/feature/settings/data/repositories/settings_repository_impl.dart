import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/network/user_id_local_data_source.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';
import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_data_source.dart';
import '../dto/settings_dto.dart';
import '../mappers/settings_mapper.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remote;
  final UserIdLocalDataSource _userIdLocal;

  SettingsRepositoryImpl({
    required SettingsRemoteDataSource remote,
    required UserIdLocalDataSource userIdLocal,
  })  : _remote = remote,
        _userIdLocal = userIdLocal;

  @override
  Future<AppSettings?> getMine() async {
    try {
      final uid = await _requireUserId();
      final raw = await _remote.getMine(uid: uid);
      if (raw.isEmpty) return null;
      final dto = SettingsDto.fromJson(raw.first);
      return SettingsMapper.toDomain(dto);
    } catch (e, st) {
      AppLogger.repository('SettingsRepository.getMine failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<AppSettings> upsert(AppSettings settings) async {
    try {
      final uid = await _requireUserId();
      final raw = await _remote.upsert(SettingsMapper.toUpsertJson(uid: uid, settings: settings));
      final dto = SettingsDto.fromJson(raw.first);
      return SettingsMapper.toDomain(dto);
    } catch (e, st) {
      AppLogger.repository('SettingsRepository.upsert failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  @override
  Future<AppSettings> patch({
    bool? reminderOn,
    bool? budgetAlertOn,
    bool? tipsOn,
  }) async {
    try {
      final uid = await _requireUserId();
      final body = SettingsMapper.toPatchJson(
        reminderOn: reminderOn,
        budgetAlertOn: budgetAlertOn,
        tipsOn: tipsOn,
      );
      final raw = await _remote.patch(uid: uid, body: body);
      final dto = SettingsDto.fromJson(raw.first);
      return SettingsMapper.toDomain(dto);
    } catch (e, st) {
      AppLogger.repository('SettingsRepository.patch failed', error: e, stackTrace: st);
      throw ExceptionMapper.map(e);
    }
  }

  Future<String> _requireUserId() async {
    final uid = await _userIdLocal.getUserId();
    if (uid == null || uid.trim().isEmpty) {
      throw const FormatException('User ID is missing. Please login again.');
    }
    return uid.trim();
  }
}
