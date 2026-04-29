import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/order_details_view_model.dart';

class RejectDialog extends StatelessWidget {
  final String bookingId;
  final OrderDetailProvider provider;

  const RejectDialog({
    super.key,
    required this.bookingId,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reject Order',
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your rejection will be sent to the customer.',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: AppColor.black60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Please specify reason',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: provider.rejectionReason,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                hintStyle: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColor.black60,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColor.darkBlue),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            Consumer<OrderDetailProvider>(
              builder: (context, p, _) => SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: p.isOrderSetting
                      ? null
                      : () => p.orderSettingFn(
                          context: context,
                          bookingId: bookingId,
                          status: 'reject',
                          onSuccess: () => Navigator.of(context).pop(),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: p.isOrderSetting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Confirm Update',
                          style: GoogleFonts.urbanist(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
