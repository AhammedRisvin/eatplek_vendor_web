// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../constants/server_client_services.dart';
import '../../dashboard/model/all_orders_model.dart';
import '../model/order_stats_model.dart';

class OrderProvider extends ChangeNotifier {
  /* DashBoard Stats */
  AllOrdersModel? allOrdersModelData;
  String orderStatus = 'Filter';
  // List<BookingOrder>? bookings = [];  int foodModelIndex = 0;
  bool isLoadingOrder = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  int initialPage = 0;
  bool isFetchingMore = false;

  setFilterStatus(String status, BuildContext context) {
    orderStatus = status;
    notifyListeners();
    getAllOrdersFn(context: context);
  }

  Future<void> getAllOrdersFn({
    int? page,
    required BuildContext context,
  }) async {
    if (isLoadingOrder || isFetchingMore) return;
    if (!hasMoreData && page != null) return;
    if (page == null || page == 1) {
      isLoadingOrder = true;
    } else {
      isFetchingMore = true;
    }

    notifyListeners();
    String url = '';
    try {
      final pageNum = page ?? 1;
      if (orderStatus.toLowerCase() == 'all' ||
          orderStatus.toLowerCase() == 'Filter') {
        url =
            "https://eatplek-server-dev.onrender.com/api/vendor/dashboard/all-orders?page=$pageNum&limit=10";
      } else {
        url =
            "https://eatplek-server-dev.onrender.com/api/vendor/dashboard/all-orders?page=$pageNum&limit=10&filter=${orderStatus.toLowerCase()}";
      }
      // "${Urls.getOrders}?page=$pageNum&limit=20&filter=accepted"; --- IGNORE ---
      log('getPreBookingsFn');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        final orderDataFromResponse = AllOrdersModel.fromJson(response.last);
        log(orderDataFromResponse.data.orders.length.toString());
        if (page == null || page == 1) {
          allOrdersModelData = orderDataFromResponse;
          subServiceCurrentPage = 2;
          isLoadingOrder = false;
        } else {
          allOrdersModelData?.data.orders.addAll(
            orderDataFromResponse.data.orders,
          );
          subServiceCurrentPage++;
          isLoadingOrder = false;
        }
        hasMoreData = orderDataFromResponse.data.orders.isNotEmpty;
        isLoadingOrder = false;
      } else {
        if (page == null || page == 1) allOrdersModelData = null;
        hasMoreData = false;
        isLoadingOrder = false;
      }
    } finally {
      isLoadingOrder = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  /* Order Stats */
  OrderStatsModel? orderStatsModel;
  bool isLoadingOrderStats = false;

  Future<void> getOrderStats({required BuildContext context}) async {
    if (isLoadingOrderStats) return;

    isLoadingOrderStats = true;
    notifyListeners();
    try {
      String url =
          "https://eatplek-server-dev.onrender.com/api/vendor/dashboard/order-stats";
      log('getDashboardStats');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        orderStatsModel = OrderStatsModel.fromJson(response.last);
        isLoadingOrderStats = false;
      } else {
        isLoadingOrderStats = false;
      }
    } finally {
      isLoadingOrderStats = false;
      notifyListeners();
    }
  }
}
