// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/category/model/category_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/model/all_orders_model.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../view_model/category_provider.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getCategoryFn(context: context, page: 1);
    });
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
                _CategoryTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Category table ───────────────────────────────────────────────────────────
class _CategoryTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, p, _) {
        final categories = p.getCategoryModel?.data ?? [];
        final pagination = p.getCategoryModel?.pagination;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: AppColor.darkBlue.withOpacity(.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: const Row(
                  children: [
                    _HeaderCell('Image', flex: 3),
                    _HeaderCell('Name', flex: 5),
                    _HeaderCell('Action', flex: 2),
                  ],
                ),
              ),

              // Body
              if (p.isLoading)
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (categories.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Center(
                    child: Text(
                      'No categories found',
                      style: GoogleFonts.urbanist(
                        color: AppColor.black60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                ...categories.map((c) => _CategoryRow(category: c)),

              // Pagination
              if (pagination != null) _PaginationBar(pagination: pagination),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.darkBlue,
        ),
      ),
    );
  }
}

// ─── Category row ─────────────────────────────────────────────────────────────
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
          // Image
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
                      errorWidget: (_, __, ___) => _ImgPlaceholder(),
                    )
                  : _ImgPlaceholder(),
            ),
          ),

          // Name
          Expanded(
            flex: 5,
            child: Text(
              category.categoryName ?? '',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),

          // Actions
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

class _ImgPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
}

// ─── Pagination ───────────────────────────────────────────────────────────────
class _PaginationBar extends StatelessWidget {
  final Pagination pagination;
  const _PaginationBar({required this.pagination});

  @override
  Widget build(BuildContext context) {
    final page = pagination.currentPage ?? 1;
    final limit = pagination.limit ?? 8;
    final total = pagination.totalCount ?? 0;
    final totalPages = pagination.totalPages ?? 1;
    final start = (page - 1) * limit + 1;
    final end = (page * limit).clamp(0, total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Text(
            '$start – $end of $total items',
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black60),
          ),
          const Spacer(),
          _PageBtn(
            label: 'Previous',
            enabled: page > 1,
            onTap: () => context.read<CategoryProvider>().getCategoryFn(
              context: context,
              page: page - 1,
            ),
          ),
          const SizedBox(width: 8),
          _PageBtn(
            label: 'Next',
            enabled: page < totalPages,
            onTap: () => context.read<CategoryProvider>().getCategoryFn(
              context: context,
              page: page + 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _PageBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F6FA),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: enabled ? AppColor.black : AppColor.black40,
          ),
        ),
      ),
    );
  }
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
