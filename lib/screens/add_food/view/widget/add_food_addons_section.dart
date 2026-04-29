import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';
import 'add_food_item_dialog.dart';
import 'add_food_item_tile.dart';

class AddFoodAddOnsSection extends StatelessWidget {
  const AddFoodAddOnsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const AddFoodSectionTitle('Customizations / Add-ons'),
                const Spacer(),
                AddFoodMiniButton(
                  onTap: () => _showAddOnDialog(context, provider),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: provider.addOnList.asMap().entries.map((entry) {
                return AddFoodItemTile(
                  name: entry.value.name,
                  price: entry.value.price,
                  imageUrl: entry.value.image,
                  onDelete: () => provider.deleteAddOnByIndex(entry.key),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  void _showAddOnDialog(BuildContext context, AddFoodProvider provider) {
    provider.clearAddOnDraft();
    showDialog(
      context: context,
      builder: (_) => AddFoodItemDialog(
        title: 'Add New Add-on',
        nameLabel: 'Add-on Name',
        nameController: provider.addOnNameController,
        priceController: provider.addOnPriceController,
        imageUrlBuilder: (p) => p.addOnImage,
        imageBytesBuilder: (p) => p.addOnPreviewBytes,
        onImagePicked: (file) => provider.addOnPickImageFromGalleryWeb(
          context,
          file.bytes!,
          file.name,
        ),
        onSave: () => provider.addNewAddOnFn(context),
        saveLabel: 'Save Add-on',
      ),
    );
  }
}
