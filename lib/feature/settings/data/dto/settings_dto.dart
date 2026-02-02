import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_dto.freezed.dart';
part 'settings_dto.g.dart';

@freezed
abstract class SettingsDto with _$SettingsDto {
  const factory SettingsDto({
    required String user_id,
    @Default(false) bool reminder_on,
    @Default(false) bool budget_alert_on,
    @Default(false) bool tips_on,
  }) = _SettingsDto;

  factory SettingsDto.fromJson(Map<String, dynamic> json) =>
      _$SettingsDtoFromJson(json);
}
