import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/order_details_view_model.dart';
import 'widget/customer_details_section.dart';
import 'widget/items_table_section.dart';
import 'widget/order_action_buttons.dart';
import 'widget/order_detail_header.dart';
import 'widget/order_info_section.dart';

class OrderDetailDialog extends StatefulWidget {
  /// The bookingId used for all API calls (accept/reject/fetch)
  final String bookingId;

  const OrderDetailDialog({super.key, required this.bookingId});

  @override
  State<OrderDetailDialog> createState() => _OrderDetailDialogState();
}

class _OrderDetailDialogState extends State<OrderDetailDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderDetailProvider>().getOrderDetails(
        context: context,
        bookingId: widget.bookingId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.075,
        vertical: screenSize.height * 0.075,
      ),
      child: Container(
        width: screenSize.width * 0.85,
        constraints: BoxConstraints(maxHeight: screenSize.height * 0.85),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 48,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Consumer<OrderDetailProvider>(
            builder: (context, provider, _) {
              // ── Loading state ─────────────────────────────────────────
              if (provider.isLoadingOrderDetails) {
                return const _LoadingShell();
              }

              final data = provider.orderDetailsModel?.data;

              // ── Error state ───────────────────────────────────────────
              if (data == null) {
                return const _ErrorShell();
              }

              final status = (data.orderStatus ?? '').toLowerCase();
              final isPending = status == 'pending';
              final isUpdateRequested = status == 'update_requested';
              final showCustomer = !isPending && !isUpdateRequested;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Dark blue header ─────────────────────────────────
                  OrderDetailHeader(
                    data: data,
                    bookingId: widget.bookingId,
                    provider: provider,
                  ),

                  // ── Scrollable body ──────────────────────────────────
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order information
                          OrderInfoSection(data: data),

                          const SizedBox(height: 20),
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 20),

                          // Customer details (hidden for pending/update_requested)
                          if (showCustomer) ...[
                            CustomerDetailsSection(data: data),
                            const SizedBox(height: 20),
                            const Divider(height: 1, color: Color(0xFFF1F5F9)),
                            const SizedBox(height: 20),
                          ],

                          // Items list
                          ItemsTableSection(
                            data: data,
                            bookingId: widget.bookingId,
                            provider: provider,
                          ),

                          // Pending action buttons
                          if (isPending) ...[
                            const SizedBox(height: 24),
                            OrderActionButtons(
                              bookingId: widget.bookingId,
                              provider: provider,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─── Loading shell ─────────────────────────────────────────────────────────────
class _LoadingShell extends StatelessWidget {
  const _LoadingShell();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fake header
        Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFF042E60),
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
        ),
        const SizedBox(height: 80),
        const CircularProgressIndicator(color: Color(0xFF042E60)),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ─── Error shell ───────────────────────────────────────────────────────────────
class _ErrorShell extends StatelessWidget {
  const _ErrorShell();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFF042E60),
            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        const SizedBox(height: 60),
        const Icon(Icons.error_outline, size: 40, color: Colors.grey),
        const SizedBox(height: 12),
        const Text('Failed to load order details.'),
        const SizedBox(height: 60),
      ],
    );
  }
}
