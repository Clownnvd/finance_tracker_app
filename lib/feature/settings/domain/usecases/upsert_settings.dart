import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';

import '../repositories/settings_repository.dart';

class UpsertSettings {
  final SettingsRepository _repo;
  const UpsertSettings(this._repo);

  Future<AppSettings> call(AppSettings settings) => _repo.upsert(settings);
}
