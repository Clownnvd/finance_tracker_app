// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsDto _$SettingsDtoFromJson(Map<String, dynamic> json) => _SettingsDto(
  user_id: json['user_id'] as String,
  reminder_on: json['reminder_on'] as bool? ?? false,
  budget_alert_on: json['budget_alert_on'] as bool? ?? false,
  tips_on: json['tips_on'] as bool? ?? false,
);

Map<String, dynamic> _$SettingsDtoToJson(_SettingsDto instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'reminder_on': instance.reminder_on,
      'budget_alert_on': instance.budget_alert_on,
      'tips_on': instance.tips_on,
    };
