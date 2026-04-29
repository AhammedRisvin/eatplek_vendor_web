// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../constants/common_widget.dart';
import '../../../constants/server_client_services.dart';
import '../../../constants/urls.dart';
import '../../foods/view_model/foods_provider.dart';
import '../model/food_detail_model.dart';

class FoodDetailsProvider extends ChangeNotifier {
  FoodDetailModel? getFoodDetailModel;

  bool isFetching = false;
  bool isError = false;

  Future<void> getFoodDetailFn({
    required String foodId,
    required BuildContext context,
  }) async {
    isFetching = true;
    isError = false;
    notifyListeners();

    try {
      String url = "${Urls.getFoodDetailUrl}$foodId";
      // "${Urls.getFoodUrl}?page=$pageNum&limit=10";
      List response = await ServerClient.get(url, context);

      log('response.first ${response.first} response.last ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        final newFoodModel = FoodDetailModel.fromJson(response.last);

        getFoodDetailModel = newFoodModel;

        if (getFoodDetailModel?.data?.isActive == true) {
          selectedAvalilability = 'Available';
        } else {
          selectedAvalilability = 'Not Available';
        }
      } else {
        isError = true;
        isFetching = false;
        notifyListeners();
      }
    } finally {
      isFetching = false;
      notifyListeners();
    }
  }

  Data foodData = Data();
  void setFoodDataFn(Data food) {
    foodData = food;
    print(foodData.id);
    notifyListeners();
  }

  /* DELETE FOOD SECTION */
  bool isDeleting = false;

  Future<void> deleteFoodFn(BuildContext context) async {
    print(getFoodDetailModel?.data?.id);
    try {
      isDeleting = true;
      notifyListeners();
      final response = await ServerClient.delete(
        '${Urls.addFoodUrl}/${getFoodDetailModel?.data?.id ?? ""}',
        context: context,
      );
      log('response.first ${response.first} response.last ${response.last}');
      if (response.first >= 200 && response.first < 300) {
        context.read<FoodsProvider>().getFoodFn(context: context);
        Navigator.pop(context);
        toast(
          context,
          title: 'Food deleted successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(context, title: response.last, backgroundColor: Colors.red);
        log('toggleFoodAvailability error: ${response.last}');
      }
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: Colors.red,
      );
      debugPrint('toggleFoodAvailability error: $e');
    } finally {
      Navigator.pop(context);
      isDeleting = false;
      notifyListeners();
    }
  }

  String? selectedAvalilability;

  void selectAvalilability(String available, BuildContext context) {
    selectedAvalilability = available;
    if (selectedAvalilability == 'Available') {
      toggleFoodAvailability(getFoodDetailModel?.data?.id ?? '', true, context);
    } else {
      toggleFoodAvailability(
        getFoodDetailModel?.data?.id ?? '',
        false,
        context,
      );
    }
    notifyListeners();
  }

  //  ADD FOOD AVAILABLE FUNCTION START
  Future<void> toggleFoodAvailability(
    String id,
    bool isAvailable,
    BuildContext ctx, {
    bool? isFromFoodTile = false,
    int? index = -1,
  }) async {
    try {
      print(" klfksglnklfklgnlndflg $isAvailable");
      final data = {"status": !isAvailable ? 'on' : "off"};
      final response = await ServerClient.patch(
        "${Urls.getFoodDetailUrl}$id/active",
        data: data,
        sendBody: false,
        context: ctx,
      );
      log('response.first ${response.first} response.last ${response.last}');
      if (response.first >= 200 && response.first < 300) {
        if (isFromFoodTile == true) {
          ctx.read<FoodsProvider>().setFoodAvailable(index ?? -1);
        }
        toast(
          ctx,
          title: response.last["message"],
          backgroundColor: Colors.green,
        );
      } else {
        toast(ctx, title: response.last, backgroundColor: Colors.red);
      }
    } catch (e) {
      toast(ctx, title: 'Something went wrong', backgroundColor: Colors.red);
      debugPrint('toggleFoodAvailability error: $e');
    }
  }

  //  ADD FOOD AVAILABLE FUNCTION END
}
