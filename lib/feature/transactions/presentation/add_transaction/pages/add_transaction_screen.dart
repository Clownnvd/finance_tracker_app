import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/router/app_router.dart';
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

  @override
  void initState() {
    super.initState();
    _amountCtrl = TextEditingController();
    _noteCtrl = TextEditingController();

    _amountCtrl.addListener(() {
      final raw = _amountCtrl.text.trim().replaceAll(',', '');
      final v = double.tryParse(raw) ?? 0;
      context.read<AddTransactionCubit>().setAmount(v);
    });

    _noteCtrl.addListener(() {
      context.read<AddTransactionCubit>().setNote(_noteCtrl.text);
    });
  }

  @override
  void dispose() {
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
    if (picked != null && context.mounted) {
      context.read<AddTransactionCubit>().setDate(picked);
    }
  }

  Future<void> _pickCategory(
    BuildContext context,
    CategoryEntity? current,
  ) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add transaction')),
      body: SafeArea(
        child: BlocConsumer<AddTransactionCubit, AddTransactionState>(
          listener: (context, state) async {
            final msg = state.error;
            if (msg != null && msg.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(msg)));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AmountField(controller: _amountCtrl),
                      const SizedBox(height: 16),

                      CategoryField(
                        value: state.category,
                        onTap: () => _pickCategory(context, state.category),
                      ),
                      const SizedBox(height: 16),

                      DateField(
                        value: state.date,
                        onTap: () => _pickDate(context, state.date),
                      ),
                      const SizedBox(height: 16),

                      NoteField(controller: _noteCtrl),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: state.canSubmit
                            ? () async {
                                final ok = await context
                                    .read<AddTransactionCubit>()
                                    .submit();
                                if (!context.mounted) return;

                                if (ok) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        content: Text('Transaction added'),
                                      ),
                                    );
                                  Navigator.pop(context, true);
                                }
                              }
                            : null,
                        child: const Text('Save'),
                      ),
                    ],
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
