import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/add_food_provider.dart';
import 'add_food_form_widgets.dart';
import 'add_food_upload_box.dart';

class AddFoodBasicSection extends StatelessWidget {
  const AddFoodBasicSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, provider, _) {
        final categories = provider.getFoodCategoryModel.data ?? [];
        final selectedCategory =
            categories.any(
              (category) => category.categoryName == provider.selectedCategory,
            )
            ? provider.selectedCategory
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AddFoodSectionTitle('Basic Information'),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AddFoodUploadBox(
                    imageUrl: provider.imageUrlForUpload,
                    imageBytes: provider.foodImagePreviewBytes,
                    onTap: () => _pickFoodImage(context, provider),
                  ),
                ),
                const SizedBox(width: 34),
                Expanded(
                  child: SizedBox(
                    height: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldGroup(
                          label: 'Food Name',
                          child: AddFoodTextField(
                            controller: provider.foodNameController,
                            hint: 'Enter Food Name',
                          ),
                        ),
                        _FieldGroup(
                          label: 'Category',
                          child: AddFoodDropdown<String>(
                            value: selectedCategory,
                            hint: provider.isCategoryLoading
                                ? 'Loading...'
                                : 'Select',
                            items: categories
                                .map(
                                  (category) => DropdownMenuItem<String>(
                                    value: category.categoryName,
                                    child: Text(category.categoryName ?? ''),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                provider.selectCategory(value);
                              }
                            },
                          ),
                        ),
                        _FieldGroup(
                          label: 'Type',
                          child: AddFoodDropdown<String>(
                            value: provider.selectedType,
                            hint: 'Select',
                            items: provider.typeList
                                .map(
                                  (type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) provider.selectTypeFn(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickFoodImage(
    BuildContext context,
    AddFoodProvider provider,
  ) async {
    final file = await _pickImageFile();
    if (file?.bytes == null) return;
    if (!context.mounted) return;
    provider.pickImageFromGalleryWeb(context, file!.bytes!, file.name);
  }
}

class _FieldGroup extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [AddFoodFieldLabel(label), const SizedBox(height: 8), child],
    );
  }
}

Future<PlatformFile?> _pickImageFile() async {
  final result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    withData: true,
  );
  return result?.files.first;
}
