import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/model/all_orders_model.dart';
import '../../dashboard/view/widget/order_details_dialog.dart';
import '../../dashboard/view/widget/stats_row.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../view_model/order_provider.dart';

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
                _OrdersTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrdersTable extends StatelessWidget {
  // static const List<String> _statusOptions = [
  //   'All',
  //   'New',
  //   'Accepted',
  //   'Preparing',
  //   'Ready',
  //   'Completed',
  //   'Cancelled',
  //   'Rejected',
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, p, _) {
        final orders = p.allOrdersModelData?.data.orders ?? [];
        final pagination = p.allOrdersModelData?.data.pagination;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
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
                    _HeaderCell('Customer', flex: 3),
                    _HeaderCell('Order Type', flex: 2),
                    _HeaderCell('Amount', flex: 2),
                    _HeaderCell('Status', flex: 3),
                    // Expanded(
                    //   flex: 3,
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         'Status',
                    //         style: GoogleFonts.urbanist(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           color: AppColor.darkBlue,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 4),
                    //       DropdownButtonHideUnderline(
                    //         child: DropdownButton<String>(
                    //           value: _statusOptions.contains(p.orderStatus)
                    //               ? p.orderStatus
                    //               : 'All',
                    //           isDense: true,
                    //           icon: const Icon(
                    //             Icons.keyboard_arrow_down_rounded,
                    //             size: 16,
                    //             color: AppColor.black60,
                    //           ),
                    //           style: GoogleFonts.urbanist(
                    //             fontSize: 12,
                    //             color: AppColor.black60,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //           items: _statusOptions
                    //               .map(
                    //                 (o) => DropdownMenuItem(
                    //                   value: o,
                    //                   child: Text(
                    //                     o,
                    //                     style: GoogleFonts.urbanist(
                    //                       fontSize: 13,
                    //                       color: AppColor.black,
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //               .toList(),
                    //           onChanged: (val) {
                    //             if (val != null) {
                    //               p.setFilterStatus(val, context);
                    //             }
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    _HeaderCell('Action', flex: 2),
                  ],
                ),
              ),

              // Body
              if (p.isLoadingOrder)
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (orders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Center(
                    child: Text(
                      'No orders found',
                      style: GoogleFonts.urbanist(
                        color: AppColor.black60,
                        fontSize: 14,
                      ),
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
}

// ─── Status badge ─────────────────────────────────────────────────────────────
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
      case 'accepted':
      case 'preparing':
        text = const Color(0xFFC2410C);
        break;
      case 'mark ready':
      case 'ready for pickup':
      case 'ready':
        text = const Color(0xFF15803D);
        break;
      case 'completed':
        text = const Color(0xFF16A34A);
        break;
      case 'cancelled':
      case 'rejected':
        text = const Color(0xFFE51A1A);
        break;
      case 'update requested':
        text = const Color(0xFFB45309);
        break;
      default:
        text = AppColor.black60;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: GoogleFonts.urbanist(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    );
  }
}

// ─── Pagination — unified Pagination class (currentPage, totalCount, limit, totalPages) ──
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
            onTap: () => context.read<OrderProvider>().getAllOrdersFn(
              context: context,
              page: page - 1,
            ),
          ),
          const SizedBox(width: 8),
          _PageButton(
            label: 'Next',
            enabled: page < totalPages,
            onTap: () => context.read<OrderProvider>().getAllOrdersFn(
              context: context,
              page: page + 1,
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
