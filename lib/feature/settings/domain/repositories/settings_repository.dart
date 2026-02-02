import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
abstract class SettingsRepository {
  Future<AppSettings?> getMine();
  Future<AppSettings> upsert(AppSettings settings);
  Future<AppSettings> patch({
    bool? reminderOn,
    bool? budgetAlertOn,
    bool? tipsOn,
  });
}
