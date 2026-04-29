import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../view_model/order_details_view_model.dart';
import 'reject_dialog.dart';
import 'suggest_pickup_dialog.dart';

class OrderActionButtons extends StatelessWidget {
  final String bookingId;
  final OrderDetailProvider provider;

  const OrderActionButtons({
    super.key,
    required this.bookingId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionBtn(
            label: 'Accept Order',
            color: const Color(0xFF16A34A),
            isLoading: provider.isOrderSetting,
            onTap: () => provider.orderSettingFn(
              context: context,
              bookingId: bookingId,
              status: 'accept',
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionBtn(
            label: 'Reject Order',
            color: const Color(0xFFEF4444),
            isLoading: false,
            onTap: () => showDialog(
              context: context,
              builder: (_) =>
                  RejectDialog(bookingId: bookingId, provider: provider),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionBtn(
            label: 'Suggest New Pickup Time',
            color: AppColor.darkBlue,
            isLoading: false,
            onTap: () => showDialog(
              context: context,
              builder: (_) =>
                  SuggestPickupDialog(bookingId: bookingId, provider: provider),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.urbanist(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
