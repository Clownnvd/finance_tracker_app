import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'settings_state.freezed.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const factory SettingsState({
    required bool isLoading,
    String? errorMessage,

    required AppSettings settings,

    required bool hasAnyBudget,
    required bool shouldPromptSetBudget,
  }) = _SettingsState;

  factory SettingsState.initial() => const SettingsState(
        isLoading: true,
        errorMessage: null,
        settings: AppSettings.defaults,
        hasAnyBudget: false,
        shouldPromptSetBudget: false,
      );
}
