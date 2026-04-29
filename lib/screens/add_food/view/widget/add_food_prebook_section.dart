import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';

class AddFoodPrebookSection extends StatelessWidget {
  const AddFoodPrebookSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddFoodSectionTitle('Prebook Condition'),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Start Date',
                    value: provider.startDateController.text,
                    onTap: () => _pickDate(context, provider, isStart: true),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _DateField(
                    label: 'End Date',
                    value: provider.endDateController.text,
                    onTap: () => _pickDate(context, provider, isStart: false),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AddFoodFieldLabel('Maximum Guests'),
                      const SizedBox(height: 8),
                      AddFoodTextField(
                        controller: provider.maximumGuestsController,
                        hint: '---',
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    AddFoodProvider provider, {
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );
    if (picked == null) return;
    if (isStart) {
      provider.setingStartDateFn(dateTimeDynamic: picked);
    } else {
      provider.setingEndDateFn(dateTimeDynamic: picked);
    }
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddFoodFieldLabel(label),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              value.isEmpty ? 'yyyy-mm-dd' : value,
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: value.isEmpty ? AppColor.hintText : AppColor.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
