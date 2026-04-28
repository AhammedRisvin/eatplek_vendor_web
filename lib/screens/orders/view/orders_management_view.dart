// orders_management_view.dart  (refactored)

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/model/all_orders_model.dart';
import '../../dashboard/view/widget/order_details_dialog.dart';
import '../../dashboard/view/widget/stats_row.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../../widgets/common_table.dart';
import '../view_model/order_provider.dart';

const _kOrderColumns = [
  AppTableColumn(label: 'Order ID', flex: 2),
  AppTableColumn(label: 'Customer', flex: 3),
  AppTableColumn(label: 'Order Type', flex: 2),
  AppTableColumn(label: 'Amount', flex: 2),
  AppTableColumn(label: 'Status', flex: 3),
  AppTableColumn(label: 'Action', flex: 2),
];

class OrdersManagementView extends StatefulWidget {
  const OrdersManagementView({super.key});

  @override
  State<OrdersManagementView> createState() => _OrdersManagementViewState();
}

class _OrdersManagementViewState extends State<OrdersManagementView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<OrderProvider>();
      p.getOrderStats(context: context);
      p.getAllOrdersFn(context: context, page: 1);
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
                // Stats
                Consumer<OrderProvider>(
                  builder: (context, p, _) {
                    final stats = p.orderStatsModel?.data;
                    return StatsRow(
                      isLoading: p.isLoadingOrderStats,
                      stats: [
                        (
                          'Total Orders Today',
                          stats?.totalOrdersToday?.toString() ?? '--',
                        ),
                        (
                          'Pending Orders',
                          stats?.pendingOrders?.toString() ?? '--',
                        ),
                        (
                          'Completed Orders',
                          stats?.completedOrders?.toString() ?? '--',
                        ),
                        (
                          'Cancelled Orders',
                          stats?.cancelledOrders?.toString() ?? '--',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // ── Refactored table ─────────────────────────────────────
                Consumer<OrderProvider>(
                  builder: (context, p, _) {
                    final orders = p.allOrdersModelData?.data.orders ?? [];
                    final pagination = p.allOrdersModelData?.data.pagination;

                    return AppDataTable(
                      columns: _kOrderColumns,
                      isLoading: p.isLoadingOrder,
                      isEmpty: orders.isEmpty,
                      emptyMessage: 'No orders found',
                      rows: orders.map((o) => _OrderRow(order: o)).toList(),
                      pagination: pagination,
                      onPageChange: (page) => context
                          .read<OrderProvider>()
                          .getAllOrdersFn(context: context, page: page),
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

// ── Order row ─────────────────────────────────────────────────────────────────
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
            child: _cell('₹${order.amount.toStringAsFixed(0)}'),
          ),
          Expanded(flex: 3, child: _StatusBadge(status: order.status)),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => OrderDetailDialog(order: order),
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

// ── Status badge ──────────────────────────────────────────────────────────────
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
      case 'accepted':
      case 'preparing':
        color = const Color(0xFFC2410C);
        break;
      case 'mark ready':
      case 'ready for pickup':
      case 'ready':
        color = const Color(0xFF15803D);
        break;
      case 'completed':
        color = const Color(0xFF16A34A);
        break;
      case 'cancelled':
      case 'rejected':
        color = const Color(0xFFEF4444);
        break;
      case 'update requested':
        color = const Color(0xFFB45309);
        break;
      default:
        color = AppColor.black60;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: GoogleFonts.urbanist(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
