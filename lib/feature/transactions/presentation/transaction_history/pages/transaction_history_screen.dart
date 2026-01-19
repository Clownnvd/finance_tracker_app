// lib/feature/transactions/presentation/history/pages/transaction_history_screen.dart
// NOTE: Update the import path if your DI file differs.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finance_tracker_app/core/constants/strings.dart';
import 'package:finance_tracker_app/core/di/di.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/usecases/get_categories.dart';

import '../cubit/transaction_history_cubit.dart';
import '../cubit/transaction_history_state.dart';
import '../helpers/history_grouping.dart';
import '../../../../../shared/widgets/transaction_history_widgets/history_list.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({
    super.key,
    this.currencySymbol,
    this.initialFrom,
    this.initialTo,
  });

  final String? currencySymbol;
  final DateTime? initialFrom;
  final DateTime? initialTo;

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime? _from;
  DateTime? _to;

  Map<int, String> _categoryNameById = const {};
  Map<int, String> _categoryIconById = const {};

  bool _isLoadingCategories = false;
  String? _categoryError;

  @override
  void initState() {
    super.initState();

    _from = widget.initialFrom;
    _to = widget.initialTo;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCategories();
      if (!mounted) return;

      context.read<TransactionHistoryCubit>().load(from: _from, to: _to);
    });
  }

  Future<void> _loadCategories() async {
    if (_isLoadingCategories) return;

    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final getCategories = getIt<GetCategories>();
      final cats = await getCategories.call();

      final name = <int, String>{};
      final icon = <int, String>{};

      for (final c in cats) {
        name[c.id] = c.name;
        icon[c.id] = c.icon;
      }

      if (!mounted) return;
      setState(() {
        _categoryNameById = Map.unmodifiable(name);
        _categoryIconById = Map.unmodifiable(icon);
        _isLoadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingCategories = false;
        _categoryError = e.toString();
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadCategories();
    if (!mounted) return;
    await context.read<TransactionHistoryCubit>().refresh(from: _from, to: _to);
  }

  void _onLoadMore() {
    context.read<TransactionHistoryCubit>().loadMore(from: _from, to: _to);
  }

  @override
  Widget build(BuildContext context) {
    final categoryReady = _categoryNameById.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.white,

      // Remove default AppBar to match screenshot.
      body: SafeArea(
        child: BlocBuilder<TransactionHistoryCubit, TransactionHistoryState>(
          builder: (context, state) {
            final sections = HistoryGrouping.groupByDay(state.items);

            final bannerText = _categoryError?.trim();
            final topBanner = (bannerText != null && bannerText.isNotEmpty)
                ? _Banner(text: '${AppStrings.categoryLoadFailedPrefix}$bannerText')
                : null;

            final isInitialBlockingLoading =
                state.isLoading ||
                (_isLoadingCategories && !categoryReady && state.items.isEmpty);

            return Column(
              children: [
                if (topBanner != null) topBanner,

                // Title in body (big, blue) like screenshot.
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.transactionHistoryTitle,
                      style: AppTextStyles.headline.copyWith(
                        fontSize: 28, // closer to screenshot
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: HistoryList(
                      sections: sections,
                      categoryNameById: _categoryNameById,
                      categoryIconById: _categoryIconById,
                      isLoading: isInitialBlockingLoading,
                      isLoadingMore: state.isLoadingMore,
                      error: state.error,
                      currencySymbol: widget.currencySymbol,
                      onLoadMore: state.hasMore ? _onLoadMore : null,
                      onItemTap: (TransactionEntity tx) {
                        // TODO: Open details/edit screen.
                      },
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

class _Banner extends StatelessWidget {
  final String text;
  const _Banner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      color: AppColors.error.withOpacity(0.08),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
