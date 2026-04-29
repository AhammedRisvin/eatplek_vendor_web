// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/category/model/category_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/top_bar.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../../widgets/common_table.dart';
import '../view_model/category_provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  static const int _kTabIndex = 7;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.watch<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CategoryProvider>().getCategoryFn(
          context: context,
          page: 1,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Category',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<CategoryProvider>().setEdit();
                        showDialog(
                          context: context,
                          builder: (_) => const _AddEditCategoryDialog(),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add Category',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const CategoryTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const _kCategoryColumns = [
  AppTableColumn(label: 'Image', flex: 3),
  AppTableColumn(label: 'Name', flex: 5),
  AppTableColumn(label: 'Action', flex: 2),
];

class CategoryTable extends StatelessWidget {
  const CategoryTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, p, _) {
        final categories = p.getCategoryModel?.data ?? [];
        final pagination = p.getCategoryModel?.pagination;

        return AppDataTable(
          columns: _kCategoryColumns,
          isLoading: p.isLoading,
          isEmpty: categories.isEmpty,
          emptyMessage: 'No categories found',
          rows: categories.map((c) => _CategoryRow(category: c)).toList(),
          pagination: pagination,
          onPageChange: (page) => context
              .read<CategoryProvider>()
              .getCategoryFn(context: context, page: page),
        );
      },
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final CategoryData category;
  const _CategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: category.image != null && category.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: category.image!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _CategoryPlaceholder(),
                    )
                  : _CategoryPlaceholder(),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              category.categoryName ?? '',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<CategoryProvider>().setEditCategory(category);
                    showDialog(
                      context: context,
                      builder: (_) =>
                          const _AddEditCategoryDialog(isEdit: true),
                    );
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColor.darkBlue,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => _DeleteCategoryDialog(
                      categoryId: category.id ?? '',
                      categoryName: category.categoryName ?? '',
                    ),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 44,
    height: 44,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFFF3F4F6),
    ),
    child: const Icon(
      Icons.category_outlined,
      color: Color(0xFFD1D5DB),
      size: 20,
    ),
  );
}

// ─── Add / Edit Category Dialog ───────────────────────────────────────────────
class _AddEditCategoryDialog extends StatelessWidget {
  final bool isEdit;
  const _AddEditCategoryDialog({this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(28),
        child: Consumer<CategoryProvider>(
          builder: (context, p, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEdit ? 'Edit Category' : 'Add Categories',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image label
                Text(
                  'Add image',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Image upload area
                GestureDetector(
                  onTap: () => _pickImage(context, p),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: p.imageUrlForUpload.isNotEmpty
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImage(
                                  imageUrl: p.imageUrlForUpload,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColor.darkBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColor.darkBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Add image',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              Text(
                                'add your image for Category',
                                style: GoogleFonts.urbanist(
                                  fontSize: 11,
                                  color: AppColor.black60,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Category name
                Text(
                  'Category name',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: p.categoryController,
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    color: AppColor.black,
                  ),
                  decoration: InputDecoration(
                    hintText: '--/--/----',
                    hintStyle: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColor.hintText,
                    ),
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
                      borderSide: const BorderSide(
                        color: AppColor.darkBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (p.isCategoryAdding || p.isCategoryEditing)
                        ? null
                        : () => isEdit
                              ? p.updateCategoryFn(context: context)
                              : p.addCategoryFn(context: context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkBlue,
                      disabledBackgroundColor: AppColor.darkBlue.withOpacity(
                        0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: (p.isCategoryAdding || p.isCategoryEditing)
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEdit ? 'Save Changes' : 'Add',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, CategoryProvider p) async {
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

// ─── Delete Category Dialog ───────────────────────────────────────────────────
class _DeleteCategoryDialog extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const _DeleteCategoryDialog({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 32,
                color: Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure want to delete "$categoryName"?',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColor.black60,
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
                      'No',
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
                  child: Consumer<CategoryProvider>(
                    builder: (context, p, _) => ElevatedButton(
                      onPressed: p.isDeleting
                          ? null
                          : () => p.deleteCategoryFn(categoryId, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: p.isDeleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Yes',
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
