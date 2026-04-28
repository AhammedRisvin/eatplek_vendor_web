import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../constants/server_client_services.dart';
import '../model/earnings_model.dart';
import '../model/earnings_stats_model.dart';

class RevenueNotifylistner extends ChangeNotifier {
  String earningFilter = 'week';

  setEarninFiler(String filter, BuildContext context) {
    earningFilter = filter;
    notifyListeners();
    getRevenueDataFn(context: context);
    // getAllOrdersFn(context: context);
  }

  EarningsModel? earningsModel;
  bool isLoading = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  int initialPage = 0;
  bool isFetchingMore = false;
  Future<void> getAllEarningFn({
    int? page,
    required BuildContext context,
  }) async {
    if (isLoading || isFetchingMore) return;
    if (!hasMoreData && page != null) return;
    if (page == null || page == 1) {
      earningsModel?.data?.orders?.addAll([
        Order(),
        Order(),
        Order(),
        Order(),
        Order(),
      ]);
      isLoading = true;
    } else {
      isFetchingMore = true;
    }

    // if (isLoading) return;
    // if (!hasMoreData && page != null) return;
    // isLoading = true;
    notifyListeners();
    String url = '';
    try {
      final pageNum = page ?? 1;

      url =
          'https://eatplek-server-dev.onrender.com/api/vendor/dashboard/payment-earnings?filter=${earningFilter.toLowerCase()}&page=$pageNum&limit=10';
      log('getPreBookingsFn');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        final earningsData = EarningsModel.fromJson(response.last);
        if (page == null || page == 1) {
          earningsModel = earningsData;
          subServiceCurrentPage = 2;
          isLoading = false;
        } else {
          earningsModel?.data?.orders?.addAll(earningsData.data!.orders!);
          subServiceCurrentPage++;
          isLoading = false;
        }
        hasMoreData = earningsData.data?.orders?.isNotEmpty ?? false;
        isLoading = false;
      } else {
        if (page == null || page == 1) earningsModel = null;
        hasMoreData = false;
        isLoading = false;
      }
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  EarningStatsModel? earningStatsModel;
  bool isLoadingEarningStats = false;
  Future<void> getRevenueDataFn({required BuildContext context}) async {
    if (isLoadingEarningStats) return;
    isLoadingEarningStats = true;
    notifyListeners();
    try {
      String url =
          "https://eatplek-server-dev.onrender.com/api/vendor/dashboard/earnings-summary?filter=${earningFilter.toLowerCase()}";
      log('getDashboardStats');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        earningStatsModel = EarningStatsModel.fromJson(response.last);
        isLoadingEarningStats = false;
      } else {
        isLoadingEarningStats = false;
      }
    } finally {
      isLoadingEarningStats = false;
      notifyListeners();
    }
  }
}
