import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/dashboard/model/all_orders_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_model/dashboard_provider.dart';
import 'widget/order_details_dialog.dart';
import 'widget/stats_row.dart';
import 'widget/top_bar.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<DashboardProvider>();
      p.getDashboardStats(context: context);
      p.getRevenueData(context: context);
      p.getOrders(context: context, page: 1);
      p.startCountdown();
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
                // _RevenueChart(),  // Header
                _latestOrdersHeader(),
                const SizedBox(height: 16),
                _LatestOrdersTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _latestOrdersHeader() {
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

// // ─── Revenue chart ────────────────────────────────────────────────────────────
// class _RevenueChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<DashboardProvider>(
//       builder: (context, p, _) {
//         // Fallback dummy points if API not wired yet
//         final points = p.revenuePoints.isNotEmpty
//             ? p.revenuePoints
//             : _dummyPoints();

//         final maxY = points.isEmpty
//             ? 30000.0
//             : points.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.3;

//         return Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: const Color(0xFFE5E7EB)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Sales Overview - Revenue',
//                     style: GoogleFonts.urbanist(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: AppColor.black,
//                     ),
//                   ),
//                   const Spacer(),
//                   // Filter dropdown
//                   _FilterDropdown(
//                     value: p.revenueFilter,
//                     options: const ['Week', 'Month', 'Year'],
//                     onChanged: (val) => p.setRevenueFilter(val, context),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 height: 220,
//                 child: p.isLoadingRevenue
//                     ? const Center(child: CircularProgressIndicator())
//                     : LineChart(
//                         LineChartData(
//                           minY: 0,
//                           maxY: maxY,
//                           gridData: FlGridData(
//                             show: true,
//                             drawVerticalLine: false,
//                             horizontalInterval: maxY / 5,
//                             getDrawingHorizontalLine: (value) => const FlLine(
//                               color: Color(0xFFF1F5F9),
//                               strokeWidth: 1,
//                             ),
//                           ),
//                           borderData: FlBorderData(show: false),
//                           titlesData: FlTitlesData(
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 48,
//                                 interval: maxY / 5,
//                                 getTitlesWidget: (val, meta) => Text(
//                                   val >= 1000
//                                       ? '${(val / 1000).toStringAsFixed(0)}K'
//                                       : val.toInt().toString(),
//                                   style: GoogleFonts.urbanist(
//                                     fontSize: 11,
//                                     color: AppColor.black60,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             rightTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             topTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 getTitlesWidget: (val, meta) {
//                                   final idx = val.toInt();
//                                   if (idx < 0 || idx >= points.length) {
//                                     return const SizedBox();
//                                   }
//                                   return Padding(
//                                     padding: const EdgeInsets.only(top: 8),
//                                     child: Text(
//                                       points[idx].label,
//                                       style: GoogleFonts.urbanist(
//                                         fontSize: 11,
//                                         color: AppColor.black60,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                           lineTouchData: LineTouchData(
//                             touchTooltipData: LineTouchTooltipData(
//                               getTooltipItems: (spots) => spots
//                                   .map(
//                                     (s) => LineTooltipItem(
//                                       '₹${s.y.toStringAsFixed(2)}',
//                                       GoogleFonts.urbanist(
//                                         color: Colors.white,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   )
//                                   .toList(),
//                             ),
//                           ),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: points
//                                   .asMap()
//                                   .entries
//                                   .map(
//                                     (e) => FlSpot(
//                                       e.key.toDouble(),
//                                       e.value.amount,
//                                     ),
//                                   )
//                                   .toList(),
//                               isCurved: false,
//                               color: AppColor.darkBlue,
//                               barWidth: 2,
//                               dotData: FlDotData(
//                                 show: true,
//                                 getDotPainter: (spot, percent, bar, index) =>
//                                     FlDotCirclePainter(
//                                       radius: 4,
//                                       color: AppColor.darkBlue,
//                                       strokeWidth: 2,
//                                       strokeColor: Colors.white,
//                                     ),
//                               ),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 color: AppColor.darkBlue.withOpacity(0.08),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   List<RevenuePoint> _dummyPoints() => const [
//     RevenuePoint(label: 'Sun', amount: 15000),
//     RevenuePoint(label: 'Mon', amount: 9500),
//     RevenuePoint(label: 'Tue', amount: 22000),
//     RevenuePoint(label: 'Wed', amount: 17000),
//     RevenuePoint(label: 'Thu', amount: 20000),
//     RevenuePoint(label: 'Fri', amount: 11000),
//     RevenuePoint(label: 'Sat', amount: 25000),
//   ];
// }

// ─── Orders table ─────────────────────────────────────────────────────────────
class _LatestOrdersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, p, _) {
        final orders = p.ordersModel?.data.orders ?? [];
        final pagination = p.ordersModel?.data.pagination;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Table header
              _TableHeader(),

              // Rows
              if (p.isLoadingOrders)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: Text(
                      'No orders found',
                      style: GoogleFonts.urbanist(color: AppColor.black60),
                    ),
                  ),
                )
              else
                ...orders.map((order) => _OrderRow(order: order)),

              // Pagination
              if (pagination != null) _PaginationBar(pagination: pagination),
            ],
          ),
        );
      },
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

class _TableHeader extends StatelessWidget {
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
      child: const Row(
        children: [
          _HeaderCell('Order ID', flex: 2),
          _HeaderCell('Customer', flex: 3),
          _HeaderCell('Order Type', flex: 2),
          _HeaderCell('Amount', flex: 2),
          _HeaderCell('Status', flex: 3),
          _HeaderCell('Action', flex: 2),
        ],
      ),
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
          Expanded(
            flex: 2,
            child: Text(
              '#${order.orderId}',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              order.customer,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              order.orderType,
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹${order.amount.toStringAsFixed(0)}',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(flex: 3, child: _StatusBadge(status: order.status)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => _showOrderDetail(context, order),
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
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColor.darkBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetail(BuildContext context, OrderItem order) {
    showDialog(
      context: context,
      builder: (_) => OrderDetailDialog(order: order),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color text;
    switch (status.toLowerCase()) {
      case 'new':
        text = const Color(0xFF1D4ED8);
        break;
      case 'preparing':
        text = const Color(0xFFC2410C);
        break;
      case 'mark ready':
      case 'ready for pickup':
      case 'accepted':
      case 'completed':
        text = const Color(0xFF15803D);
        break;

      case 'update requested':
        text = const Color(0xFFB45309);
        break;
      case 'rejected':
        text = AppColor.red;
        break;
      default:
        text = AppColor.black60;
    }
    return Text(
      status,
      style: GoogleFonts.urbanist(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: text,
      ),
    );
  }
}

class _PaginationBar extends StatelessWidget {
  final Pagination pagination;
  const _PaginationBar({required this.pagination});

  @override
  Widget build(BuildContext context) {
    final page = pagination.currentPage ?? 1;
    final limit = pagination.limit ?? 8;
    final total = pagination.totalCount ?? 0;
    final totalPages = pagination.totalPages ?? 1;
    final start = (page - 1) * limit + 1;
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
          _PageButton(
            label: 'Previous',
            enabled: page > 1,
            onTap: () => context.read<DashboardProvider>().getOrders(
              context: context,
              page: page - 1,
            ),
          ),
          const SizedBox(width: 8),
          _PageButton(
            label: 'Next',
            enabled: page < totalPages,
            onTap: () => context.read<DashboardProvider>().getOrders(
              context: context,
              page: page + 1,
            ),
          ),
        ],
      ),
    );
  }
}

//DashboardProvider
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

// // ─── Filter dropdown ─────────────────────────────────────────────────────────
// class _FilterDropdown extends StatelessWidget {
//   final String value;
//   final List<String> options;
//   final void Function(String) onChanged;

//   const _FilterDropdown({
//     required this.value,
//     required this.options,
//     required this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFFE5E7EB)),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isDense: true,
//           style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
//           items: options
//               .map((o) => DropdownMenuItem(value: o, child: Text(o)))
//               .toList(),
//           onChanged: (val) {
//             if (val != null) onChanged(val);
//           },
//         ),
//       ),
//     );
//   }
// }
