// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:flutter/material.dart';

import '../model/order_details_model.dart';

class OrderDetailProvider extends ChangeNotifier {
  // ── State ────────────────────────────────────────────────────────────────
  OrderDetailsModel? orderDetailsModel;
  bool isLoadingOrderDetails = false;
  bool isOrderSetting = false;
  bool isUpdatingStatus = false;
  TextEditingController rejectionReason = TextEditingController();

  // ── Fetch order details ──────────────────────────────────────────────────
  Future<void> getOrderDetails({
    required BuildContext context,
    required String bookingId,
  }) async {
    if (isLoadingOrderDetails) return;
    isLoadingOrderDetails = true;
    orderDetailsModel = null;
    notifyListeners();
    try {
      final url =
          'https://eatplek-server-dev.onrender.com/api/vendor/orders/$bookingId';
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        orderDetailsModel = OrderDetailsModel.fromJson(response.last);
      }
    } catch (e) {
      debugPrint('getOrderDetails error: $e');
    } finally {
      isLoadingOrderDetails = false;
      notifyListeners();
    }
  }

  // ── Accept / Reject / Suggest time / Mark unavailable ───────────────────
  Future<void> orderSettingFn({
    required BuildContext context,
    required String bookingId,
    required String status,
    String? time,
    String? foodId,
    int? updatedQuantity,
    VoidCallback? onSuccess,
  }) async {
    isOrderSetting = true;
    notifyListeners();
    try {
      Map<String, dynamic> body = {};
      if (status == 'accept') {
        body = {"action": "accept"};
      } else if (status == 'reject') {
        body = {"action": "reject", "rejectionReason": rejectionReason.text};
      } else if (status == 'suggest time') {
        body = {
          "action": "reject",
          "suggestedTime": time ?? '',
          "rejectionReason":
              "Please change the time. We suggest this alternative time.",
        };
      } else if (status == 'Mark Unavailable') {
        body = {
          "action": "reject",
          "rejectionReason": "Some items are unavailable",
          "modifiedItems": [
            {
              "foodId": foodId,
              "updatedQuantity": updatedQuantity,
              "reason": updatedQuantity == 0
                  ? 'Out of stock'
                  : 'Only 1 left in stock',
            },
          ],
        };
      }

      List response = await ServerClient.put(
        "${Urls.getHomeData}/$bookingId/respond",
        data: body,
        context: context,
      );
      log('orderSettingFn: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        if (status == 'accept') {
          toast(
            context,
            title: 'Order accepted successfully',
            backgroundColor: AppColor.darkBlue,
          );
          // Refresh to get updated status & availableStatuses
          await getOrderDetails(context: context, bookingId: bookingId);
        } else if (status == 'reject') {
          toast(
            context,
            title: 'Order rejected successfully',
            backgroundColor: AppColor.red,
          );
          rejectionReason = TextEditingController();
          onSuccess?.call();
        } else if (status == 'suggest time') {
          toast(
            context,
            title: 'Suggested a new time successfully',
            backgroundColor: AppColor.darkBlue,
          );
          onSuccess?.call();
        } else {
          // Mark unavailable / update qty
          toast(
            context,
            title: 'Order updated successfully',
            backgroundColor: AppColor.darkBlue,
          );
          onSuccess?.call();
          await getOrderDetails(context: context, bookingId: bookingId);
        }
      } else {
        toast(
          context,
          title: 'Failed to update order',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Server busy, please try again later',
        backgroundColor: Colors.red,
      );
      debugPrint('orderSettingFn error: $e');
    } finally {
      isOrderSetting = false;
      notifyListeners();
    }
  }

  // ── Update status via dropdown ───────────────────────────────────────────
  Future<void> updateOrderStatusFn({
    required BuildContext context,
    required String bookingId,
    required String newStatus,
  }) async {
    if (isUpdatingStatus) return;
    isUpdatingStatus = true;
    notifyListeners();
    try {
      final url = '${Urls.accpetedFoodStatusUpdateUrl}/$bookingId/status';
      final body = {"status": newStatus};
      log('updateOrderStatusFn → PATCH $url body: $body');

      List response = await ServerClient.patch(
        url,
        data: body,
        context: context,
      );
      log('updateOrderStatusFn ← ${response.first} ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        final data = orderDetailsModel?.data;
        if (data != null) {
          data.availableStatuses?.remove(newStatus);
          data.orderStatus = newStatus;
          data.nextStatus = (data.availableStatuses?.isNotEmpty == true)
              ? data.availableStatuses!.first
              : null;
        }
        toast(
          context,
          title: 'Status updated to ${_formatStatus(newStatus)}',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: 'Failed to update status',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Server busy, please try again later',
        backgroundColor: Colors.red,
      );
      debugPrint('updateOrderStatusFn error: $e');
    } finally {
      isUpdatingStatus = false;
      notifyListeners();
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
        .join(' ');
  }

  @override
  void dispose() {
    rejectionReason.dispose();
    super.dispose();
  }
}
