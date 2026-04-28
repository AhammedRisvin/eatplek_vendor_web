import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/dashboard/model/all_orders_model.dart';

/// A column definition for [AppDataTable].
///
/// [label]  — the header text shown at the top
/// [flex]   — flex value for this column (same as Expanded flex)
class AppTableColumn {
  final String label;
  final int flex;

  const AppTableColumn({required this.label, required this.flex});
}

/// A fully generic, reusable data table card.
///
/// Handles:
///  - Rounded card container with border
///  - Styled header row built from [columns]
///  - Loading spinner while [isLoading] is true
///  - Empty state message when [isEmpty] is true
///  - Arbitrary row widgets via [rows]
///  - Optional pagination via [pagination] + [onPageChange]
///
/// Example — Orders table:
/// ```dart
/// AppDataTable(
///   columns: const [
///     AppTableColumn(label: 'Order ID', flex: 2),
///     AppTableColumn(label: 'Customer', flex: 3),
///     AppTableColumn(label: 'Amount',   flex: 2),
///     AppTableColumn(label: 'Status',   flex: 3),
///     AppTableColumn(label: 'Action',   flex: 2),
///   ],
///   isLoading: p.isLoadingOrders,
///   isEmpty: orders.isEmpty,
///   emptyMessage: 'No orders found',
///   rows: orders.map((o) => _OrderRow(order: o)).toList(),
///   pagination: pagination,
///   onPageChange: (page) =>
///       context.read<DashboardProvider>().getOrders(context: context, page: page),
/// )
/// ```
class AppDataTable extends StatelessWidget {
  /// Column definitions — drives the header row.
  final List<AppTableColumn> columns;

  /// Show a centered [CircularProgressIndicator] instead of rows.
  final bool isLoading;

  /// Show [emptyMessage] instead of rows (only checked when not loading).
  final bool isEmpty;

  /// Text shown when [isEmpty] is true.
  final String emptyMessage;

  /// The row widgets to render when data is available.
  final List<Widget> rows;

  /// When provided, renders an [AppPaginationBar] at the bottom.
  final Pagination? pagination;

  /// Required when [pagination] is non-null.
  final void Function(int page)? onPageChange;

  const AppDataTable({
    super.key,
    required this.columns,
    required this.isLoading,
    required this.isEmpty,
    required this.rows,
    this.emptyMessage = 'No data found',
    this.pagination,
    this.onPageChange,
  }) : assert(
         pagination == null || onPageChange != null,
         'onPageChange must be provided when pagination is set',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _TableHeaderRow(columns: columns),

          // ── Body ────────────────────────────────────────────────────────
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(60),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (isEmpty)
            Padding(
              padding: const EdgeInsets.all(60),
              child: Center(
                child: Text(
                  emptyMessage,
                  style: GoogleFonts.urbanist(
                    color: AppColor.black60,
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ...rows,

          // ── Pagination ───────────────────────────────────────────────────
          if (pagination != null && onPageChange != null)
            AppPaginationBar(
              pagination: pagination!,
              onPageChange: onPageChange!,
            ),
        ],
      ),
    );
  }
}

/// A single column header cell for any app table.
/// Usage: AppTableHeaderCell('Order ID', flex: 2)
class AppTableHeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const AppTableHeaderCell(this.text, {super.key, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.darkBlue,
        ),
      ),
    );
  }
}

// ── Internal header row ───────────────────────────────────────────────────────
class _TableHeaderRow extends StatelessWidget {
  final List<AppTableColumn> columns;

  const _TableHeaderRow({required this.columns});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.darkBlue.withOpacity(.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: columns
            .map((col) => AppTableHeaderCell(col.label, flex: col.flex))
            .toList(),
      ),
    );
  }
}

/// A fully self-contained pagination bar.
///
/// Pass the shared [Pagination] model and an [onPageChange] callback.
/// The callback receives the new page number — no provider dependency here.
///
/// Example:
/// ```dart
/// AppPaginationBar(
///   pagination: pagination,
///   onPageChange: (page) => context.read<MyProvider>().fetchData(page: page),
/// )
/// ```
class AppPaginationBar extends StatelessWidget {
  final Pagination pagination;
  final void Function(int page) onPageChange;

  const AppPaginationBar({
    super.key,
    required this.pagination,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    final page = pagination.currentPage ?? 1;
    final limit = pagination.limit ?? 8;
    final total = pagination.totalCount ?? 0;
    final totalPages = pagination.totalPages ?? 1;

    // Guard: start should not exceed total
    final start = total == 0 ? 0 : (page - 1) * limit + 1;
    final end = (page * limit).clamp(0, total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Text(
            '$start – $end of $total items',
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black60),
          ),
          const Spacer(),
          AppPageButton(
            label: 'Previous',
            enabled: page > 1,
            onTap: () => onPageChange(page - 1),
          ),
          const SizedBox(width: 8),
          AppPageButton(
            label: 'Next',
            enabled: page < totalPages,
            onTap: () => onPageChange(page + 1),
          ),
        ],
      ),
    );
  }
}

/// Previous / Next button used inside AppPaginationBar.
class AppPageButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const AppPageButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F6FA),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: enabled ? AppColor.black : AppColor.black40,
          ),
        ),
      ),
    );
  }
}
