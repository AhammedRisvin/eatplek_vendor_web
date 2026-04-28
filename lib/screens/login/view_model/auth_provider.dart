// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/router.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthProvider extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  // dial code — default India
  String dialCode = '+91';

  void updateDialCode(String code) {
    dialCode = code;
    notifyListeners();
  }

  Future<void> signInFn({required BuildContext context}) async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      toast(
        context,
        title: 'Phone number must not be empty',
        duration: 2,
        backgroundColor: Colors.red,
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final params = {
        'dialCode': dialCode,
        'phone': phone,
        'deviceOs': AppPref.deviceOs,
        'deviceName': AppPref.deviceName,
        'firebaseToken': 'fcm-token-web',
      };

      List response = await ServerClient.post(
        Urls.loginUrl,
        data: params,
        post: true,
        context: context,
      );

      log('Login response: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        AppPref.userPhone = phone;
        AppPref.userDialCode = dialCode;
        toast(
          context,
          title: 'OTP sent successfully',
          duration: 2,
          backgroundColor: AppColor.darkBlue,
        );
        context.goNamed(AppRouter.otpScreen);
      } else {
        toast(
          context,
          title: response.last ?? 'Login failed',
          duration: 2,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Sign-in error: $e');
      toast(
        context,
        title: 'An error occurred',
        duration: 2,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
