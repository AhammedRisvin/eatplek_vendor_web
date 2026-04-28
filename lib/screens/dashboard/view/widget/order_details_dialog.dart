import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/dashboard/model/all_orders_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/dashboard_provider.dart';

class OrderDetailDialog extends StatelessWidget {
  final OrderItem order;
  const OrderDetailDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: Container(
        width: 640,
        constraints: const BoxConstraints(maxWidth: 680),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 40,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(order: order),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _OrderInfoSection(order: order),
                    const SizedBox(height: 20),
                    _ItemsListSection(order: order),
                    const SizedBox(height: 24),
                    _ActionButtons(order: order),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Dialog header ────────────────────────────────────────────────────────────
class _DialogHeader extends StatelessWidget {
  final OrderItem order;
  const _DialogHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    final isUpdateRequested =
        order.rawStatus.toLowerCase() == 'update_requested';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 16, 20),
      decoration: const BoxDecoration(
        color: AppColor.darkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
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
                const SizedBox(height: 4),
                Text(
                  'Waiting for customer confirmation on your changes.',
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white54),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order info section ───────────────────────────────────────────────────────
class _OrderInfoSection extends StatelessWidget {
  final OrderItem order;
  const _OrderInfoSection({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Information',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _InfoRow('Order ID', '#${order.orderId}'),
                  const SizedBox(height: 8),
                  _InfoRow('Customer Name', order.customer),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _InfoRow('Order Type', order.orderType),
                  const SizedBox(height: 8),
                  _InfoRow(
                    'Order Time',
                    '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')} ${order.createdAt.hour >= 12 ? 'PM' : 'AM'}, ${order.createdAt.day} ${_month(order.createdAt.month)} ${order.createdAt.year}',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _InfoRow(
                    'Total Amount',
                    '₹${order.amount.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _month(int m) => [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][m];
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
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
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

// ─── Items list section ───────────────────────────────────────────────────────
class _ItemsListSection extends StatelessWidget {
  final OrderItem order;
  const _ItemsListSection({required this.order});

  @override
  Widget build(BuildContext context) {
    final isUpdateRequested =
        order.rawStatus.toLowerCase() == 'update_requested';
    final isPreparing =
        order.rawStatus.toLowerCase() == 'accepted' ||
        order.rawStatus.toLowerCase() == 'preparing';

    // Dummy items — replace with real items from order detail API
    final items = [
      {'name': 'Paneer Butter Masala', 'qty': 2, 'price': 200.0},
      {'name': 'Butter Naan', 'qty': 2, 'price': 250.0},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Items List',
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 12),
        // Table header
        Row(
          children: [
            const Expanded(flex: 4, child: _TableHead('Item Name')),
            const Expanded(flex: 2, child: _TableHead('Qty Ordered')),
            if (isUpdateRequested)
              const Expanded(flex: 2, child: _TableHead('Status'))
            else if (!isPreparing) ...[
              const Expanded(flex: 2, child: _TableHead('Price (Per Item)')),
              const Expanded(flex: 2, child: _TableHead('Subtotal')),
            ] else
              const Expanded(flex: 3, child: _TableHead('Actions')),
          ],
        ),
        const Divider(height: 1),
        ...items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    item['name'] as String,
                    style: GoogleFonts.urbanist(fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    item['qty'].toString(),
                    style: GoogleFonts.urbanist(fontSize: 13),
                  ),
                ),
                if (isUpdateRequested)
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Update Requested',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: const Color(0xFFB45309),
                      ),
                    ),
                  )
                else if (!isPreparing) ...[
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Rs.${item['price']}',
                      style: GoogleFonts.urbanist(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Rs.${((item['qty'] as int) * (item['price'] as double)).toStringAsFixed(0)}',
                      style: GoogleFonts.urbanist(fontSize: 13),
                    ),
                  ),
                ] else
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        _SmallButton(
                          label: 'Mark Unavailable',
                          onTap: () {},
                          color: const Color(0xFFF5F6FA),
                          textColor: AppColor.black,
                        ),
                        const SizedBox(width: 8),
                        _SmallButton(
                          label: 'Update Qty',
                          onTap: () => _showUpdateQtyDialog(
                            context,
                            item['name'] as String,
                            item['qty'] as int,
                          ),
                          color: const Color(0xFFF5F6FA),
                          textColor: AppColor.black,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }),
        if (!isPreparing && !isUpdateRequested) ...[
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total : Rs. ${items.fold(0.0, (sum, item) => sum + (item['qty'] as int) * (item['price'] as double)).toStringAsFixed(0)}',
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _showUpdateQtyDialog(
    BuildContext context,
    String itemName,
    int orderedQty,
  ) {
    showDialog(
      context: context,
      builder: (_) =>
          _UpdateQtyDialog(itemName: itemName, orderedQty: orderedQty),
    );
  }
}

class _TableHead extends StatelessWidget {
  final String text;
  const _TableHead(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.black60,
        ),
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const _SmallButton({
    required this.label,
    required this.onTap,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

// ─── Action buttons ───────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final OrderItem order;
  const _ActionButtons({required this.order});

  @override
  Widget build(BuildContext context) {
    final status = order.rawStatus.toLowerCase();
    final isNew = status == 'new' || status == 'pending';
    final isUpdateRequested = status == 'update_requested';

    if (isUpdateRequested) return const SizedBox();

    if (!isNew) return const SizedBox();

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<DashboardProvider>().updateOrderStatus(
                context: context,
                orderId: order.bookingId,
                status: 'accepted',
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Accept Order',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showRejectDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Reject Order',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _showSuggestPickupDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.darkBlue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Suggest New Pickup Time',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _RejectOrderDialog(order: order),
    );
  }

  void _showSuggestPickupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _SuggestPickupDialog(order: order),
    );
  }
}

// ─── Update Quantity dialog ───────────────────────────────────────────────────
class _UpdateQtyDialog extends StatefulWidget {
  final String itemName;
  final int orderedQty;
  const _UpdateQtyDialog({required this.itemName, required this.orderedQty});

  @override
  State<_UpdateQtyDialog> createState() => _UpdateQtyDialogState();
}

class _UpdateQtyDialogState extends State<_UpdateQtyDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Quantity',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'The changes will be sent to the customer for confirmation.',
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
                'Ordered Quantity',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.orderedQty.toString(),
                style: GoogleFonts.urbanist(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter Available Quantity',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColor.black,
                ),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '---',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm Update',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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

// ─── Suggest Pickup Time dialog ───────────────────────────────────────────────
class _SuggestPickupDialog extends StatefulWidget {
  final OrderItem order;
  const _SuggestPickupDialog({required this.order});

  @override
  State<_SuggestPickupDialog> createState() => _SuggestPickupDialogState();
}

class _SuggestPickupDialogState extends State<_SuggestPickupDialog> {
  int hour = 12;
  int minute = 0;
  bool isAm = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Suggest New Pickup Time',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your suggestion will be sent to the customer for confirmation.',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: AppColor.black60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: AppColor.darkBlue,
                ),
                const SizedBox(width: 6),
                Text(
                  'Select New Pickup Time',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Time picker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TimeSpinner(
                  value: hour,
                  min: 1,
                  max: 12,
                  onChanged: (v) => setState(() => hour = v),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    ':',
                    style: GoogleFonts.urbanist(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                _TimeSpinner(
                  value: minute,
                  min: 0,
                  max: 59,
                  onChanged: (v) => setState(() => minute = v),
                ),
                const SizedBox(width: 12),
                _TimeSpinner(
                  value: isAm ? 0 : 1,
                  min: 0,
                  max: 1,
                  isAmPm: true,
                  onChanged: (v) => setState(() => isAm = v == 0),
                ),
              ],
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final now = DateTime.now();
                  final selectedTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    isAm ? hour : hour + 12,
                    minute,
                  );
                  context.read<DashboardProvider>().updateOrderStatus(
                    context: context,
                    orderId: widget.order.bookingId,
                    status: 'update_requested',
                    delayedTime: selectedTime,
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm Update',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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

class _TimeSpinner extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final bool isAmPm;
  final void Function(int) onChanged;

  const _TimeSpinner({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.isAmPm = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onChanged(value < max ? value + 1 : min),
          child: const Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 28,
            color: AppColor.darkBlue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isAmPm
              ? (value == 0 ? 'AM' : 'PM')
              : value.toString().padLeft(2, '0'),
          style: GoogleFonts.urbanist(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => onChanged(value > min ? value - 1 : max),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 28,
            color: AppColor.darkBlue,
          ),
        ),
      ],
    );
  }
}

// ─── Reject Order dialog ──────────────────────────────────────────────────────
class _RejectOrderDialog extends StatefulWidget {
  final OrderItem order;
  const _RejectOrderDialog({required this.order});

  @override
  State<_RejectOrderDialog> createState() => _RejectOrderDialogState();
}

class _RejectOrderDialogState extends State<_RejectOrderDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reject Order',
              style: GoogleFonts.urbanist(
                fontSize: 18,
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
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  context.read<DashboardProvider>().updateOrderStatus(
                    context: context,
                    orderId: widget.order.bookingId,
                    status: 'rejected',
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm Update',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
