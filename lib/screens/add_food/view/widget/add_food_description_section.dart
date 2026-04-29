import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';

class AddFoodDescriptionSection extends StatelessWidget {
  const AddFoodDescriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddFoodSectionTitle('Description'),
            const SizedBox(height: 14),
            const AddFoodFieldLabel('About this food'),
            const SizedBox(height: 8),
            AddFoodTextField(
              controller: provider.descriptionController,
              hint: '',
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }
}
