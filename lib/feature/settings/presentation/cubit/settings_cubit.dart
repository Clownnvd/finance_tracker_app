import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finance_tracker_app/core/error/exception_mapper.dart';
import 'package:finance_tracker_app/core/utils/app_logger.dart';

import 'package:finance_tracker_app/feature/settings/domain/entities/settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_my_settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/upsert_settings.dart';
import 'package:finance_tracker_app/feature/settings/domain/usecases/get_all_budgets.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetMySettings _getMySettings;
  final UpsertSettings _upsertSettings;
  final GetAllBudgets _getAllBudgets;

  SettingsCubit({
    required GetMySettings getMySettings,
    required UpsertSettings upsertSettings,
    required GetAllBudgets getAllBudgets,
  })  : _getMySettings = getMySettings,
        _upsertSettings = upsertSettings,
        _getAllBudgets = getAllBudgets,
        super(SettingsState.initial());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final settings = await _getMySettings();
      final budgets = await _getAllBudgets();

      AppLogger.repository('SettingsCubit.load: budgets.length=${budgets.length}, hasAnyBudget=${budgets.isNotEmpty}');

      emit(state.copyWith(
        isLoading: false,
        settings: settings,
        hasAnyBudget: budgets.isNotEmpty,
        shouldPromptSetBudget: false,
      ));
    } catch (e, st) {
      AppLogger.repository(
        'SettingsCubit.load failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }

  void consumePrompt() {
    if (state.shouldPromptSetBudget) {
      emit(state.copyWith(shouldPromptSetBudget: false));
    }
  }

  Future<void> toggleReminder(bool v) =>
      _save(state.settings.copyWith(reminderOn: v));

  Future<void> toggleTips(bool v) =>
      _save(state.settings.copyWith(tipsOn: v));

  Future<void> toggleBudgetLimit(bool v) async {
    AppLogger.repository('toggleBudgetLimit: v=$v, hasAnyBudget=${state.hasAnyBudget}');

    // bật budget limit nhưng chưa có budgets => show dialog (UI nghe state.shouldPromptSetBudget)
    if (v && !state.hasAnyBudget) {
      AppLogger.repository('toggleBudgetLimit: showing prompt dialog');
      emit(state.copyWith(
        settings: state.settings.copyWith(budgetAlertOn: false),
        shouldPromptSetBudget: true,
      ));
      return;
    }
    await _save(state.settings.copyWith(budgetAlertOn: v));
  }

  Future<void> _save(AppSettings next) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final saved = await _upsertSettings(next);
      emit(state.copyWith(isLoading: false, settings: saved));
    } catch (e, st) {
      AppLogger.repository(
        'SettingsCubit._save failed',
        error: e,
        stackTrace: st,
      );
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: ExceptionMapper.map(e).toString(),
        ),
      );
    }
  }
}
