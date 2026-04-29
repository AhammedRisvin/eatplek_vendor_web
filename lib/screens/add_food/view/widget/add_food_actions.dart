import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_confirm_dialog.dart';

class AddFoodActions extends StatelessWidget {
  final bool isEdit;
  final bool isPrebook;

  const AddFoodActions({
    super.key,
    required this.isEdit,
    required this.isPrebook,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Row(
          children: [
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: provider.isFoodAdding
                    ? null
                    : () {
                        if (provider.validateAddFoodForm(context)) {
                          _showConfirmDialog(context, provider);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  disabledBackgroundColor: AppColor.darkBlue.withValues(
                    alpha: 0.5,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: provider.isFoodAdding
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEdit ? 'Update Food' : 'Add Food',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE51A1A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'Discard',
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, AddFoodProvider provider) {
    showDialog(
      context: context,
      builder: (_) => AddFoodConfirmDialog(
        isEdit: isEdit,
        isPrebook: isPrebook,
        foodName: provider.foodNameController.text.trim(),
        onConfirm: () => provider.addFoodFn(context: context),
      ),
    );
  }
}
