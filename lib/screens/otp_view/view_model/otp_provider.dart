// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/router.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OtpProvider extends ChangeNotifier {
  String otp = '';
  bool isLoading = false;
  bool isResendLoading = false;

  // ----------- Countdown timer -----------
  static const int _timerSeconds = 45;
  int secondsRemaining = _timerSeconds;
  bool canResend = false;
  Timer? _timer;

  OtpProvider() {
    _startTimer();
  }

  void _startTimer() {
    secondsRemaining = _timerSeconds;
    canResend = false;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        canResend = true;
        timer.cancel();
      } else {
        secondsRemaining--;
      }
      notifyListeners();
    });
  }

  String get timerDisplay {
    final m = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final s = (secondsRemaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ----------- Verify OTP -----------
  Future<void> verifyOtp({required BuildContext context}) async {
    if (otp.length < 6) {
      toast(
        context,
        title: 'Please enter the 6-digit OTP',
        duration: 2,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final params = {
        'dialCode': AppPref.userDialCode,
        'phone': AppPref.userPhone,
        'otp': otp,
        'deviceOs': AppPref.deviceOs,
        'deviceName': AppPref.deviceName,
        'firebaseToken': 'fcm-token-web',
      };

      List response = await ServerClient.post(
        Urls.verifyOtp,
        data: params,
        context: context,
      );

      log('OTP response: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        AppPref.userToken = response.last['token'];
        AppPref.userId = response.last['data']['id'];
        AppPref.userName = response.last['data']['restaurantName'];
        AppPref.isSignedIn = true;
        toast(
          context,
          title: 'Verification successful',
          duration: 2,
          backgroundColor: AppColor.darkBlue,
        );
        context.goNamed(AppRouter.sideNav);
      } else {
        toast(
          context,
          title: response.last == 'Vendor not found'
              ? 'Admin not verified'
              : 'Invalid OTP',
          duration: 2,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('OTP error: $e');
      toast(
        context,
        title: 'Server error',
        duration: 2,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ----------- Resend OTP -----------
  Future<void> resendOtp({required BuildContext context}) async {
    if (!canResend) return;
    isResendLoading = true;
    notifyListeners();

    try {
      final params = {
        'dialCode': AppPref.userDialCode,
        'phone': AppPref.userPhone,
        'deviceOs': AppPref.deviceOs,
        'deviceName': AppPref.deviceName,
        'firebaseToken': 'fcm-token-web',
      };
      List response = await ServerClient.post(
        Urls.loginUrl,
        data: params,
        sendBody: true,
        context: context,
      );
      if (response.first >= 200 && response.first < 300) {
        toast(
          context,
          title: 'OTP resent successfully',
          duration: 2,
          backgroundColor: AppColor.darkBlue,
        );
        _startTimer();
      } else {
        toast(
          context,
          title: response.last ?? 'Failed to resend OTP',
          duration: 2,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'An error occurred',
        duration: 2,
        backgroundColor: Colors.red,
      );
    } finally {
      isResendLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
