import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';
import 'add_food_item_dialog.dart';
import 'add_food_item_tile.dart';

class AddFoodQuantitySection extends StatelessWidget {
  const AddFoodQuantitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AddFoodSectionTitle('Quantity'),
                const Spacer(),
                AddFoodMiniButton(
                  onTap: () => _showQuantityDialog(context, provider),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: provider.quantityList.asMap().entries.map((entry) {
                return AddFoodItemTile(
                  name: entry.value.name,
                  price: entry.value.price,
                  imageUrl: entry.value.image,
                  onDelete: () => provider.deleteQuantityByIndex(entry.key),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _showQuantityDialog(BuildContext context, AddFoodProvider provider) {
    provider.clearQuantityDraft();
    showDialog(
      context: context,
      builder: (_) => AddFoodItemDialog(
        title: 'Add New Quantity',
        nameLabel: 'Name',
        nameController: provider.quantityNameController,
        priceController: provider.quantityPriceController,
        imageUrlBuilder: (p) => p.quantityImage,
        imageBytesBuilder: (p) => p.quantityPreviewBytes,
        onImagePicked: (file) => provider.quantityPickImageFromGalleryWeb(
          context,
          file.bytes!,
          file.name,
        ),
        onSave: () => provider.addNewQuantityFn(context),
        saveLabel: 'Save',
      ),
    );
  }
}
