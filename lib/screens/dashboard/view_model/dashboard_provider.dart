// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:eatplek_vendor_web/screens/dashboard/model/all_orders_model.dart';
import 'package:flutter/material.dart';

import '../model/dashboard_stat_model.dart';

class DashboardProvider extends ChangeNotifier {
  // ── Stats ────────────────────────────────────────────────────────────────────
  DashBoardStatsModel? statsModel;
  bool isLoadingStats = false;

  Future<void> getDashboardStats({required BuildContext context}) async {
    if (isLoadingStats) return;
    isLoadingStats = true;
    notifyListeners();
    try {
      const url =
          'https://eatplek-server-dev.onrender.com/api/vendor/dashboard/stats';
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        statsModel = DashBoardStatsModel.fromJson(response.last);
      }
    } catch (e) {
      debugPrint('getDashboardStats error: $e');
    } finally {
      isLoadingStats = false;
      notifyListeners();
    }
  }

  // ── Revenue chart ─────────────────────────────────────────────────────────
  String revenueFilter = 'Week';
  List<RevenuePoint> revenuePoints = [];
  bool isLoadingRevenue = false;

  void setRevenueFilter(String filter, BuildContext context) {
    revenueFilter = filter;
    notifyListeners();
    getRevenueData(context: context);
  }

  Future<void> getRevenueData({required BuildContext context}) async {
    if (isLoadingRevenue) return;
    isLoadingRevenue = true;
    notifyListeners();
    try {
      final url =
          'https://eatplek-server-dev.onrender.com/api/vendor/dashboard/earnings-summary?filter=${revenueFilter.toLowerCase()}';
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        final data = response.last;
        // Parse daily/weekly revenue points from response
        List raw =
            data['data']?['revenueAnalytics']?['monthlyAmounts'] ??
            data['data']?['dailyRevenue'] ??
            data['data']?['points'] ??
            [];
        revenuePoints = raw
            .map(
              (e) => RevenuePoint(
                label:
                    e['month']?.toString() ??
                    e['day']?.toString() ??
                    e['label']?.toString() ??
                    '',
                amount: (e['amount'] ?? e['revenue'] ?? 0).toDouble(),
              ),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('getRevenueData error: $e');
    } finally {
      isLoadingRevenue = false;
      notifyListeners();
    }
  }

  // ── Orders table ─────────────────────────────────────────────────────────
  AllOrdersModel? ordersModel;
  bool isLoadingOrders = false;
  int currentPage = 1;
  String orderFilter = 'All';

  void setOrderFilter(String filter, BuildContext context) {
    orderFilter = filter;
    currentPage = 1;
    notifyListeners();
    getOrders(context: context, page: 1);
  }

  Future<void> getOrders({required BuildContext context, int page = 1}) async {
    if (isLoadingOrders) return;
    isLoadingOrders = true;
    currentPage = page;
    notifyListeners();
    try {
      String url =
          'https://eatplek-server-dev.onrender.com/api/vendor/dashboard/all-orders?page=$page&limit=8';
      if (orderFilter.toLowerCase() != 'all') {
        url += '&filter=${orderFilter.toLowerCase()}';
      }
      log('getOrders: $url');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        ordersModel = AllOrdersModel.fromJson(response.last);
      }
    } catch (e) {
      debugPrint('getOrders error: $e');
    } finally {
      isLoadingOrders = false;
      notifyListeners();
    }
  }

  // ── Order status update ───────────────────────────────────────────────────
  Future<void> updateOrderStatus({
    required BuildContext context,
    required String orderId,
    required String status,
    DateTime? delayedTime,
    List<String>? unavailableItems,
  }) async {
    try {
      List response = await ServerClient.put(
        '${Urls.putAcceptBookingsUrl}?bookingID=$orderId&status=$status',
        data: {
          'notAvailableItems': unavailableItems ?? [],
          'delayedTime': delayedTime?.toIso8601String(),
        },
        context: context,
      );
      log('updateOrderStatus: ${response.first} | ${response.last}');
      if (response.first >= 200 && response.first <= 299) {
        toast(
          context,
          title: response.last['message'] ?? 'Order updated',
          backgroundColor: AppColor.darkBlue,
        );
        getOrders(context: context, page: currentPage);
      } else {
        toast(
          context,
          title: 'Failed to update order status',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('updateOrderStatus error: $e');
    }
  }

  // ── Countdown timer (3 min) ──────────────────────────────────────────────
  int countdownSeconds = 180;
  Timer? _countdownTimer;

  void startCountdown() {
    _countdownTimer?.cancel();
    countdownSeconds = 180;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (countdownSeconds > 0) {
        countdownSeconds--;
        notifyListeners();
      } else {
        t.cancel();
      }
    });
  }

  String get countdownDisplay {
    final m = (countdownSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (countdownSeconds % 60).toString().padLeft(2, '0');
    return '$m   $s';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}

class RevenuePoint {
  final String label;
  final double amount;
  const RevenuePoint({required this.label, required this.amount});
}
