import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';

import '../repositories/settings_repository.dart';

class GetMySettings {
  final SettingsRepository _repo;
  const GetMySettings(this._repo);

  Future<AppSettings> call() async {
    final s = await _repo.getMine();
    return s ?? AppSettings.defaults;
  }
}
