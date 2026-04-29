import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';
import 'add_food_upload_box.dart';

class AddFoodItemDialog extends StatelessWidget {
  final String title;
  final String nameLabel;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final String Function(AddFoodProvider provider) imageUrlBuilder;
  final Uint8List? Function(AddFoodProvider provider) imageBytesBuilder;
  final VoidCallback onSave;
  final Future<void> Function(PlatformFile file) onImagePicked;
  final String saveLabel;

  const AddFoodItemDialog({
    super.key,
    required this.title,
    required this.nameLabel,
    required this.nameController,
    required this.priceController,
    required this.imageUrlBuilder,
    required this.imageBytesBuilder,
    required this.onSave,
    required this.onImagePicked,
    required this.saveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  color: AppColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 28),
            AddFoodFieldLabel(nameLabel),
            const SizedBox(height: 8),
            AddFoodTextField(controller: nameController, hint: 'Enter Name'),
            const SizedBox(height: 18),
            const AddFoodFieldLabel('Price'),
            const SizedBox(height: 8),
            AddFoodTextField(
              controller: priceController,
              hint: 'Rs',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 18),
            Consumer<AddFoodProvider>(
              builder: (context, provider, _) {
                return AddFoodUploadBox(
                  imageUrl: imageUrlBuilder(provider),
                  imageBytes: imageBytesBuilder(provider),
                  height: 188,
                  helperText: 'Format: .jpeg, .png & Max file size: 25 MB',
                  onTap: () => _pickImage(),
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: Text(
                  saveLabel,
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: true,
    );
    final file = result?.files.first;
    if (file?.bytes == null) return;
    await onImagePicked(file!);
  }
}
