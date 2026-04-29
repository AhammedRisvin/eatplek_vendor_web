import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/dashboard/model/all_orders_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../order_details/view/order_detail_dialog.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../../widgets/common_table.dart';
import '../view_model/dashboard_provider.dart';
import 'widget/stats_row.dart';
import 'widget/top_bar.dart';

const _kOrderColumns = [
  AppTableColumn(label: 'Order ID', flex: 2),
  AppTableColumn(label: 'Customer', flex: 3),
  AppTableColumn(label: 'Order Type', flex: 2),
  AppTableColumn(label: 'Amount', flex: 2),
  AppTableColumn(label: 'Status', flex: 3),
  AppTableColumn(label: 'Action', flex: 2),
];

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  static const int _kTabIndex = 0;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.watch<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final p = context.read<DashboardProvider>();
        p.getDashboardStats(context: context);
        p.getRevenueData(context: context);
        p.getOrders(context: context, page: 1);
        p.startCountdown();
        p.startAutoRefresh(context); // ← ADD THIS
      });
    }
    // Stop polling when user switches away from dashboard tab
    if (nav.selectedIndex != _kTabIndex) {
      context.read<DashboardProvider>().stopAutoRefresh(); // ← ADD THIS
    }
  }

  @override
  void dispose() {
    context.read<DashboardProvider>().stopAutoRefresh(); // ← ADD THIS
    super.dispose();
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
                Consumer<DashboardProvider>(
                  builder: (context, p, _) {
                    final stats = p.statsModel?.data;
                    return StatsRow(
                      isLoading: p.isLoadingStats,
                      stats: [
                        (
                          'Total Orders Today',
                          stats?.totalOrdersToday.toString() ?? '--',
                        ),
                        (
                          'Revenue Today',
                          stats != null ? 'Rs. ${stats.revenueToday}' : '--',
                        ),
                        (
                          'Pending Orders',
                          stats?.pendingOrders.toString() ?? '--',
                        ),
                        (
                          'Completed Orders',
                          stats?.completedOrders.toString() ?? '--',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                _latestOrdersHeader(),
                const SizedBox(height: 16),
                Consumer<DashboardProvider>(
                  builder: (context, p, _) {
                    final orders = p.ordersModel?.data.orders ?? [];
                    final pagination = p.ordersModel?.data.pagination;
                    return AppDataTable(
                      columns: _kOrderColumns,
                      isLoading: p.isLoadingOrders,
                      isEmpty: orders.isEmpty,
                      emptyMessage: 'No orders found',
                      rows: orders.map((o) => _OrderRow(order: o)).toList(),
                      pagination: pagination,
                      onPageChange: (page) => context
                          .read<DashboardProvider>()
                          .getOrders(context: context, page: page),
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

  Widget _latestOrdersHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Latest Orders',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'These are your latest orders. Please review and accept, reject, or update them within 3 minutes.',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: AppColor.black60,
              ),
            ),
          ],
        ),
        const Spacer(),
        // Countdown timer
        Consumer<DashboardProvider>(
          builder: (ctx, p, _) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                _CountdownBox(value: p.countdownDisplay.split('   ')[0]),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    ':',
                    style: GoogleFonts.urbanist(fontWeight: FontWeight.w700),
                  ),
                ),
                _CountdownBox(value: p.countdownDisplay.split('   ')[1]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String value;
  const _CountdownBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.darkBlue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        value,
        style: GoogleFonts.urbanist(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final OrderItem order;
  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(flex: 2, child: _cell('#${order.orderId}')),
          Expanded(flex: 3, child: _cell(order.customer)),
          Expanded(flex: 2, child: _cell(order.orderType)),
          Expanded(
            flex: 2,
            child: _OrderIdCell(
              orderId: '#${order.orderId}',
              status: order.status,
            ),
          ),
          Expanded(flex: 3, child: _StatusBadge(status: order.status)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => OrderDetailDialog(bookingId: order.bookingId),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.darkBlue),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'View Order',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.darkBlue,
                  ),
                ),
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

class _OrderIdCell extends StatefulWidget {
  final String orderId;
  final String status;
  const _OrderIdCell({required this.orderId, required this.status});

  @override
  State<_OrderIdCell> createState() => _OrderIdCellState();
}

class _OrderIdCellState extends State<_OrderIdCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  bool get _isUntracked {
    final s = widget.status.toLowerCase();
    return s == 'new' || s == 'pending';
  }

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.orderId,
          style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
        ),
        if (_isUntracked) ...[
          const SizedBox(width: 6),
          FadeTransition(
            opacity: _pulse,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (status.toLowerCase()) {
      case 'new':
        color = const Color(0xFF1D4ED8);
        break;
      case 'preparing':
        color = const Color(0xFFC2410C);
        break;
      case 'mark ready':
      case 'ready for pickup':
      case 'accepted':
      case 'completed':
        color = const Color(0xFF15803D);
        break;
      case 'update requested':
        color = const Color(0xFFB45309);
        break;
      case 'rejected':
        color = AppColor.red;
        break;
      default:
        color = AppColor.black60;
    }
    return Text(
      status,
      style: GoogleFonts.urbanist(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
