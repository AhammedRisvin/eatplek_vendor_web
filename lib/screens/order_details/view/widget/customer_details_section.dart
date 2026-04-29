import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/order_details_model.dart';

class CustomerDetailsSection extends StatelessWidget {
  final OrderDetailsData data;

  const CustomerDetailsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sd = data.serviceDetails;
    final serviceType = (data.serviceType ?? '').toLowerCase();
    final isDelivery = serviceType == 'delivery';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customer Details',
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 12),
        _DetailRow('Name', sd?.name?.toString() ?? '--'),
        const SizedBox(height: 6),
        _DetailRow('Phone', sd?.phoneNumber?.toString() ?? '--'),
        if (isDelivery && sd?.address != null) ...[
          const SizedBox(height: 6),
          _DetailRow('Address', sd!.address.toString()),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
        children: [
          TextSpan(
            text: '$label : ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(
            text: value,
            style: TextStyle(color: AppColor.black.withOpacity(0.65)),
          ),
        ],
      ),
    );
  }
}
