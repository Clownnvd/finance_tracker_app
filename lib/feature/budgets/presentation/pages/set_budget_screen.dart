import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';

import '../cubit/budgets_cubit.dart';
import '../cubit/budgets_state.dart';
import '../widgets/budget_amount_display.dart';
import '../widgets/budget_category_picker.dart';
import '../widgets/budget_month_picker.dart';
import '../widgets/budget_amount_input.dart';

class SetBudgetScreen extends StatefulWidget {
  const SetBudgetScreen({super.key});

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  late final TextEditingController _amountCtrl;

  CategoryEntity? _selectedCategory;
  int _selectedMonth = DateTime.now().month;
  double _amount = 0;

  final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController();
    _amountCtrl.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    final raw = _amountCtrl.text.trim().replaceAll(',', '').replaceAll('\$', '');
    final v = double.tryParse(raw) ?? 0;
    if (v != _amount) {
      setState(() => _amount = v);
    }
  }

  @override
  void dispose() {
    _amountCtrl.removeListener(_onAmountChanged);
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    final picked = await Navigator.pushNamed(
      context,
      AppRoutes.selectCategory,
      arguments: _selectedCategory,
    );

    if (!mounted) return;

    if (picked is CategoryEntity) {
      setState(() => _selectedCategory = picked);
    }
  }

  void _onMonthChanged(int month) {
    setState(() => _selectedMonth = month);
  }

  Future<void> _save() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be greater than 0.')),
      );
      return;
    }

    await context.read<BudgetsCubit>().createOrUpdate(
          categoryId: _selectedCategory!.id,
          amount: _amount,
          month: _selectedMonth,
        );
  }

  IconData _iconFor(CategoryEntity? c) {
    final key = (c?.icon ?? '').trim().toLowerCase();
    final name = (c?.name ?? '').trim().toLowerCase();

    if (key == 'house' || key == 'housing' || key == 'home' || name.contains('hous')) {
      return Icons.home_rounded;
    }
    if (key == 'food' || name.contains('food')) return Icons.restaurant_rounded;
    if (key.contains('shop') || name.contains('shop')) return Icons.shopping_bag_rounded;
    if (key == 'salary' || name.contains('salary')) return Icons.payments_rounded;
    if (key == 'freelance' || name.contains('free')) return Icons.work_rounded;
    if (key.contains('invest') || name.contains('invest')) return Icons.trending_up_rounded;
    if (key.contains('transport') || name.contains('transport')) return Icons.directions_car_rounded;
    if (key.contains('health') || name.contains('health')) return Icons.medical_services_rounded;
    if (key.contains('entertain') || name.contains('entertain')) return Icons.movie_rounded;
    if (key.contains('util') || name.contains('util')) return Icons.power_rounded;

    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = math.min(MediaQuery.of(context).size.width, 420.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Set Budget'), centerTitle: true),
      body: BlocConsumer<BudgetsCubit, BudgetsState>(
        listenWhen: (prev, next) =>
            prev.isSaving != next.isSaving ||
            prev.errorMessage != next.errorMessage ||
            prev.lastCreatedOrUpdated != next.lastCreatedOrUpdated,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.lastCreatedOrUpdated != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('Budget saved successfully!')));

            context.read<BudgetsCubit>().clearLastSaved();

            final nav = Navigator.of(context);
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) nav.pop(true);
            });
          }
        },
        builder: (context, state) {
          final displayAmount = _amount > 0 ? _currencyFormat.format(_amount) : '\$0';

          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: maxWidth,
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      children: [
                        BudgetAmountDisplay(amountText: displayAmount),
                        const SizedBox(height: AppSpacing.lg),

                        BudgetCategoryPicker(
                          title: 'Budget Category',
                          valueText: _selectedCategory?.name ?? 'Select category',
                          icon: _iconFor(_selectedCategory),
                          onTap: _pickCategory,
                        ),
                        const SizedBox(height: AppSpacing.md),

                        BudgetAmountInput(
                          title: 'Monthly Budget',
                          hintText: 'Enter amount',
                          controller: _amountCtrl,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        BudgetMonthPicker(
                          value: _selectedMonth,
                          onChanged: _onMonthChanged,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            minimumSize: const Size.fromHeight(48),
                          ),
                          onPressed: state.isSaving ? null : _save,
                          child: state.isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.white,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ),

                if (state.isSaving)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(color: Colors.black.withValues(alpha: 0.05)),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
