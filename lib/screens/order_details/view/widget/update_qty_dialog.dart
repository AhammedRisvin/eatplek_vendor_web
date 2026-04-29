import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../model/order_details_model.dart';
import '../../view_model/order_details_view_model.dart';

class UpdateQtyDialog extends StatefulWidget {
  final OrderItem item;
  final String bookingId;
  final OrderDetailProvider provider;

  const UpdateQtyDialog({
    super.key,
    required this.item,
    required this.bookingId,
    required this.provider,
  });

  @override
  State<UpdateQtyDialog> createState() => _UpdateQtyDialogState();
}

class _UpdateQtyDialogState extends State<UpdateQtyDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Quantity',
                style: GoogleFonts.urbanist(
                  fontSize: 17,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.item.quantity?.toString() ?? '0',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black,
                  ),
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
              TextFormField(
                controller: _controller,
                keyboardType: TextInputType.number,
                style: GoogleFonts.urbanist(fontSize: 13),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter a value';
                  if (int.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '---',
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
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
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
                            if (_formKey.currentState!.validate()) {
                              p.orderSettingFn(
                                context: context,
                                bookingId: widget.bookingId,
                                status: 'Mark Unavailable',
                                foodId: widget.item.foodId,
                                updatedQuantity: int.parse(_controller.text),
                                onSuccess: () => Navigator.of(context).pop(),
                              );
                            }
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
      ),
    );
  }
}
