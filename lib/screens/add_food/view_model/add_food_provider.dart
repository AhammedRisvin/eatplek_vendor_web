// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/upload_image/view_model/upload_image_provider.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../category/model/category_model.dart';
import '../../food_details/view_model/food_detail_provider.dart';
import '../../foods/view_model/foods_provider.dart';
import '../model/add_on_model.dart';

class AddFoodProvider extends ChangeNotifier {
  // ── Edit mode ─────────────────────────────────────────────────────────────
  bool isFromEdit = false;
  String? foodId;

  void setEditControllers({
    required bool isEdit,
    required BuildContext context,
  }) {
    isFromEdit = isEdit;
    if (!isFromEdit) return;

    final food = context.read<FoodDetailsProvider>().foodData;
    foodId = food.id ?? '';
    imageUrlForUpload = food.foodImage ?? '';
    foodNameController.text = food.foodName ?? '';
    categoryId = food.category?.id;
    selectedCategory = food.category?.categoryName ?? '';
    selectedType = food.type ?? '';
    basePriceController.text = '${food.basePrice ?? 0}';
    discountPriceController.text = '${food.discountPrice ?? ''}';
    preparationTimeController.text = '${food.preparationTime ?? ''}';
    packingChargesController.text = '0';
    descriptionController.text = food.description ?? '';

    for (final orderType in food.orderTypes ?? []) {
      type.add(orderType == 'take away' ? 'takeaway' : orderType);
    }

    for (final addOn in food.addOns ?? []) {
      addOnList.add(
        AddOnModel(
          name: addOn.name ?? '',
          image: addOn.image ?? '',
          price: int.tryParse(addOn.price?.toString() ?? '0') ?? 0,
        ),
      );
    }

    notifyListeners();
  }

  // ── Order types ───────────────────────────────────────────────────────────
  List<String> type = [];

  void setServiceOfferdForApiCall(String orderType) {
    if (type.contains(orderType)) {
      type.remove(orderType);
    } else {
      type.add(orderType);
    }
    notifyListeners();
  }

  // ── Food type (Veg / Non-Veg) ─────────────────────────────────────────────
  final List<String> typeList = ['Veg', 'Non-Veg'];
  String? selectedType;

  void selectTypeFn(String value) {
    selectedType = value;
    notifyListeners();
  }

  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController basePriceController = TextEditingController();
  final TextEditingController discountPriceController = TextEditingController();
  final TextEditingController preparationTimeController =
      TextEditingController();
  final TextEditingController packingChargesController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // ── Category ──────────────────────────────────────────────────────────────
  bool isCategoryLoading = false;
  CategoryModel getFoodCategoryModel = CategoryModel();
  String? selectedCategory;
  String? categoryId;

  Future<void> getFoodCategoriesFn(
    BuildContext context,
    bool isFromAddCategory,
  ) async {
    try {
      isCategoryLoading = true;
      notifyListeners();
      final url =
          '${Urls.getFoodCategoryUrl}?page=1&limit=1000&isActive=true&sortBy=createdAt&sortOrder=desc';
      List response = await ServerClient.get(url, context);
      log('getFoodCategoriesFn: ${response.first}');
      if (response.first >= 200 && response.first < 300) {
        getFoodCategoryModel = CategoryModel.fromJson(response.last);
        if ((selectedCategory ?? '').isNotEmpty && isFromAddCategory) {
          categoryId = getFoodCategoryModel.data
              ?.firstWhere(
                (e) => e.categoryName == selectedCategory,
                orElse: () => CategoryData(),
              )
              .id;
        }
      } else {
        getFoodCategoryModel = CategoryModel();
      }
    } catch (e) {
      debugPrint('getFoodCategoriesFn error: $e');
      getFoodCategoryModel = CategoryModel();
    } finally {
      isCategoryLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    selectedCategory = category;
    categoryId = getFoodCategoryModel.data
        ?.firstWhere(
          (e) => e.categoryName == category,
          orElse: () => CategoryData(),
        )
        .id;
    log('categoryId: $categoryId');
    notifyListeners();
  }

  // ── Image upload (web — uses bytes) ───────────────────────────────────────
  String imageUrlForUpload = '';

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

  // ── Add-ons ───────────────────────────────────────────────────────────────
  final TextEditingController addOnNameController = TextEditingController();
  final TextEditingController addOnPriceController = TextEditingController();
  List<AddOnModel> addOnList = [];
  String addOnImage = '';

  Future<void> addOnPickImageFromGalleryWeb(
    BuildContext context,
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      addOnImage = await context.read<UploadImageProvider>().uploadImageWeb(
        bytes,
        fileName,
      );
    } finally {
      notifyListeners();
    }
  }

  void addNewAddOnFn(BuildContext context) {
    if (addOnImage.isEmpty) {
      toast(
        context,
        title: 'Please select image',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (addOnNameController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter add-on name',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (addOnPriceController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter add-on price',
        backgroundColor: AppColor.red,
      );
      return;
    }
    try {
      addOnList.add(
        AddOnModel(
          name: addOnNameController.text.trim(),
          image: addOnImage,
          price: int.parse(addOnPriceController.text.trim()),
        ),
      );
      addOnImage = '';
      addOnNameController.clear();
      addOnPriceController.clear();
      notifyListeners();
      Navigator.of(context).pop();
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong!',
        backgroundColor: AppColor.red,
      );
    }
  }

  void deleteAddOnByIndex(int index) {
    if (index >= 0 && index < addOnList.length) {
      addOnList.removeAt(index);
      notifyListeners();
    }
  }

  // ── Quantity ──────────────────────────────────────────────────────────────
  final TextEditingController quantityNameController = TextEditingController();
  final TextEditingController quantityPriceController = TextEditingController();
  List<AddOnModel> quantityList = [];

  void addNewQuantityFn(BuildContext context) {
    if (quantityNameController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter quantity name',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (quantityPriceController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter quantity price',
        backgroundColor: AppColor.red,
      );
      return;
    }
    try {
      quantityList.add(
        AddOnModel(
          name: quantityNameController.text.trim(),
          price: int.parse(quantityPriceController.text.trim()),
        ),
      );
      quantityNameController.clear();
      quantityPriceController.clear();
      notifyListeners();
      Navigator.of(context).pop();
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong!',
        backgroundColor: AppColor.red,
      );
    }
  }

  void deleteQuantityByIndex(int index) {
    if (index >= 0 && index < quantityList.length) {
      quantityList.removeAt(index);
      notifyListeners();
    }
  }

  // ── Add Food / Edit Food API call ─────────────────────────────────────────
  bool isFoodAdding = false;

  Future<void> addFoodFn({required BuildContext context}) async {
    if (imageUrlForUpload.isEmpty) {
      toast(
        context,
        title: 'Please select image',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (foodNameController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter food name',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (categoryId == null) {
      toast(
        context,
        title: 'Please select category',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (selectedType == null) {
      toast(
        context,
        title: 'Please select type (Veg/Non-Veg)',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (basePriceController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter base price',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (preparationTimeController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Please enter preparation time',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (type.isEmpty) {
      toast(
        context,
        title: 'Please select at least one order type',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isFoodAdding = true;
    notifyListeners();

    try {
      // Normalize takeaway
      final orderTypes = type
          .map((t) => t == 'takeaway' ? 'take away' : t)
          .toList();

      final body = {
        if (!isFromEdit) 'vendor': AppPref.userId,
        'foodImage': imageUrlForUpload,
        'foodName': foodNameController.text.trim(),
        'type': selectedType?.toLowerCase() ?? '',
        'discountPrice': num.tryParse(discountPriceController.text),
        'preparationTime': int.tryParse(preparationTimeController.text) ?? 0,
        'orderTypes': orderTypes.map((t) => t.toLowerCase()).toList(),
        'customizations': quantityList
            .map((e) => {'name': e.name, 'price': e.price})
            .toList(),
        'isActive': true,
        'isPrebook': false,
        'basePrice': num.tryParse(basePriceController.text),
        'packingCharges': num.tryParse(packingChargesController.text) ?? 0,
        'description': descriptionController.text.trim(),
        'category': categoryId,
        'addOns': addOnList
            .map((e) => {'name': e.name, 'price': e.price, 'image': e.image})
            .toList(),
      };

      log('addFoodFn body: $body');

      final List response = isFromEdit
          ? await ServerClient.put(
              '${Urls.addFoodUrl}/${foodId ?? ''}',
              data: body,
              context: context,
            )
          : await ServerClient.post(
              Urls.addFoodUrl,
              data: body,
              post: true,
              context: context,
            );

      log('addFoodFn: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        if (isFromEdit) {
          context.read<FoodDetailsProvider>().getFoodDetailFn(
            foodId: foodId ?? '',
            context: context,
          );
        }
        context.read<FoodsProvider>().getFoodFn(context: context);
        toast(
          context,
          title: isFromEdit
              ? 'Food updated successfully'
              : 'Food added successfully',
          backgroundColor: AppColor.darkBlue,
        );
        // Pop twice — confirm dialog + add food screen
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        toast(
          context,
          title: 'Failed to save food',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Server busy, please try again later',
        backgroundColor: AppColor.red,
      );
      debugPrint('addFoodFn error: $e');
    } finally {
      isFoodAdding = false;
      notifyListeners();
    }
  }

  // ── Prebook ───────────────────────────────────────────────────────────────
  bool isAddPreBook = false;
  final TextEditingController maximumGuestsController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  void setAddPreBook(bool value) {
    isAddPreBook = value;
    notifyListeners();
  }

  void setingStartDateFn({required dynamic dateTimeDynamic}) {
    final dateTime = DateTime.parse(dateTimeDynamic.toString());
    startDateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void setingEndDateFn({required dynamic dateTimeDynamic}) {
    final dateTime = DateTime.parse(dateTimeDynamic.toString());
    endDateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // ── Clear ─────────────────────────────────────────────────────────────────
  void clearAddFoodControllersFn() {
    isFromEdit = false;
    foodId = null;
    imageUrlForUpload = '';
    foodNameController.clear();
    categoryId = null;
    selectedCategory = null;
    selectedType = null;
    basePriceController.clear();
    discountPriceController.clear();
    preparationTimeController.clear();
    packingChargesController.clear();
    descriptionController.clear();
    type.clear();
    quantityList.clear();
    addOnList.clear();
    addOnImage = '';
    isAddPreBook = false;
    startDateController.clear();
    endDateController.clear();
    maximumGuestsController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    foodNameController.dispose();
    basePriceController.dispose();
    discountPriceController.dispose();
    preparationTimeController.dispose();
    packingChargesController.dispose();
    descriptionController.dispose();
    addOnNameController.dispose();
    addOnPriceController.dispose();
    quantityNameController.dispose();
    quantityPriceController.dispose();
    maximumGuestsController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
