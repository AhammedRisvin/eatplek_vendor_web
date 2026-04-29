import 'package:eatplek_vendor_web/constants/assets.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFoodConfirmDialog extends StatelessWidget {
  final bool isEdit;
  final bool isPrebook;
  final String foodName;
  final VoidCallback onConfirm;

  const AddFoodConfirmDialog({
    super.key,
    required this.isEdit,
    required this.isPrebook,
    required this.foodName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final action = isEdit ? 'Update' : 'Add';
    final item = isPrebook ? 'Pre-BK' : 'Food';
    final title = 'Confirm $action $item Item';
    final description = isEdit
        ? "You're about to update ${foodName.isEmpty ? 'this item' : foodName}."
        : "You're about to add ${foodName.isEmpty ? 'this item' : foodName} to your menu";

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(addFoodGif, width: 82, height: 82, fit: BoxFit.contain),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColor.black,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$description\nAre you sure you want to continue?',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColor.black60,
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.urbanist(
                          color: AppColor.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF08A64B),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isEdit
                  ? 'Customers will see the updated item after saving.'
                  : 'This action cannot be undone. Customers will no longer see or order this item.*',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(color: AppColor.black60, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}
