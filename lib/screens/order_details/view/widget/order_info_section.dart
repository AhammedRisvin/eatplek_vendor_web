import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../model/order_details_model.dart';

class OrderInfoSection extends StatelessWidget {
  final OrderDetailsData data;

  const OrderInfoSection({super.key, required this.data});

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '--';
    return DateFormat('h:mm a, d MMM yyyy').format(dt.toLocal());
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--';
    return DateFormat('h:mm a').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final serviceType = (data.serviceType ?? '').toLowerCase();
    final isTakeaway = serviceType == 'takeaway';
    final isDineIn = serviceType == 'dine in';
    final shortId = () {
      final id = data.id ?? '';
      return id.length > 6 ? id.substring(id.length - 6) : id;
    }();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Order Information'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Column 1
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('Order ID', '#$shortId'),
                  const SizedBox(height: 10),
                  _InfoRow(
                    'Customer Name',
                    data.serviceDetails?.name?.toString() ?? '--',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Column 2
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('Order Type', data.serviceType ?? '--'),
                  const SizedBox(height: 10),
                  _InfoRow('Order Time', _formatDateTime(data.orderedAt)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Column 3
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    'Total Amount',
                    '₹${data.amountSummary?.grandTotal?.toString() ?? '--'}',
                  ),
                  if (isTakeaway) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      'Pickup Time',
                      _formatTime(data.serviceDetails?.reachTime),
                    ),
                  ],
                  if (isDineIn) ...[
                    const SizedBox(height: 10),
                    _InfoRow(
                      'Dining Time',
                      _formatTime(data.serviceDetails?.reachTime),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        if (isDineIn) ...[
          const SizedBox(height: 10),
          _InfoRow(
            'Number of Guests',
            data.serviceDetails?.personCount?.toString() ?? '--',
          ),
        ],
        if (data.notes != null && data.notes.toString().isNotEmpty) ...[
          const SizedBox(height: 10),
          _InfoRow('Notes', data.notes.toString()),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColor.black,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 5, right: 8),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.darkBlue,
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
