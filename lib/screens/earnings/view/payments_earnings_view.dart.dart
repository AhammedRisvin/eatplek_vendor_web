import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/earnings/model/earnings_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/stats_row.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../view_model/revenue_notify_listner.dart';

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
                _EarningsTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Earnings table ───────────────────────────────────────────────────────────
class _EarningsTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RevenueNotifylistner>(
      builder: (context, p, _) {
        final orders = p.earningsModel?.data?.orders ?? [];
        final pagination = p.earningsModel?.data?.pagination;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: AppColor.darkBlue.withOpacity(.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: const Row(
                  children: [
                    _HeaderCell('Order ID', flex: 2),
                    _HeaderCell('Date', flex: 3),
                    _HeaderCell('Order Type', flex: 3),
                    _HeaderCell('Amount', flex: 2),
                    _HeaderCell('Status', flex: 2),
                  ],
                ),
              ),

              // Body
              if (p.isLoading)
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Center(
                    child: Text(
                      'No earnings found',
                      style: GoogleFonts.urbanist(
                        color: AppColor.black60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                ...orders.map((order) => _EarningRow(order: order)),

              // Pagination
              if (pagination != null) _PaginationBar(pagination: pagination),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {required this.flex});

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

class _EarningRow extends StatelessWidget {
  final Order order;
  const _EarningRow({required this.order});

  @override
  Widget build(BuildContext context) {
    final date = order.createdAt != null
        ? DateFormat('dd-MM-yyyy').format(order.createdAt!)
        : '--';

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '#${order.orderId ?? ''}',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              date,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              order.serviceType ?? '',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${order.amount ?? 0}',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              order.orderStatus ?? '',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: (order.orderStatus ?? '').toLowerCase() == 'completed'
                    ? const Color(0xFF16A34A)
                    : AppColor.black60,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pagination ───────────────────────────────────────────────────────────────
class _PaginationBar extends StatelessWidget {
  final EarningsPagination pagination;
  const _PaginationBar({required this.pagination});

  @override
  Widget build(BuildContext context) {
    final start = ((pagination.page ?? 1) - 1) * (pagination.limit ?? 8) + 1;
    final end = ((pagination.page ?? 1) * (pagination.limit ?? 8)).clamp(
      0,
      pagination.total ?? 0,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Text(
            '$start – $end of ${pagination.total ?? 0} items',
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black60),
          ),
          const Spacer(),
          _PageButton(
            label: 'Previous',
            enabled: (pagination.page ?? 1) > 1,
            onTap: () => context.read<RevenueNotifylistner>().getAllEarningFn(
              context: context,
              page: (pagination.page ?? 1) - 1,
            ),
          ),
          const SizedBox(width: 8),
          _PageButton(
            label: 'Next',
            enabled: (pagination.page ?? 1) < (pagination.totalPages ?? 1),
            onTap: () => context.read<RevenueNotifylistner>().getAllEarningFn(
              context: context,
              page: (pagination.page ?? 1) + 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  const _PageButton({
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
          borderRadius: BorderRadius.circular(6),
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
