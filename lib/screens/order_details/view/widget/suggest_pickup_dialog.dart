import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/order_details_view_model.dart';

class SuggestPickupDialog extends StatefulWidget {
  final String bookingId;
  final OrderDetailProvider provider;

  const SuggestPickupDialog({
    super.key,
    required this.bookingId,
    required this.provider,
  });

  @override
  State<SuggestPickupDialog> createState() => _SuggestPickupDialogState();
}

class _SuggestPickupDialogState extends State<SuggestPickupDialog> {
  int _hour = 12;
  int _minute = 0;
  String _period = 'AM';

  @override
  void initState() {
    super.initState();
    _initTime();
  }

  void _initTime() {
    final now = DateTime.now();
    _period = now.hour >= 12 ? 'PM' : 'AM';
    if (now.hour == 0) {
      _hour = 12;
    } else if (now.hour > 12) {
      _hour = now.hour - 12;
    } else {
      _hour = now.hour;
    }
    _minute = ((now.minute + 2) ~/ 5) * 5;
    if (_minute >= 60) {
      _minute = 0;
      if (_hour == 12) {
        _hour = 1;
        _period = _period == 'AM' ? 'PM' : 'AM';
      } else {
        _hour++;
      }
    }
  }

  void _updateHour(bool inc) => setState(
    () => _hour = inc ? (_hour % 12) + 1 : (_hour - 2 + 12) % 12 + 1,
  );

  void _updateMinute(bool inc) => setState(
    () => _minute = inc ? (_minute + 5) % 60 : (_minute - 5 + 60) % 60,
  );

  void _togglePeriod() =>
      setState(() => _period = _period == 'AM' ? 'PM' : 'AM');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Suggest New Pickup Time',
              style: GoogleFonts.urbanist(
                fontSize: 17,
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: AppColor.darkBlue,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Select New Pickup Time',
                        style: GoogleFonts.urbanist(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _TimeSpinner(
                          value: _hour.toString().padLeft(2, '0'),
                          onUp: () => _updateHour(true),
                          onDown: () => _updateHour(false),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            ':',
                            style: GoogleFonts.urbanist(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColor.black,
                            ),
                          ),
                        ),
                        _TimeSpinner(
                          value: _minute.toString().padLeft(2, '0'),
                          onUp: () => _updateMinute(true),
                          onDown: () => _updateMinute(false),
                        ),
                        const SizedBox(width: 8),
                        _TimeSpinner(
                          value: _period,
                          onUp: _togglePeriod,
                          onDown: _togglePeriod,
                        ),
                      ],
                    ),
                  ),
                ],
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
                      : () {
                          int hour24 = _hour;
                          if (_period == 'PM' && _hour != 12) hour24 += 12;
                          if (_period == 'AM' && _hour == 12) hour24 = 0;
                          final now = DateTime.now();
                          final selected = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            hour24,
                            _minute,
                          );
                          p.orderSettingFn(
                            context: context,
                            bookingId: widget.bookingId,
                            status: 'suggest time',
                            time: selected.toIso8601String(),
                            onSuccess: () => Navigator.of(context).pop(),
                          );
                        },
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

class _TimeSpinner extends StatelessWidget {
  final String value;
  final VoidCallback onUp;
  final VoidCallback onDown;

  const _TimeSpinner({
    required this.value,
    required this.onUp,
    required this.onDown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onUp,
          child: const Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 28,
            color: AppColor.darkBlue,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.urbanist(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: onDown,
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
