import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/order_details_model.dart';
import '../../view_model/order_details_view_model.dart';

class StatusDropdown extends StatelessWidget {
  final OrderDetailsData data;
  final String bookingId;
  final OrderDetailProvider provider;

  const StatusDropdown({
    super.key,
    required this.data,
    required this.bookingId,
    required this.provider,
  });

  String _label(String status) {
    return status
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    if (provider.isUpdatingStatus) {
      return const SizedBox(
        width: 140,
        height: 36,
        child: Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    final currentStatus = data.orderStatus ?? '';
    final nextStatus = data.nextStatus ?? '';
    final available = data.availableStatuses ?? [];
    final allStatuses = [currentStatus, ...available];

    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentStatus,
          dropdownColor: Colors.white,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white,
            size: 18,
          ),
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          selectedItemBuilder: (context) => allStatuses
              .map(
                (s) => Center(
                  child: Text(
                    _label(s),
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              .toList(),
          items: allStatuses.map((s) {
            final isCurrent = s == currentStatus;
            final isNext = s == nextStatus;
            final isLocked = !isCurrent && !isNext;

            return DropdownMenuItem<String>(
              value: s,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _label(s),
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        fontWeight: isNext ? FontWeight.w600 : FontWeight.w400,
                        color: isLocked
                            ? AppColor.black.withOpacity(0.35)
                            : AppColor.black,
                      ),
                    ),
                  ),
                  if (isLocked)
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 13,
                      color: AppColor.black.withOpacity(0.3),
                    ),
                  if (isCurrent)
                    Icon(
                      Icons.check_circle_rounded,
                      size: 13,
                      color: const Color(0xFF16A34A).withOpacity(0.7),
                    ),
                ],
              ),
            );
          }).toList(),
          onChanged: (selected) {
            if (selected == null || selected == currentStatus) return;
            if (selected == nextStatus) {
              provider.updateOrderStatusFn(
                context: context,
                bookingId: bookingId,
                newStatus: selected,
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColor.darkBlue,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Text(
                  'Please mark as "${_label(nextStatus)}" first.',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
