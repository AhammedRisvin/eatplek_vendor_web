// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../constants/colors.dart';
import '../../../constants/common_widget.dart';
import '../../../constants/prefferences.dart';
import '../../../constants/server_client_services.dart';
import '../../../constants/urls.dart';
import '../../foods/model/get_food_model.dart';
import '../model/today_offer_model.dart';

class AddTodayOfferProvider extends ChangeNotifier {
  FoodModel? getFoodModel;

  bool isLoading = false;

  Future<void> getFoodForOfferFn({required BuildContext context}) async {
    isLoading = true;

    try {
      String url =
          "${Urls.getFoodUrl}?page=1&limit=100000&vendor=${AppPref.userId}&sortBy=createdAt&sortOrder=desc";
      // "${Urls.getFoodUrl}?page=$pageNum&limit=10";
      List response = await ServerClient.get(url, context);

      log(
        'getFood response.first ${response.first} response.last ${response.last}',
      );

      if (response.first >= 200 && response.first < 300) {
        final newFoodModel = FoodModel.fromJson(response.last);
        getFoodModel = newFoodModel;
      } else {}
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /* Add Offer Section */

  TextEditingController discountController = TextEditingController();
  String? selectedFoodId;
  FoodData foodData = FoodData();
  void selectFoodFn(FoodData food) {
    foodData = food;
    selectFoodController.text = food.foodName ?? '';
    selectedFoodId = food.id;
    log('selectedFood: ${selectFoodController.text}');
    notifyListeners();
  }

  TextEditingController selectFoodController = TextEditingController();

  List<String> typeList = ['Percentage (%)', "Flat Amount (₹)"];
  TextEditingController selectDiscountController = TextEditingController();
  String selectedTypeForApi = 'percentage';
  bool isPercent = true;
  void selectTypeFn(String type) {
    if (type == 'Percentage (%)') {
      selectedTypeForApi = 'percentage';
      selectDiscountController.text = type;
      isPercent = true;
      log('selectDiscountController.text: ${selectDiscountController.text}');
    } else {
      selectedTypeForApi = 'amount';
      selectDiscountController.text = type;
      isPercent = false;
    }

    notifyListeners();
  }

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  // DateTime? startDateTime;

  setingStartTimeFn({required dynamic timeDynamic}) {
    // startDateTime = dateTimeDynamic;
    String format = 'hh:mm a';

    // 3. Use DateFormat to format the DateTime object
    String formattedTime = DateFormat(format).format(timeDynamic);
    startTimeController.text = formattedTime.toString();
  }

  // DateTime? endDateTime;
  setingEndTimeFn({required dynamic dateTimeDynamic}) {
    String format = 'hh:mm a';

    // 3. Use DateFormat to format the DateTime object
    String formattedTime = DateFormat(format).format(dateTimeDynamic);
    endTimeController.text = formattedTime;
  }

  final Map<String, bool> activeDays = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  // Method to update the state and notify listeners
  void toggleDay(String day, bool? newValue) {
    if (activeDays.containsKey(day)) {
      activeDays[day] = newValue ?? false;
      // This is the key: tells all listening widgets to rebuild
      notifyListeners();
    }
  }

  List<String> get _selectedDays {
    return activeDays.keys.where((day) => activeDays[day] == true).toList();
  }

  bool validateSelection() {
    // Validation fails if the list of selected days is empty.
    // The 'isEmpty' check is equivalent to checking if all map values are false.
    return _selectedDays.isEmpty;
  }
  /* ADD OFFER API */

  bool isOfferAdding = false;

  Future<void> addTodayOfferFn({required BuildContext context}) async {
    if (discountController.text.isEmpty) {
      toast(
        context,
        title: 'Discount value is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    bool validationFailed = validateSelection();
    if (validationFailed) {
      toast(
        context,
        title: 'Please Select Day!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (startTimeController.text.isEmpty) {
      toast(
        context,
        title: 'Start Time is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (endTimeController.text.isEmpty) {
      toast(
        context,
        title: 'End Time is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (startTimeController.text.isEmpty) {
      toast(
        context,
        title: 'Category Name is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (selectedFoodId == null || selectedFoodId?.isEmpty == true) {
      toast(
        context,
        title: 'Description is required!',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isOfferAdding = true;
    notifyListeners();

    try {
      var body = {
        "discountType": selectedTypeForApi,
        "discountValue": num.parse(discountController.text),
        "activeDays": activeDays.keys
            // 2. Filter the keys, keeping only those where the map value is true.
            .where((day) => activeDays[day] == true)
            // 3. Convert the resulting iterable back to a List<String>.
            .toList(),
        "startTime": startTimeController.text,
        "endTime": endTimeController.text,
        "isActive": true,
      };
      List response = await ServerClient.post(
        "${Urls.getFoodDetailUrl}$selectedFoodId/day-offers",
        data: body,
        sendBody: true,
        context: context,
      );
      log(
        'response.first in add Category: ${response.first} response.last in add Category: ${response.last}',
      );
      if (response.first >= 200 && response.first < 300) {
        context.pop();

        // getCategoryFn(context: context);

        clearControllers();
        // log('getFoodCategoryModel.data: ${getCategoryModel?.data?.length}');
        toast(
          context,
          title: 'Offer added successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        context.pop();
        toast(context, title: response.last, backgroundColor: AppColor.red);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('error in add Category: $e');
    } finally {
      // categoryController.clear();
      // categoryDescriptionController.clear();
      // imageUrlForUpload = '';

      isOfferAdding = false;
      notifyListeners();
    }
  }

  clearControllers() {
    for (var day in activeDays.keys) {
      // Set the value for each day to false
      activeDays[day] = false;
    }
    selectedFoodId = null;
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    discountController = TextEditingController();
    selectedTypeForApi = 'percentage';
    selectDiscountController = TextEditingController();
    isPercent = true;
    selectFoodController = TextEditingController();
    notifyListeners();
  }

  /* GET TODAYS OFFER */

  TodayOfferModel? getTodayOfferModel;
  int foodModelIndex = 0;
  bool isGetLoading = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  int initialPage = 0;

  bool isFetchingMore = false;

  Future<void> getTodayOfferFn({
    int? page,
    required BuildContext context,
  }) async {
    if (isGetLoading || isFetchingMore) return;
    if (!hasMoreData && page != null) return;
    if (page == null || page == 1) {
      isGetLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final pageNum = page ?? 1;
      String url =
          "${Urls.addFoodUrl}/search?vendor=${AppPref.userId}&page=$pageNum&limit=10";
      List response = await ServerClient.get(url, context);

      log('response.first ${response.first} response.last ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        final newFoodModel = TodayOfferModel.fromJson(response.last);

        if (page == null || page == 1) {
          getTodayOfferModel = newFoodModel;
          subServiceCurrentPage = 2;
        } else {
          getTodayOfferModel?.data?.addAll(newFoodModel.data ?? []);
          subServiceCurrentPage++;
        }

        hasMoreData = newFoodModel.pagination?.hasNextPage ?? false;
      } else {
        if (page == null || page == 1) getTodayOfferModel = null;
        hasMoreData = false;
      }
    } finally {
      isGetLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }
}
