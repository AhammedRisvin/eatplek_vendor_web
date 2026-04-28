// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/upload_image/view_model/upload_image_provider.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:eatplek_vendor_web/screens/profile/model/get_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileProvider extends ChangeNotifier {
  VendorModel? getVendorModel;
  bool isVendorLoading = false;
  bool isVendorError = false;

  Future<void> getVendorProfileFn({required BuildContext context}) async {
    isVendorLoading = true;
    isVendorError = false;
    notifyListeners();
    try {
      List response = await ServerClient.get(
        Urls.getVendorProfileUrl + AppPref.userId,
        context,
      );
      if (response.first >= 200 && response.first < 300) {
        getVendorModel = VendorModel.fromJson(response.last);
      } else {
        isVendorError = true;
        getVendorModel = VendorModel();
      }
    } catch (e) {
      isVendorError = true;
      getVendorModel = VendorModel();
      debugPrint('getVendorProfileFn error: $e');
    } finally {
      isVendorLoading = false;
      notifyListeners();
    }
  }

  String formatTime(String? time) {
    if (time == null || time.isEmpty) return '--';
    try {
      final dt = DateFormat('HH:mm').parse(time);
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return time;
    }
  }

  // ── Toggle open/close for today ───────────────────────────────────────────
  void changeOpenCloseFn(BuildContext context) {
    final today = DateFormat('EEEE').format(DateTime.now());
    for (
      int i = 0;
      i < (getVendorModel?.data?.operatingHours?.length ?? 0);
      i++
    ) {
      if (getVendorModel?.data?.operatingHours?[i].day == today) {
        final current =
            getVendorModel?.data?.operatingHours?[i].isClosed ?? false;
        getVendorModel?.data?.operatingHours?[i].isClosed = !current;
        patchOperatingHoursFn(context);
        break;
      }
    }
    notifyListeners();
  }

  Future<void> patchOperatingHoursFn(BuildContext ctx) async {
    try {
      final data = {
        'operatingHours': [
          for (
            int i = 0;
            i < (getVendorModel?.data?.operatingHours?.length ?? 0);
            i++
          )
            {
              'day': getVendorModel?.data?.operatingHours?[i].day,
              'openTime': getVendorModel?.data?.operatingHours?[i].openTime,
              'closeTime': getVendorModel?.data?.operatingHours?[i].closeTime,
              'isClosed': getVendorModel?.data?.operatingHours?[i].isClosed,
            },
        ],
      };
      final response = await ServerClient.patch(
        '${Urls.getVendorProfileUrl}me/operating-hours',
        data: data,
        patch: false,
        context: ctx,
      );
      log('patchOperatingHours: ${response.first}');
      if (response.first >= 200 && response.first < 300) {
        toast(
          ctx,
          title: response.last['message'] ?? 'Updated',
          backgroundColor: Colors.green,
        );
      } else {
        toast(
          ctx,
          title: 'Failed to update hours',
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      toast(ctx, title: 'Something went wrong', backgroundColor: Colors.red);
      debugPrint('patchOperatingHoursFn error: $e');
    }
  }

  // ── Add Bank Account ──────────────────────────────────────────────────────
  final TextEditingController accountHolderController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController confirmAccountNumberController =
      TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  bool makeAsPrimary = false;
  bool isAddingBank = false;

  void setMakeAsPrimary(bool val) {
    makeAsPrimary = val;
    notifyListeners();
  }

  Future<void> addBankAccountFn({required BuildContext context}) async {
    if (accountHolderController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Account holder name is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (bankNameController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Bank name is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (accountNumberController.text.trim().isEmpty) {
      toast(
        context,
        title: 'Account number is required',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (accountNumberController.text != confirmAccountNumberController.text) {
      toast(
        context,
        title: 'Account numbers do not match',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (ifscController.text.trim().isEmpty) {
      toast(
        context,
        title: 'IFSC code is required',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isAddingBank = true;
    notifyListeners();

    try {
      final body = {
        'accountHolderName': accountHolderController.text.trim(),
        'bankName': bankNameController.text.trim(),
        'accountNumber': accountNumberController.text.trim(),
        'ifscCode': ifscController.text.trim(),
        'isPrimary': makeAsPrimary,
      };

      List response = await ServerClient.post(
        '${Urls.getVendorProfileUrl}me/bank-account',
        data: body,
        post: true,
        context: context,
      );

      log('addBankAccountFn: ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        _clearBankFields();
        getVendorProfileFn(context: context);
        Navigator.of(context).pop();
        toast(
          context,
          title: 'Bank account added successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: 'Failed to add bank account',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: AppColor.red,
      );
      debugPrint('addBankAccountFn error: $e');
    } finally {
      isAddingBank = false;
      notifyListeners();
    }
  }

  void _clearBankFields() {
    accountHolderController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    confirmAccountNumberController.clear();
    ifscController.clear();
    makeAsPrimary = false;
  }

  // ── Profile image upload ──────────────────────────────────────────────────
  String profileImageUrl = '';

  Future<void> pickProfileImageWeb(
    BuildContext context,
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      profileImageUrl = await context
          .read<UploadImageProvider>()
          .uploadImageWeb(bytes, fileName);
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    accountHolderController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    ifscController.dispose();
    super.dispose();
  }
}
