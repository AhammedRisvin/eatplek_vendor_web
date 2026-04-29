import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';

class AddFoodOrderTypesSection extends StatelessWidget {
  const AddFoodOrderTypesSection({super.key});

  static const _orderTypes = [
    ('dine in', 'Available for Dine-In'),
    ('delivery', 'Available for Delivery'),
    ('take away', 'Available for Takeaway'),
    ('car dine in', 'Available for Car Dine-In'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddFoodSectionTitle('Order Types & Availability'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 30,
              runSpacing: 12,
              children: _orderTypes.map((orderType) {
                final value = orderType.$1;
                final selected =
                    provider.type.contains(value) ||
                    (value == 'take away' &&
                        provider.type.contains('takeaway'));
                return AddFoodCheckbox(
                  label: orderType.$2,
                  selected: selected,
                  onTap: () => provider.setServiceOfferdForApiCall(value),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
