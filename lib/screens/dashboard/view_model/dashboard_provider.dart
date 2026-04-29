// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

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

  /// Tracks order IDs we've already seen so we can detect truly new arrivals.
  final Set<String> _knownOrderIds = {};

  /// Whether at least one fetch has completed (so we don't treat the very
  /// first load as "new orders arrived").
  bool _initialFetchDone = false;

  void setOrderFilter(String filter, BuildContext context) {
    orderFilter = filter;
    currentPage = 1;
    notifyListeners();
    getOrders(context: context, page: 1);
  }

  Future<void> getOrders({
    required BuildContext context,
    int page = 1,
    bool silent = false, // true → skip loading indicator (background poll)
  }) async {
    if (isLoadingOrders) return;
    if (!silent) {
      isLoadingOrders = true;
      notifyListeners();
    }
    currentPage = page;
    try {
      String url =
          'https://eatplek-server-dev.onrender.com/api/vendor/dashboard/all-orders?page=$page&limit=8';
      if (orderFilter.toLowerCase() != 'all') {
        url += '&filter=${orderFilter.toLowerCase()}';
      }
      log('getOrders: $url');
      List response = await ServerClient.get(url, context);
      if (response.first >= 200 && response.first < 300) {
        final newModel = AllOrdersModel.fromJson(response.last);
        final incomingIds = newModel.data.orders
            .map((o) => o.orderId.toString())
            .toSet();

        if (_initialFetchDone) {
          // Find order IDs that weren't in our known set
          final brandNewIds = incomingIds.difference(_knownOrderIds);
          if (brandNewIds.isNotEmpty) {
            log('🔔 New orders detected: $brandNewIds');
            _playBeep();
            startCountdown(); // reset 3-min timer
          }
        }

        _knownOrderIds.addAll(incomingIds);
        _initialFetchDone = true;
        ordersModel = newModel;
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

  // ── Auto-refresh (every 5 s) ──────────────────────────────────────────────
  Timer? _refreshTimer;
  BuildContext? _refreshContext;

  void startAutoRefresh(BuildContext context) {
    _refreshContext = context;
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final ctx = _refreshContext;
      if (ctx != null && ctx.mounted) {
        getOrders(context: ctx, page: currentPage, silent: true);
      }
    });
    log('⏱ Auto-refresh started');
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    log('⏹ Auto-refresh stopped');
  }

  // ── Countdown timer (3 min) ───────────────────────────────────────────────
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

  // ── Beep (Web AudioContext — no package needed) ───────────────────────────
  void _playBeep() {
    try {
      js.context.callMethod('eval', [
        '''
        (function() {
          try {
            var ctx = new (window.AudioContext || window.webkitAudioContext)();
            var oscillator = ctx.createOscillator();
            var gainNode = ctx.createGain();
            oscillator.connect(gainNode);
            gainNode.connect(ctx.destination);
            oscillator.type = 'sine';
            oscillator.frequency.setValueAtTime(880, ctx.currentTime);
            gainNode.gain.setValueAtTime(0.3, ctx.currentTime);
            gainNode.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.4);
            oscillator.start(ctx.currentTime);
            oscillator.stop(ctx.currentTime + 0.4);
          } catch(e) { console.warn('Beep failed:', e); }
        })();
        ''',
      ]);
    } catch (e) {
      debugPrint('_playBeep error: $e');
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }
}

class RevenuePoint {
  final String label;
  final double amount;
  const RevenuePoint({required this.label, required this.amount});
}
