// lib/feature/transactions/presentation/select_category/pages/select_category_screen.dart
//
// Functionality unchanged.
// UI matches screenshot:
// - No AppBar, centered title "Select category"
// - White background
// - Tight, consistent padding and spacing
// - Uses CategorySection + CategoryItemTile styles above

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

import 'package:finance_tracker_app/feature/transactions/domain/entities/category_entity.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_cubit.dart';
import 'package:finance_tracker_app/feature/transactions/presentation/select_category/cubit/select_category_state.dart';

import '../../../../../shared/widgets/select_category_widgets/category_section.dart';

class SelectCategoryScreen extends StatefulWidget {
  final CategoryEntity? initialSelected;

  const SelectCategoryScreen({
    super.key,
    this.initialSelected,
  });

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<SelectCategoryCubit>().load());
  }

  Future<void> _refresh() async {
    await context.read<SelectCategoryCubit>().load(force: true);
  }

  void _selectAndClose(CategoryEntity c) {
    // Keep logic unchanged: select in cubit, then return result.
    context.read<SelectCategoryCubit>().select(c);
    Navigator.pop(context, c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<SelectCategoryCubit, SelectCategoryState>(
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
            final isInitialLoading =
                state.isLoading && state.expense.isEmpty && state.income.isEmpty;

            if (isInitialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                children: [
                  // Centered title like the screenshot (no AppBar).
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.selectCategoryTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  CategorySection(
                    title: AppStrings.expenseUpper,
                    items: state.expense,
                    selectedId: state.selectedCategoryId,
                    onTap: _selectAndClose,
                  ),

                  const SizedBox(height: 18),

                  CategorySection(
                    title: AppStrings.incomeUpper,
                    items: state.income,
                    selectedId: state.selectedCategoryId,
                    onTap: _selectAndClose,
                  ),

                  if (state.isLoading) ...[
                    const SizedBox(height: 14),
                    const LinearProgressIndicator(minHeight: 3),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
