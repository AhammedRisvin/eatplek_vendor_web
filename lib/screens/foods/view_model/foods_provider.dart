// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:eatplek_vendor_web/screens/foods/model/get_food_model.dart';
import 'package:flutter/material.dart';

class FoodsProvider extends ChangeNotifier {
  bool isFilter = false;
  String filter = 'true';
  String selectedFilter = 'Active';

  void setFilterStringFn(String value) {
    selectedFilter = value;
  }

  void setFilterFn(
    String value,
    BuildContext context, {
    bool isPrebook = false,
  }) {
    filter = value;
    getFoodFn(context: context, isPrebook: isPrebook);
  }

  FoodModel? getFoodModel;
  FoodModel? getPrebookFoodModel;

  int foodModelIndex = 0;
  bool isLoading = false;
  bool isFirstLoading = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  int initialPage = 0;
  bool isFetchingMore = false;

  Future<void> getFoodFn({
    int? page,
    required BuildContext context,
    bool isPrebook = false,
  }) async {
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

      // Build URL — add isPrebook param when listing special day items
      String url = filter == 'All'
          ? '${Urls.getFoodUrl}page=$pageNum&limit=10&vendor=${AppPref.userId}&sortBy=createdAt&sortOrder=desc'
          : '${Urls.getFoodUrl}page=$pageNum&limit=10&vendor=${AppPref.userId}&isActive=$filter&sortBy=createdAt&sortOrder=desc';

      if (isPrebook) {
        url += '&isPrebook=true';
      }

      log('getFoodFn url: $url');
      List response = await ServerClient.get(url, context);
      log('getFoodFn: ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        final newFoodModel = FoodModel.fromJson(response.last);

        if (isPrebook) {
          // Store prebok foods separately
          if (page == null || page == 1) {
            getPrebookFoodModel = newFoodModel;
            subServiceCurrentPage = 2;
          } else {
            getPrebookFoodModel?.data?.addAll(newFoodModel.data ?? []);
            subServiceCurrentPage++;
          }
        } else {
          if (page == null || page == 1) {
            getFoodModel = newFoodModel;
            subServiceCurrentPage = 2;
          } else {
            getFoodModel?.data?.addAll(newFoodModel.data ?? []);
            subServiceCurrentPage++;
          }
        }

        hasMoreData = newFoodModel.pagination?.hasNextPage ?? false;
      } else {
        if (page == null || page == 1) {
          if (isPrebook) {
            getPrebookFoodModel = null;
          } else {
            getFoodModel = null;
          }
        }
        hasMoreData = false;
      }
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void setFoodAvailable(int index) {
    if (getFoodModel?.data?[index].isActive == true) {
      getFoodModel?.data?[index].isActive = false;
    } else {
      getFoodModel?.data?[index].isActive = true;
    }
    notifyListeners();
  }

  // DELETE FOOD
  Future<void> deleteFoodFn(
    String id,
    BuildContext ctx, {
    bool isPrebook = false,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await ServerClient.delete(
        '${Urls.deleteFoodUrl}$id',
        context: ctx,
      );
      log('deleteFoodFn: ${response.first}');
      if (response.first >= 200 && response.first < 300) {
        final model = isPrebook ? getPrebookFoodModel : getFoodModel;
        final index = model?.data?.indexWhere((element) => element.id == id);
        if (index != null && index >= 0) {
          model?.data?.removeAt(index);
          notifyListeners();
        }
        toast(
          ctx,
          title: 'Food deleted successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          ctx,
          title: response.last ?? 'Failed to delete',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(ctx, title: 'Something went wrong', backgroundColor: Colors.red);
      debugPrint('deleteFoodFn error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
