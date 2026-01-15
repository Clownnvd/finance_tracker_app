import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Future.microtask(() {
      context.read<SelectCategoryCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select category'),
      ),
      body: SafeArea(
        child: BlocConsumer<SelectCategoryCubit, SelectCategoryState>(
          listener: (context, state) {
            final msg = state.error;
            if (msg != null && msg.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(msg)));
            }
          },
          builder: (context, state) {
            if (state.isLoading && state.expense.isEmpty && state.income.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () => context.read<SelectCategoryCubit>().load(force: true),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  CategorySection(
                    title: 'EXPENSE',
                    items: state.expense,
                    selectedId: state.selectedCategoryId,
                    onTap: (c) {
                      context.read<SelectCategoryCubit>().select(c);
                      Navigator.pop(context, c);
                    },
                  ),
                  const SizedBox(height: 16),
                  CategorySection(
                    title: 'INCOME',
                    items: state.income,
                    selectedId: state.selectedCategoryId,
                    onTap: (c) {
                      context.read<SelectCategoryCubit>().select(c);
                      Navigator.pop(context, c);
                    },
                  ),
                  if (state.isLoading) ...[
                    const SizedBox(height: 16),
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
