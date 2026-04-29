import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/order_details_model.dart';
import '../../view_model/order_details_view_model.dart';
import 'update_qty_dialog.dart';

class ItemsTableSection extends StatelessWidget {
  final OrderDetailsData data;
  final String bookingId;
  final OrderDetailProvider provider;

  const ItemsTableSection({
    super.key,
    required this.data,
    required this.bookingId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final status = (data.orderStatus ?? '').toLowerCase();
    final isPending = status == 'pending';
    final isUpdateRequested = status == 'update_requested';
    final showPricing = !isPending && !isUpdateRequested;
    final items = data.items ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items List',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 12),

        // Header row
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Expanded(flex: 4, child: _TableHead('Item Name')),
              const Expanded(flex: 2, child: _TableHead('Qty Ordered')),
              if (isUpdateRequested)
                const Expanded(flex: 3, child: _TableHead('Status'))
              else if (isPending)
                const Expanded(flex: 3, child: _TableHead('Actions'))
              else ...[
                const Expanded(flex: 2, child: _TableHead('Price (Per Item)')),
                const Expanded(flex: 2, child: _TableHead('Subtotal')),
              ],
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // Item rows
        ...items.map(
          (item) => _ItemRow(
            item: item,
            isPending: isPending,
            isUpdateRequested: isUpdateRequested,
            showPricing: showPricing,
            bookingId: bookingId,
            provider: provider,
          ),
        ),

        // Total
        if (showPricing) ...[
          const Divider(height: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Total : Rs. ${data.amountSummary?.grandTotal?.toString() ?? '--'}',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  final OrderItem item;
  final bool isPending;
  final bool isUpdateRequested;
  final bool showPricing;
  final String bookingId;
  final OrderDetailProvider provider;

  const _ItemRow({
    required this.item,
    required this.isPending,
    required this.isUpdateRequested,
    required this.showPricing,
    required this.bookingId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              item.foodName ?? '--',
              style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.quantity?.toString() ?? '0',
              style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
            ),
          ),
          if (isUpdateRequested)
            Expanded(
              flex: 3,
              child: Text(
                'Update Requested',
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFB45309),
                ),
              ),
            )
          else if (isPending)
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _SmallButton(
                    label: 'Mark Unavailable',
                    onTap: () => provider.orderSettingFn(
                      context: context,
                      bookingId: bookingId,
                      status: 'Mark Unavailable',
                      foodId: item.foodId,
                      updatedQuantity: 0,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _SmallButton(
                    label: 'Update Qty',
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => UpdateQtyDialog(
                        item: item,
                        bookingId: bookingId,
                        provider: provider,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else ...[
            Expanded(
              flex: 2,
              child: Text(
                'Rs.${item.effectivePrice?.toStringAsFixed(0) ?? item.basePrice?.toStringAsFixed(0) ?? '--'}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.black,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Rs.${item.itemTotal?.toStringAsFixed(0) ?? '--'}',
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.black,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  final String text;
  const _TableHead(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColor.black60,
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SmallButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColor.black,
          ),
        ),
      ),
    );
  }
}
