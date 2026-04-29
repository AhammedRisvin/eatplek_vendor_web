import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/order_details_model.dart';
import '../../view_model/order_details_view_model.dart';
import 'status_dropdown.dart';

class OrderDetailHeader extends StatelessWidget {
  final OrderDetailsData data;
  final String bookingId;
  final OrderDetailProvider provider;

  const OrderDetailHeader({
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
    final isTerminal =
        status == 'rejected' || status == 'timeout' || status == 'completed';
    final showDropdown = !isPending && !isUpdateRequested && !isTerminal;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 18, 16, 18),
      decoration: const BoxDecoration(
        color: AppColor.darkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title block
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Review the order and take necessary action.',
                  style: GoogleFonts.urbanist(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Update requested info
          if (isUpdateRequested) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Status : Update Requested',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Waiting for customer confirmation on your changes.',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],

          // Status dropdown (after pending)
          if (showDropdown) ...[
            StatusDropdown(
              data: data,
              bookingId: bookingId,
              provider: provider,
            ),
            const SizedBox(width: 8),
          ],

          // Close button
          GestureDetector(
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
        ],
      ),
    );
  }
}
