// payments_earnings_view.dart  (refactored)
//
// EarningsPagination → converted to the shared Pagination model inline.

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/earnings/model/earnings_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dashboard/model/all_orders_model.dart';
import '../../dashboard/view/widget/stats_row.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../../widgets/common_table.dart';
import '../view_model/revenue_notify_listner.dart';

const _kEarningsColumns = [
  AppTableColumn(label: 'Order ID', flex: 2),
  AppTableColumn(label: 'Date', flex: 3),
  AppTableColumn(label: 'Order Type', flex: 3),
  AppTableColumn(label: 'Amount', flex: 2),
  AppTableColumn(label: 'Status', flex: 2),
];

class PaymentsEarningsView extends StatefulWidget {
  const PaymentsEarningsView({super.key});

  @override
  State<PaymentsEarningsView> createState() => _PaymentsEarningsViewState();
}

class _PaymentsEarningsViewState extends State<PaymentsEarningsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<RevenueNotifylistner>();
      p.getRevenueDataFn(context: context);
      p.getAllEarningFn(context: context, page: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page title
                Row(
                  children: [
                    Text(
                      'Payments & Earnings',
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '- Track your sales, earnings, and payouts at a glance',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black60,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Stats
                Consumer<RevenueNotifylistner>(
                  builder: (context, p, _) {
                    final stats = p.earningStatsModel?.data;
                    return StatsRow(
                      isLoading: p.isLoadingEarningStats,
                      stats: [
                        (
                          'Total Earnings',
                          stats != null
                              ? 'Rs.${stats.totalEarnings ?? 0}'
                              : '--',
                        ),
                        (
                          'Pending Payout',
                          stats != null
                              ? 'Rs. ${stats.pendingPayout ?? 0}'
                              : '--',
                        ),
                        (
                          'Total Orders',
                          stats != null
                              ? 'Rs. ${stats.pendingPayout ?? 0}'
                              : '--',
                        ),
                        (
                          'Pending Orders',
                          stats?.pendingOrders?.toString() ?? '--',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                Text(
                  'Payments & Earnings',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Refactored table ─────────────────────────────────────
                Consumer<RevenueNotifylistner>(
                  builder: (context, p, _) {
                    final orders = p.earningsModel?.data?.orders ?? [];
                    final ep = p.earningsModel?.data?.pagination;

                    // Convert EarningsPagination → shared Pagination model
                    final pagination = ep == null
                        ? null
                        : Pagination(
                            currentPage: ep.page,
                            totalPages: ep.totalPages,
                            totalCount: ep.total,
                            limit: ep.limit,
                          );

                    return AppDataTable(
                      columns: _kEarningsColumns,
                      isLoading: p.isLoading,
                      isEmpty: orders.isEmpty,
                      emptyMessage: 'No earnings found',
                      rows: orders.map((o) => _EarningRow(order: o)).toList(),
                      pagination: pagination,
                      onPageChange: (page) => context
                          .read<RevenueNotifylistner>()
                          .getAllEarningFn(context: context, page: page),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Earning row ───────────────────────────────────────────────────────────────
class _EarningRow extends StatelessWidget {
  final Order order;
  const _EarningRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt != null
        ? DateFormat('dd-MM-yyyy').format(order.createdAt!)
        : '--';
    final isCompleted = (order.orderStatus ?? '').toLowerCase() == 'completed';

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 2, child: _cell('#${order.orderId ?? ''}')),
          Expanded(flex: 3, child: _cell(date)),
          Expanded(flex: 3, child: _cell(order.serviceType ?? '')),
          Expanded(flex: 2, child: _cell('₹${order.amount ?? 0}')),
          Expanded(
            flex: 2,
            child: Text(
              order.orderStatus ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isCompleted ? const Color(0xFF16A34A) : AppColor.black60,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String text) => Text(
    text,
    style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
  );
}
