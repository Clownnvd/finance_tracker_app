import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';

import '../dto/settings_dto.dart';

class SettingsMapper {
  const SettingsMapper._();

  static AppSettings toDomain(SettingsDto dto) {
    return AppSettings(
      reminderOn: dto.reminder_on,
      budgetAlertOn: dto.budget_alert_on,
      tipsOn: dto.tips_on,
    );
  }

  static Map<String, dynamic> toUpsertJson({
    required String uid,
    required AppSettings settings,
  }) {
    return <String, dynamic>{
      'user_id': uid,
      'reminder_on': settings.reminderOn,
      'budget_alert_on': settings.budgetAlertOn,
      'tips_on': settings.tipsOn,
    };
  }

  static Map<String, dynamic> toPatchJson({
    bool? reminderOn,
    bool? budgetAlertOn,
    bool? tipsOn,
  }) {
    final m = <String, dynamic>{};
    if (reminderOn != null) m['reminder_on'] = reminderOn;
    if (budgetAlertOn != null) m['budget_alert_on'] = budgetAlertOn;
    if (tipsOn != null) m['tips_on'] = tipsOn;
    return m;
  }
}
