// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/constants/server_client_services.dart';
import 'package:eatplek_vendor_web/constants/upload_image/view_model/upload_image_provider.dart';
import 'package:eatplek_vendor_web/constants/urls.dart';
import 'package:eatplek_vendor_web/screens/banners/model/banner_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BannerNotifiylistener extends ChangeNotifier {
  // ── List banners ──────────────────────────────────────────────────────────
  GetBannerModel? bannerModel;
  bool isGetLoading = false;
  bool hasMoreData = true;
  int subServiceCurrentPage = 1;
  bool isFetchingMore = false;

  Future<void> getBannerListFn({
    int? page,
    required BuildContext context,
  }) async {
    if (isGetLoading || isFetchingMore) return;
    if (!hasMoreData && page != null) return;
    if (page == null || page == 1) {
      isGetLoading = true;
    } else {
      isFetchingMore = true;
    }
    notifyListeners();

    try {
      final pageNum = page ?? 1;
      final url = '${Urls.getBannersUrl}?page=$pageNum&limit=8';
      List response = await ServerClient.get(url, context);
      log('getBannerListFn: ${response.first}');

      if (response.first >= 200 && response.first < 300) {
        final model = GetBannerModel.fromJson(response.last);
        if (page == null || page == 1) {
          bannerModel = model;
          subServiceCurrentPage = 2;
        } else {
          bannerModel?.data?.banners?.addAll(model.data?.banners ?? []);
          subServiceCurrentPage++;
        }
        hasMoreData = model.data?.pagination?.hasNextPage ?? false;
      } else {
        if (page == null || page == 1) bannerModel = null;
        hasMoreData = false;
      }
    } catch (e) {
      debugPrint('getBannerListFn error: $e');
      toast(
        context,
        title: 'Something went wrong!',
        backgroundColor: AppColor.red,
      );
    } finally {
      isGetLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  // ── Image upload (web only) ───────────────────────────────────────────────
  String imageUrlForUpload = '';

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

  // ── Date controllers ──────────────────────────────────────────────────────
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  void setingStartDateFn({required dynamic dateTimeDynamic}) {
    final dateTime = DateTime.parse(dateTimeDynamic.toString());
    startDateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    notifyListeners();
  }

  void setingEndDateFn({required dynamic dateTimeDynamic}) {
    final dateTime = DateTime.parse(dateTimeDynamic.toString());
    endDateController.text = DateFormat('yyyy-MM-dd').format(dateTime);
    notifyListeners();
  }

  // ── Add / Edit banner ─────────────────────────────────────────────────────
  bool isBannerAdding = false;
  bool isBannerEdit = false;
  String bannerId = '';

  Future<void> addBannerFn({required BuildContext context}) async {
    if (imageUrlForUpload.isEmpty) {
      toast(
        context,
        title: 'Please select image!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (startDateController.text.isEmpty) {
      toast(
        context,
        title: 'Please select start date!',
        backgroundColor: AppColor.red,
      );
      return;
    }
    if (endDateController.text.isEmpty) {
      toast(
        context,
        title: 'Please select end date!',
        backgroundColor: AppColor.red,
      );
      return;
    }

    isBannerAdding = true;
    notifyListeners();

    try {
      final body = {
        'bannerImage': imageUrlForUpload,
        'hotelId': AppPref.userId,
        'startDate': startDateController.text,
        'endDate': endDateController.text,
        'isPrebookRelated': false,
      };

      final List response = isBannerEdit
          ? await ServerClient.put(
              '${Urls.getBannersUrl}/$bannerId',
              data: body,
              context: context,
              sendBody: true,
            )
          : await ServerClient.post(
              Urls.getBannersUrl,
              data: body,
              sendBody: true,
              context: context,
            );

      log('addBannerFn: ${response.first} | ${response.last}');

      if (response.first >= 200 && response.first < 300) {
        clearAddBannerVariables();
        getBannerListFn(context: context, page: 1);
        Navigator.of(context).pop();
        toast(
          context,
          title: isBannerEdit
              ? 'Banner updated successfully'
              : 'Banner added successfully',
          backgroundColor: AppColor.darkBlue,
        );
      } else {
        toast(
          context,
          title: 'Failed to save banner!',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Server busy, please try again later',
        backgroundColor: AppColor.red,
      );
      debugPrint('addBannerFn error: $e');
    } finally {
      isBannerAdding = false;
      notifyListeners();
    }
  }

  // ── Delete banner ─────────────────────────────────────────────────────────
  bool isBannerDeleting = false;

  Future<void> deleteBannerFn(String id, BuildContext context) async {
    isBannerDeleting = true;
    notifyListeners();
    try {
      final response = await ServerClient.delete(
        '${Urls.getBannersUrl}/$id',
        context: context,
      );
      log('deleteBannerFn: ${response.first}');
      if (response.first >= 200 && response.first < 300) {
        final index = bannerModel?.data?.banners?.indexWhere((e) => e.id == id);
        if (index != null && index >= 0) {
          bannerModel?.data?.banners?.removeAt(index);
          notifyListeners();
          toast(
            context,
            title: 'Banner deleted successfully',
            backgroundColor: AppColor.darkBlue,
          );
        }
      } else {
        toast(
          context,
          title: 'Failed to delete banner',
          backgroundColor: AppColor.red,
        );
      }
    } catch (e) {
      toast(
        context,
        title: 'Something went wrong',
        backgroundColor: AppColor.red,
      );
      debugPrint('deleteBannerFn error: $e');
    } finally {
      isBannerDeleting = false;
      notifyListeners();
    }
  }

  // ── Edit setup ────────────────────────────────────────────────────────────
  void setEditBannerVariables(BannerList data) {
    isBannerEdit = true;
    bannerId = data.id ?? '';
    imageUrlForUpload = data.bannerImage ?? '';
    if (data.endDate != null) {
      // change tos tart date after model update
      startDateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(data.endDate!); // change to start date after model update
    }
    if (data.endDate != null) {
      endDateController.text = DateFormat('yyyy-MM-dd').format(data.endDate!);
    }
    notifyListeners();
  }

  // ── Clear ─────────────────────────────────────────────────────────────────
  void clearAddBannerVariables() {
    isBannerEdit = false;
    bannerId = '';
    imageUrlForUpload = '';
    startDateController.clear();
    endDateController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
