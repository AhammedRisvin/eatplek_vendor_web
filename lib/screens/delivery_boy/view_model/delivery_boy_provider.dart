// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/upload_image/view_model/upload_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryBoyProvider extends ChangeNotifier {
  // ── List ─────────────────────────────────────────────────────────────────
  List<Map<String, dynamic>> deliveryBoys = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  int totalCount = 0;
  String filterTab = 'All Delivery boys'; // 'All Delivery boys' | 'Payouts'

  void setFilterTab(String tab) {
    filterTab = tab;
    notifyListeners();
  }

  Future<void> getDeliveryBoysFn({
    int page = 1,
    required BuildContext context,
  }) async {
    isLoading = true;
    currentPage = page;
    notifyListeners();
    try {
      // TODO: wire real API when backend provides delivery boy endpoint
      deliveryBoys = [];
      totalPages = 1;
      totalCount = 0;
    } catch (e) {
      debugPrint('getDeliveryBoysFn error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Form controllers ──────────────────────────────────────────────────────
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Bank fields
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController confirmAccountNumberController =
      TextEditingController();
  final TextEditingController ifscController = TextEditingController();

  String dialCode = '+91';
  String imageUrlForUpload = '';
  bool isAdding = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  void updateDialCode(String code) {
    dialCode = code;
    notifyListeners();
  }

  void togglePassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  void toggleConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
    notifyListeners();
  }

  // ── Image upload ──────────────────────────────────────────────────────────
  Future<void> pickImageFromGalleryWeb(
    BuildContext context,
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      imageUrlForUpload = await context
          .read<UploadImageProvider>()
          .uploadImageWeb(bytes, fileName);
    } finally {
      notifyListeners();
    }
  }

  // ── Add delivery boy ──────────────────────────────────────────────────────
  Future<void> addDeliveryBoyFn({required BuildContext context}) async {
    if (fullNameController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Full name is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (emailController.text.trim().isEmpty) {
      toast(context, title: 'Email is required', backgroundColor: AppColor.red);
      return;
    }
    if (phoneController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Phone number is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      toast(
        context,
        title: 'Password is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      toast(
        context,
        title: 'Passwords do not match',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isAdding = true;
    notifyListeners();

    try {
      // TODO: wire real API
      // final body = {
      //   'fullName': fullNameController.text.trim(),
      //   'email': emailController.text.trim(),
      //   'dialCode': dialCode,
      //   'phone': phoneController.text.trim(),
      //   'password': passwordController.text,
      //   'profileImage': imageUrlForUpload,
      // };
      await Future.delayed(const Duration(seconds: 1)); // placeholder
      toast(
        context,
        title: 'Delivery boy added successfully',
        backgroundColor: AppColor.darkBlue,
      );
      _clearControllers();
      Navigator.of(context).pop();
      getDeliveryBoysFn(context: context);
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: AppColor.red,
      );
      debugPrint('addDeliveryBoyFn error: $e');
    } finally {
      isAdding = false;
      notifyListeners();
    }
  }

  void _clearControllers() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    locationController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    accountHolderController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    confirmAccountNumberController.clear();
    ifscController.clear();
    imageUrlForUpload = '';
    dialCode = '+91';
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    accountHolderController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    ifscController.dispose();
    super.dispose();
  }
}
