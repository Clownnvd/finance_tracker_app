// lib/feature/transactions/presentation/transaction_history/widgets/history_list.dart

import 'package:flutter/material.dart';
import 'package:finance_tracker_app/core/theme/app_theme.dart';
import 'package:finance_tracker_app/core/utils/category_icon_mapper.dart';

import '../../../feature/transactions/presentation/transaction_history/helpers/history_grouping.dart';
import '../../../feature/transactions/domain/entities/transaction_entity.dart';

import 'history_item_tile.dart';
import 'history_section_header.dart';

class HistoryList extends StatefulWidget {
  final List<HistorySection> sections;

  final Map<int, String> categoryNameById;
  final Map<int, String> categoryIconById;

  final bool isLoading;
  final bool isLoadingMore;
  final String? error;

  final String? currencySymbol;

  final VoidCallback? onLoadMore;
  final void Function(TransactionEntity tx)? onItemTap;

  const HistoryList({
    super.key,
    required this.sections,
    required this.categoryNameById,
    required this.categoryIconById,
    required this.isLoading,
    required this.isLoadingMore,
    this.error,
    this.currencySymbol,
    this.onLoadMore,
    this.onItemTap,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final ScrollController _controller = ScrollController();
  static const double _loadMoreThresholdPx = 320;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.onLoadMore == null) return;
    if (widget.isLoading || widget.isLoadingMore) return;

    final pos = _controller.position;
    if (!pos.hasPixels || !pos.hasContentDimensions) return;

    final remaining = pos.maxScrollExtent - pos.pixels;
    if (remaining <= _loadMoreThresholdPx) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.error != null && widget.error!.trim().isNotEmpty) {
      return _ErrorView(message: widget.error!.trim());
    }

    if (widget.sections.isEmpty) {
      return const _EmptyView();
    }

    final rows = <_Row>[];
    for (final section in widget.sections) {
      rows.add(_Row.header(section));
      for (final tx in section.items) {
        rows.add(_Row.item(tx));
      }
    }
    if (widget.isLoadingMore) {
      rows.add(const _Row.loadingMore());
    }

    return ListView.separated(
      controller: _controller,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      itemCount: rows.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final row = rows[index];

        if (row.kind == _RowKind.header) {
          final s = row.section!;
          return HistorySectionHeader(
            title: s.title,
            hideTotals: true,
            currencySymbol: widget.currencySymbol,
          );
        }

        if (row.kind == _RowKind.loadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final tx = row.tx!;
        final categoryName = widget.categoryNameById[tx.categoryId] ?? 'Unknown';
        final iconKey = widget.categoryIconById[tx.categoryId] ?? '';
        final iconData = CategoryIconMapper.fromString(iconKey);

        return HistoryItemTile(
          tx: tx,
          categoryName: categoryName,
          icon: iconData,
          currencySymbol: widget.currencySymbol,
          onTap: widget.onItemTap == null ? null : () => widget.onItemTap!(tx),
        );
      },
    );
  }
}

enum _RowKind { header, item, loadingMore }

class _Row {
  final _RowKind kind;
  final HistorySection? section;
  final TransactionEntity? tx;

  const _Row._(this.kind, {this.section, this.tx});

  factory _Row.header(HistorySection s) => _Row._(_RowKind.header, section: s);
  factory _Row.item(TransactionEntity tx) => _Row._(_RowKind.item, tx: tx);
  const factory _Row.loadingMore() = _LoadingMoreRow;
}

class _LoadingMoreRow extends _Row {
  const _LoadingMoreRow() : super._(_RowKind.loadingMore);
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_rounded, size: 44, color: AppColors.neutral400),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'No transactions yet',
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Add your first income/expense to see it here.',
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 44, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Something went wrong',
              style: AppTextStyles.title.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
