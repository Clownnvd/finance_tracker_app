// lib/feature/transactions/presentation/add_transaction/pages/add_transaction_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/constants/app_config.dart';
import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/add_transaction/cubit/add_transaction_state.dart';

import '../../../../../shared/widgets/add_transaction_widgets/amount_field.dart';
import '../../../../../shared/widgets/add_transaction_widgets/category_field.dart';
import '../../../../../shared/widgets/add_transaction_widgets/date_field.dart';
import '../../../../../shared/widgets/add_transaction_widgets/note_field.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;

  // Match screenshot orange (a bit stronger than AppColors.secondary).
  static const Color _accentOrange = Color(0xFFFF7A00);

  @override
  void initState() {
    super.initState();

    _amountCtrl = TextEditingController();
    _noteCtrl = TextEditingController();

    _amountCtrl.addListener(_onAmountChanged);
    _noteCtrl.addListener(_onNoteChanged);
  }

  void _onAmountChanged() {
    final raw = _amountCtrl.text.trim().replaceAll(',', '').replaceAll('\$', '');
    final v = double.tryParse(raw) ?? 0;
    context.read<AddTransactionCubit>().setAmount(v);
  }

  void _onNoteChanged() {
    context.read<AddTransactionCubit>().setNote(_noteCtrl.text);
  }

  @override
  void dispose() {
    _amountCtrl.removeListener(_onAmountChanged);
    _noteCtrl.removeListener(_onNoteChanged);
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, DateTime current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (!context.mounted) return;

    if (picked != null) {
      context.read<AddTransactionCubit>().setDate(picked);
    }
  }

  Future<void> _pickCategory(BuildContext context, CategoryEntity? current) async {
    final picked = await Navigator.pushNamed(
      context,
      AppRoutes.selectCategory,
      arguments: current,
    );

    if (!context.mounted) return;

    if (picked is CategoryEntity) {
      context.read<AddTransactionCubit>().setCategory(picked);
    }
  }

  Future<void> _submit() async {
    final ok = await context.read<AddTransactionCubit>().submit();
    if (!context.mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text(AppStrings.transactionAdded)));

      await Future<void>.delayed(
        const Duration(milliseconds: AppConfig.successSnackDelayMs),
      );

      if (!context.mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      body: SafeArea(
        child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
          listenWhen: (prev, next) => prev.error != next.error,
          listener: (context, state) {
            final msg = state.error;
            if (msg != null && msg.trim().isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(msg.trim())));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.lg,
                      ),
                      child: _CardShell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Add Transaction',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.headline.copyWith(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 18),

                            AmountField(controller: _amountCtrl),
                            const SizedBox(height: 14),

                            CategoryField(
                              value: state.category,
                              onTap: () => _pickCategory(context, state.category),
                            ),
                            const SizedBox(height: 14),

                            DateField(
                              value: state.date,
                              onTap: () => _pickDate(context, state.date),
                            ),
                            const SizedBox(height: 14),

                            NoteField(controller: _noteCtrl),
                            const SizedBox(height: 18),

                            SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (state.canSubmit && !state.isLoading)
                                    ? _submit
                                    : null,
                                style: ButtonStyle(
                                  elevation: const MaterialStatePropertyAll(0),
                                  backgroundColor: MaterialStateProperty.resolveWith(
                                    (states) {
                                      if (states.contains(MaterialState.disabled)) {
                                        return _accentOrange.withOpacity(0.45);
                                      }
                                      return _accentOrange; // ORANGE like screenshot
                                    },
                                  ),
                                  foregroundColor:
                                      const MaterialStatePropertyAll(AppColors.white),
                                  shape: const MaterialStatePropertyAll(
                                    RoundedRectangleBorder(borderRadius: AppRadius.medium),
                                  ),
                                  padding: const MaterialStatePropertyAll(
                                    EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                                child: Text(
                                  'Add',
                                  style: AppTextStyles.bodyLg.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                if (state.isLoading)
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Container(
                        color: Colors.black.withOpacity(0.06),
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 12),
                        child: const LinearProgressIndicator(minHeight: 3),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.level2,
      ),
      child: child,
    );
  }
}
