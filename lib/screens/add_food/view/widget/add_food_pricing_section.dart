import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';

class AddFoodPricingSection extends StatelessWidget {
  const AddFoodPricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddFoodSectionTitle('Pricing & Availability'),
            const SizedBox(height: 14),
            Row(
              children: [
                const Text('Does this food item have quantity options?'),
                const SizedBox(width: 24),
                AddFoodCheckbox(
                  label: 'Yes',
                  selected: provider.hasQuantityOptions,
                  onTap: () => provider.setHasQuantityOptions(true),
                ),
                const SizedBox(width: 16),
                AddFoodCheckbox(
                  label: 'No',
                  selected: !provider.hasQuantityOptions,
                  onTap: () => provider.setHasQuantityOptions(false),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _LabeledField(
                    label: 'Base Price',
                    controller: provider.basePriceController,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _LabeledField(
                    label: 'Discount Price',
                    controller: provider.discountPriceController,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: _LabeledField(
                    label: 'Preparation Time (in minutes)',
                    controller: provider.preparationTimeController,
                    hint: 'Minutes',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: 300,
              child: _LabeledField(
                label: 'Packing Charge',
                controller: provider.packingChargesController,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LabeledField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _LabeledField({
    required this.label,
    required this.controller,
    this.hint = 'Rs',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddFoodFieldLabel(label),
        const SizedBox(height: 8),
        AddFoodTextField(
          controller: controller,
          hint: hint,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
