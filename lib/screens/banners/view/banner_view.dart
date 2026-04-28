// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/banners/model/banner_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/top_bar.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../../widgets/common_table.dart';
import '../view_model.dart/banner_notifylistener.dart';

class BannerView extends StatefulWidget {
  const BannerView({super.key});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  static const int _kTabIndex = 5;
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.read<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<BannerNotifiylistener>().getBannerListFn(
          context: context,
          page: 1,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Banners',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<BannerNotifiylistener>()
                            .clearAddBannerVariables();
                        showDialog(
                          context: context,
                          builder: (_) => const _AddEditBannerDialog(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Banner',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const BannerTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const _kBannerColumns = [
  AppTableColumn(label: 'Image', flex: 3),
  AppTableColumn(label: 'Start Date', flex: 3),
  AppTableColumn(label: 'End Date', flex: 3),
  AppTableColumn(label: 'Action', flex: 2),
];

class BannerTable extends StatelessWidget {
  const BannerTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BannerNotifiylistener>(
      builder: (context, p, _) {
        final banners = p.bannerModel?.data?.banners ?? [];
        final pagination = p.bannerModel?.data?.pagination;

        return AppDataTable(
          columns: _kBannerColumns,
          isLoading: p.isGetLoading,
          isEmpty: banners.isEmpty,
          emptyMessage: 'No banners found',
          rows: banners.map((b) => _BannerRow(banner: b)).toList(),
          pagination: pagination,
          onPageChange: (page) => context
              .read<BannerNotifiylistener>()
              .getBannerListFn(context: context, page: page),
        );
      },
    );
  }
}

class _BannerRow extends StatelessWidget {
  final BannerList banner;
  const _BannerRow({required this.banner});

  String _fmt(DateTime? dt) =>
      dt == null ? '--' : DateFormat('dd-MM-yyyy').format(dt);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  banner.bannerImage != null && banner.bannerImage!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: banner.bannerImage!,
                      width: 60,
                      height: 44,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _BannerPlaceholder(),
                    )
                  : _BannerPlaceholder(),
            ),
          ),
          Expanded(flex: 3, child: _cell(_fmt(banner.endDate))),
          Expanded(flex: 3, child: _cell(_fmt(banner.endDate))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context
                        .read<BannerNotifiylistener>()
                        .setEditBannerVariables(banner);
                    showDialog(
                      context: context,
                      builder: (_) => const _AddEditBannerDialog(isEdit: true),
                    );
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColor.darkBlue,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) =>
                        _DeleteBannerDialog(bannerId: banner.id ?? ''),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(String t) =>
      Text(t, style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black));
}

class _BannerPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 60,
    height: 44,
    decoration: BoxDecoration(
      color: const Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.image_outlined, color: Color(0xFFD1D5DB), size: 22),
  );
}

// ─── Add / Edit Banner Dialog ─────────────────────────────────────────────────
class _AddEditBannerDialog extends StatelessWidget {
  final bool isEdit;
  const _AddEditBannerDialog({this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(28),
        child: Consumer<BannerNotifiylistener>(
          builder: (context, p, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEdit ? 'Edit Banner' : 'Add Banner',
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image label
                Text(
                  'Add image',
                  style: GoogleFonts.urbanist(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColor.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Image upload area
                GestureDetector(
                  onTap: () => _pickImage(context, p),
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: p.imageUrlForUpload.isNotEmpty
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: CachedNetworkImage(
                                  imageUrl: p.imageUrlForUpload,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Edit icon overlay
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColor.darkBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: AppColor.darkBlue,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Add image',
                                style: GoogleFonts.urbanist(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              Text(
                                'add your image for banner',
                                style: GoogleFonts.urbanist(
                                  fontSize: 11,
                                  color: AppColor.black60,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Dates row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start date',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _pickDate(context, p, isStart: true),
                            child: _DateField(
                              controller: p.startDateController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'End Date',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _pickDate(context, p, isStart: false),
                            child: _DateField(controller: p.endDateController),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: p.isBannerAdding
                        ? null
                        : () => p.addBannerFn(context: context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkBlue,
                      disabledBackgroundColor: AppColor.darkBlue.withOpacity(
                        0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: p.isBannerAdding
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isEdit ? 'Save Changes' : 'Add Banner',
                            style: GoogleFonts.urbanist(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, BannerNotifiylistener p) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'webp'],
        withData: true,
      );
      if (result == null) return;
      final file = result.files.first;
      if (file.bytes == null) return;
      p.pickImageFromGalleryWeb(context, file.bytes!, file.name);
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
  }

  Future<void> _pickDate(
    BuildContext context,
    BannerNotifiylistener p, {
    required bool isStart,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null) return;
    if (isStart) {
      p.setingStartDateFn(dateTimeDynamic: picked);
    } else {
      p.setingEndDateFn(dateTimeDynamic: picked);
    }
  }
}

// ─── Date field ───────────────────────────────────────────────────────────────
class _DateField extends StatelessWidget {
  final TextEditingController controller;
  const _DateField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              controller.text.isEmpty ? '--/--/----' : controller.text,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: controller.text.isEmpty
                    ? AppColor.hintText
                    : AppColor.black,
              ),
            ),
          ),
          const Icon(
            Icons.calendar_today_outlined,
            size: 16,
            color: AppColor.black40,
          ),
        ],
      ),
    );
  }
}

// ─── Delete Banner Dialog ─────────────────────────────────────────────────────
class _DeleteBannerDialog extends StatelessWidget {
  final String bannerId;
  const _DeleteBannerDialog({required this.bannerId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trash icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 32,
                color: Color(0xFFB71C1C),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Are you sure want to delete?',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColor.black60,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'No',
                      style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<BannerNotifiylistener>(
                    builder: (context, p, _) => ElevatedButton(
                      onPressed: p.isBannerDeleting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              p.deleteBannerFn(bannerId, context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB71C1C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: p.isBannerDeleting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Yes',
                              style: GoogleFonts.urbanist(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
