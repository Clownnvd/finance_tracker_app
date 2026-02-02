import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool reminderOn,
    required bool budgetAlertOn,
    required bool tipsOn,
  }) = _AppSettings;

  const AppSettings._();

  /// When user has no row in DB yet.
  static const AppSettings empty = AppSettings(
    reminderOn: false,
    budgetAlertOn: false,
    tipsOn: false,
  );

  /// Alias for [empty] - default settings when user has no saved preferences.
  static const AppSettings defaults = empty;

  bool get anyOn => reminderOn || budgetAlertOn || tipsOn;
}
