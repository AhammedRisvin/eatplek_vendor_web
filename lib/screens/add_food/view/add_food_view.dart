// ignore_for_file: use_build_context_synchronously

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/screens/food_details/model/food_detail_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_model/add_food_provider.dart';

class AddFoodView extends StatefulWidget {
  /// Pass [foodData] to use this screen as Edit Food
  final Data? foodData;

  /// true = Special Day Pre-BK mode, false = regular food
  final bool isPrebook;

  const AddFoodView({super.key, this.foodData, this.isPrebook = false});

  @override
  State<AddFoodView> createState() => _AddFoodViewState();
}

class _AddFoodViewState extends State<AddFoodView> {
  bool get isEdit => widget.foodData != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AddFoodProvider>();
      p.clearAddFoodControllersFn();
      if (isEdit) {
        p.setEditControllers(isEdit: true, context: context);
      }
      // Set prebook flag in provider
      p.setAddPreBook(widget.isPrebook);
      p.getFoodCategoriesFn(context, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _TopBar(isEdit: isEdit, isPrebook: widget.isPrebook),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit
                        ? (widget.isPrebook ? 'Edit Pre-BK Item' : 'Edit Food')
                        : (widget.isPrebook ? 'Add Pre-BK Item' : 'Add Food'),
                    style: GoogleFonts.urbanist(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _BasicInformationSection(),
                  const SizedBox(height: 24),
                  _PricingSection(),
                  const SizedBox(height: 24),

                  // Prebook date range — only shown when isPrebook
                  if (widget.isPrebook) ...[
                    _PrebookDatesSection(),
                    const SizedBox(height: 24),
                  ],

                  _DescriptionSection(),
                  const SizedBox(height: 24),
                  _OrderTypesSection(),
                  const SizedBox(height: 24),
                  _QuantitySection(),
                  const SizedBox(height: 24),
                  _AddOnsSection(),
                  const SizedBox(height: 32),
                  _BottomButtons(isEdit: isEdit, isPrebook: widget.isPrebook),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isEdit;
  final bool isPrebook;
  const _TopBar({required this.isEdit, required this.isPrebook});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 17
        ? 'Good Afternoon,'
        : 'Good Evening,';

    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColor.darkBlue,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
              Text(
                AppPref.userName,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.black60,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            AppPref.userName,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.darkBlue.withOpacity(0.12),
            child: Text(
              AppPref.userName.isNotEmpty
                  ? AppPref.userName[0].toUpperCase()
                  : 'V',
              style: GoogleFonts.urbanist(
                color: AppColor.darkBlue,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section card wrapper ────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColor.darkBlue,
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

// ─── Basic Information ────────────────────────────────────────────────────────
class _BasicInformationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Basic Information',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageUploadBox(
                imageUrl: p.imageUrlForUpload,
                isUploading: p.isFoodAdding,
                onTap: () => _pickImage(context, p),
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Food Name'),
                    const SizedBox(height: 8),
                    _StyledTextField(
                      controller: p.foodNameController,
                      hint: 'Enter food name',
                    ),
                    const SizedBox(height: 16),
                    const _FieldLabel('Category'),
                    const SizedBox(height: 8),
                    _CategoryDropdown(),
                    const SizedBox(height: 16),
                    const _FieldLabel('Type'),
                    const SizedBox(height: 8),
                    _TypeDropdown(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, AddFoodProvider p) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
        withData: true,
      );
      if (result == null) return;
      final file = result.files.first;
      if (file.bytes == null) return;
      p.pickImageFromGalleryWeb(context, file.bytes!, file.name);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }
}

class _ImageUploadBox extends StatelessWidget {
  final String imageUrl;
  final bool isUploading;
  final VoidCallback onTap;

  const _ImageUploadBox({
    required this.imageUrl,
    required this.isUploading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 180,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1D5DB)),
        ),
        child: isUploading
            ? const Center(child: CircularProgressIndicator())
            : imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 36,
                    color: AppColor.darkBlue,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Drop file or browse\nAdd food image',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColor.black60,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.darkBlue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Browse Files',
                      style: GoogleFonts.urbanist(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CategoryDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, p, _) {
        final categories = p.getFoodCategoryModel.data ?? [];
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: p.selectedCategory,
              isExpanded: true,
              hint: Text(
                'Select',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColor.hintText,
                ),
              ),
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c.categoryName,
                      child: Text(c.categoryName ?? ''),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) p.selectCategory(val);
              },
            ),
          ),
        );
      },
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, p, _) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: p.selectedType,
              isExpanded: true,
              hint: Text(
                'Select',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColor.hintText,
                ),
              ),
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
              items: p.typeList
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) p.selectTypeFn(val);
              },
            ),
          ),
        );
      },
    );
  }
}

// ─── Prebook Dates (only shown when isPrebook = true) ────────────────────────
class _PrebookDatesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Pre-Booking Period',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Start Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDate(context, p, isStart: true),
                      child: _DateField(controller: p.startDateController),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('End Date'),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDate(context, p, isStart: false),
                      child: _DateField(controller: p.endDateController),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    AddFoodProvider p, {
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    if (isStart) {
      p.setingStartDateFn(dateTimeDynamic: picked);
    } else {
      p.setingEndDateFn(dateTimeDynamic: picked);
    }
  }
}

class _DateField extends StatelessWidget {
  final TextEditingController controller;
  const _DateField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              controller.text.isEmpty ? '--/--/----' : controller.text,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: controller.text.isEmpty
                    ? AppColor.hintText
                    : AppColor.black,
              ),
            ),
          ),
          const Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: AppColor.black40,
          ),
        ],
      ),
    );
  }
}

// ─── Pricing ──────────────────────────────────────────────────────────────────
class _PricingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Pricing & Availability',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Does this food item have quantity options?',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColor.black,
                    ),
                  ),
                  const SizedBox(width: 24),
                  _RadioOption(
                    label: 'Yes',
                    selected: p.quantityList.isNotEmpty,
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _RadioOption(
                    label: 'No',
                    selected: p.quantityList.isEmpty,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Base Price'),
                        const SizedBox(height: 8),
                        _StyledTextField(
                          controller: p.basePriceController,
                          hint: 'Rs',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Discount Price'),
                        const SizedBox(height: 8),
                        _StyledTextField(
                          controller: p.discountPriceController,
                          hint: 'Rs',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Preparation Time'),
                        const SizedBox(height: 8),
                        _StyledTextField(
                          controller: p.preparationTimeController,
                          hint: '---',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _FieldLabel('Packing Charge'),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: _StyledTextField(
                  controller: p.packingChargesController,
                  hint: 'Rs',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Description ──────────────────────────────────────────────────────────────
class _DescriptionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Description',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _FieldLabel('About this food'),
              const SizedBox(height: 8),
              TextField(
                controller: p.descriptionController,
                maxLines: 4,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColor.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter description...',
                  hintStyle: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.hintText,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColor.darkBlue,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Order Types ──────────────────────────────────────────────────────────────
class _OrderTypesSection extends StatelessWidget {
  static const _orderTypes = [
    ('dine in', 'Available for Dine-in'),
    ('delivery', 'Available for Delivery'),
    ('take away', 'Available for Takeaway'),
    ('pickup', 'Available for Pickup'),
    ('car dine in', 'Available for Car Dine-in'),
  ];

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Order Types & Availability',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Wrap(
            spacing: 24,
            runSpacing: 12,
            children: _orderTypes.map((o) {
              final key = o.$1;
              final label = o.$2;
              final isSelected =
                  p.type.contains(key) ||
                  p.type.contains(key == 'take away' ? 'takeaway' : key);
              return _CheckboxOption(
                label: label,
                selected: isSelected,
                onTap: () => p.setServiceOfferdForApiCall(key),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// ─── Quantity ─────────────────────────────────────────────────────────────────
class _QuantitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Quantity',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: _AddButton(
                  onTap: () => _showAddQuantityDialog(context, p),
                ),
              ),
              const SizedBox(height: 12),
              if (p.quantityList.isEmpty)
                Text(
                  'No quantities added yet.',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black60,
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: p.quantityList.asMap().entries.map((e) {
                    return _AddOnTile(
                      name: e.value.name,
                      price: e.value.price,
                      imageUrl: e.value.image,
                      onDelete: () => p.deleteQuantityByIndex(e.key),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAddQuantityDialog(BuildContext context, AddFoodProvider p) {
    p.quantityNameController.clear();
    p.quantityPriceController.clear();
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        title: 'Add New Quantity',
        nameController: p.quantityNameController,
        priceController: p.quantityPriceController,
        showImagePicker: false,
        onSave: () => p.addNewQuantityFn(context),
        saveLabel: 'Save',
      ),
    );
  }
}

// ─── Add-ons ──────────────────────────────────────────────────────────────────
class _AddOnsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Customizations / Add-ons',
      child: Consumer<AddFoodProvider>(
        builder: (context, p, _) {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: _AddButton(onTap: () => _showAddOnDialog(context, p)),
              ),
              const SizedBox(height: 12),
              if (p.addOnList.isEmpty)
                Text(
                  'No add-ons added yet.',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black60,
                  ),
                )
              else
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: p.addOnList.asMap().entries.map((e) {
                    return _AddOnTile(
                      name: e.value.name,
                      price: e.value.price,
                      imageUrl: e.value.image,
                      onDelete: () => p.deleteAddOnByIndex(e.key),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showAddOnDialog(BuildContext context, AddFoodProvider p) {
    p.addOnNameController.clear();
    p.addOnPriceController.clear();
    p.addOnImage = '';
    showDialog(
      context: context,
      builder: (_) => _AddItemDialog(
        title: 'Add New Add-on',
        nameController: p.addOnNameController,
        priceController: p.addOnPriceController,
        showImagePicker: true,
        imageUrl: p.addOnImage,
        onImagePick: () async {
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
            withData: true,
          );
          if (result == null) return;
          final file = result.files.first;
          if (file.bytes == null) return;
          p.addOnPickImageFromGalleryWeb(context, file.bytes!, file.name);
        },
        onSave: () => p.addNewAddOnFn(context),
        saveLabel: 'Save Add-on',
      ),
    );
  }
}

// ─── Bottom Buttons ───────────────────────────────────────────────────────────
class _BottomButtons extends StatelessWidget {
  final bool isEdit;
  final bool isPrebook;
  const _BottomButtons({required this.isEdit, required this.isPrebook});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddFoodProvider>(
      builder: (context, p, _) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: p.isFoodAdding
                  ? null
                  : () => _showConfirmDialog(context, p),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.darkBlue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: p.isFoodAdding
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isEdit
                          ? (isPrebook ? 'Update Pre-BK' : 'Update Food')
                          : (isPrebook ? 'Add Pre-BK' : 'Add Food'),
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Discard',
                style: GoogleFonts.urbanist(
                  color: const Color(0xFFEF4444),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(BuildContext context, AddFoodProvider p) {
    showDialog(
      context: context,
      builder: (_) => _ConfirmDialog(
        foodName: p.foodNameController.text,
        isEdit: isEdit,
        isPrebook: isPrebook,
        onConfirm: () {
          isPrebook ? () {} : p.addFoodFn(context: context);
        },
      ),
    );
  }
}

// ─── Confirm dialog ───────────────────────────────────────────────────────────
class _ConfirmDialog extends StatelessWidget {
  final String foodName;
  final bool isEdit;
  final bool isPrebook;
  final VoidCallback onConfirm;

  const _ConfirmDialog({
    required this.foodName,
    required this.isEdit,
    required this.isPrebook,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final title = isEdit
        ? 'Confirm Update ${isPrebook ? 'Pre-BK' : 'Food'} Item'
        : 'Confirm Add ${isPrebook ? 'Pre-BK' : 'Food'} Item';

    final body = isEdit
        ? "You're about to update $foodName.\nAre you sure you want to continue?"
        : "You're about to add $foodName to your menu.\nAre you sure you want to continue?";

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isPrebook
                    ? const Color(0xFFFFF7E6)
                    : const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(36),
              ),
              child: Icon(
                isPrebook
                    ? Icons.calendar_today_outlined
                    : Icons.restaurant_menu_rounded,
                size: 36,
                color: isPrebook
                    ? const Color(0xFFD97706)
                    : const Color(0xFF7C3AED),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColor.black60,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'This action cannot be undone.*',
              style: GoogleFonts.urbanist(
                fontSize: 11,
                color: AppColor.black40,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add Item dialog (shared for qty & addon) ────────────────────────────────
class _AddItemDialog extends StatelessWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final bool showImagePicker;
  final String? imageUrl;
  final VoidCallback? onImagePick;
  final VoidCallback onSave;
  final String saveLabel;

  const _AddItemDialog({
    required this.title,
    required this.nameController,
    required this.priceController,
    required this.showImagePicker,
    this.imageUrl,
    this.onImagePick,
    required this.onSave,
    required this.saveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 360,
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _FieldLabel(showImagePicker ? 'Add-on Name' : 'Name'),
            const SizedBox(height: 8),
            _StyledTextField(controller: nameController, hint: 'Enter Name'),
            const SizedBox(height: 16),
            const _FieldLabel('Price'),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: priceController,
              hint: 'Rs',
              keyboardType: TextInputType.number,
            ),
            if (showImagePicker) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onImagePick,
                child: Consumer<AddFoodProvider>(
                  builder: (ctx, p, _) => Container(
                    width: double.infinity,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: p.addOnImage.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: Image.network(
                              p.addOnImage,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 28,
                                color: AppColor.darkBlue,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Drop file or browse',
                                style: GoogleFonts.urbanist(
                                  fontSize: 12,
                                  color: AppColor.black60,
                                ),
                              ),
                              Text(
                                'Format: .jpeg, .png & Max file size: 25 MB',
                                style: GoogleFonts.urbanist(
                                  fontSize: 11,
                                  color: AppColor.black40,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.darkBlue,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Browse Files',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  saveLabel,
                  style: GoogleFonts.urbanist(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable small widgets ───────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: GoogleFonts.urbanist(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColor.black,
    ),
  );
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColor.hintText),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.darkBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColor.darkBlue : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.darkBlue,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
          ),
        ],
      ),
    );
  }
}

class _CheckboxOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CheckboxOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: selected ? AppColor.darkBlue : Colors.white,
              border: Border.all(
                color: selected ? AppColor.darkBlue : const Color(0xFFD1D5DB),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: selected
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: AppColor.darkBlue,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'Add',
              style: GoogleFonts.urbanist(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddOnTile extends StatelessWidget {
  final String name;
  final int price;
  final String? imageUrl;
  final VoidCallback onDelete;

  const _AddOnTile({
    required this.name,
    required this.price,
    this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                imageUrl!,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              Text(
                'Rs.$price',
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  color: AppColor.black60,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.close,
                size: 14,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
