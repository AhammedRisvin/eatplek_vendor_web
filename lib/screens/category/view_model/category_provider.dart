// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/upload_image/view_model/upload_image_provider.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:eatplek_vendor_web/screens/category/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  // ── List categories ───────────────────────────────────────────────────────
  CategoryModel? getCategoryModel;
  bool isLoading = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  bool isFetchingMore = false;

  Future<void> getCategoryFn({int? page, required BuildContext context}) async {
    if (isLoading || isFetchingMore) return;
    if (!hasMoreData && page != null) return;
    if (page == null || page == 1) {
      isLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final pageNum = page ?? 1;
      final url =
          '${Urls.getFoodCategoryUrl}?page=$pageNum&limit=8&isActive=true&sortBy=createdAt&sortOrder=desc';
      List response = await ServerClient.get(url, context);
      log('getCategoryFn: ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        final model = CategoryModel.fromJson(response.last);
        if (page == null || page == 1) {
          getCategoryModel = model;
          subServiceCurrentPage = 2;
        } else {
          getCategoryModel?.data?.addAll(model.data ?? []);
          subServiceCurrentPage++;
        }
        hasMoreData = model.data != null && model.data!.isNotEmpty;
      } else {
        if (page == null || page == 1) getCategoryModel = null;
        hasMoreData = false;
      }
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  // ── Controllers & image ───────────────────────────────────────────────────
  final TextEditingController categoryController = TextEditingController();
  String imageUrlForUpload = '';

  // ── Image upload (web only) ───────────────────────────────────────────────
  Future<void> pickImageFromGalleryWeb(
    BuildContext context,
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      imageUrlForUpload = await context
          .read<UploadImageProvider>()
          .uploadImageWeb(bytes, fileName);
    } finally {
      notifyListeners();
    }
  }

  // ── Add category ──────────────────────────────────────────────────────────
  bool isCategoryAdding = false;

  Future<void> addCategoryFn({required BuildContext context}) async {
    if (categoryController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Category Name is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (imageUrlForUpload.isEmpty) {
      toast(
        context,
        title: 'Image is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isCategoryAdding = true;
    notifyListeners();

    try {
      final body = {
        'categoryName': categoryController.text.trim(),
        'image': imageUrlForUpload,
      };

      List response = await ServerClient.post(
        Urls.addCategoryUrl,
        data: body,
        sendBody: true,
        context: context,
      );

      log('addCategoryFn: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        _clearFields();
        getCategoryFn(context: context, page: 1);
        Navigator.of(context).pop();
        toast(
          context,
          title: 'Category added successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: response.last ?? 'Failed to add category',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      debugPrint('addCategoryFn error: $e');
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: AppColor.red,
      );
    } finally {
      isCategoryAdding = false;
      notifyListeners();
    }
  }

  // ── Edit category ─────────────────────────────────────────────────────────
  bool isEditCategory = false;
  String categoryId = '';
  bool isCategoryEditing = false;

  void setEditCategory(CategoryData data) {
    isEditCategory = true;
    categoryId = data.id ?? '';
    imageUrlForUpload = data.image ?? '';
    categoryController.text = data.categoryName ?? '';
    notifyListeners();
  }

  void setEdit() {
    isEditCategory = false;
    categoryId = '';
    imageUrlForUpload = '';
    categoryController.clear();
    notifyListeners();
  }

  Future<void> updateCategoryFn({required BuildContext context}) async {
    if (categoryController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Category Name is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (imageUrlForUpload.isEmpty) {
      toast(
        context,
        title: 'Image is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isCategoryEditing = true;
    notifyListeners();

    try {
      final body = {
        'categoryName': categoryController.text.trim(),
        'image': imageUrlForUpload,
        'isActive': true,
      };

      List response = await ServerClient.put(
        '${Urls.deleteCategoryUrl}$categoryId',
        data: body,
        sendBody: false,
        context: context,
      );

      log('updateCategoryFn: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        _clearFields();
        getCategoryFn(context: context, page: 1);
        Navigator.of(context).pop();
        toast(
          context,
          title: 'Category updated successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: response.last ?? 'Failed to update category',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      debugPrint('updateCategoryFn error: $e');
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: AppColor.red,
      );
    } finally {
      isCategoryEditing = false;
      notifyListeners();
    }
  }

  // ── Delete category ───────────────────────────────────────────────────────
  bool isDeleting = false;

  Future<void> deleteCategoryFn(String id, BuildContext context) async {
    isDeleting = true;
    notifyListeners();
    try {
      final response = await ServerClient.delete(
        '${Urls.deleteCategoryUrl}$id',
        context: context,
      );
      log('deleteCategoryFn: ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        final index = getCategoryModel?.data?.indexWhere((e) => e.id == id);
        if (index != null && index >= 0) {
          getCategoryModel?.data?.removeAt(index);
          notifyListeners();
        }
        Navigator.of(context).pop();
        toast(
          context,
          title: 'Category deleted successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: response.last ?? 'Failed to delete',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: Colors.red,
      );
      debugPrint('deleteCategoryFn error: $e');
    } finally {
      isDeleting = false;
      notifyListeners();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _clearFields() {
    categoryController.clear();
    imageUrlForUpload = '';
    isEditCategory = false;
    categoryId = '';
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }
}
