// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common_table.dart';
import '../../model/today_offer_model.dart';
import '../../view_model/today_offer_provider.dart';

const _kOfferColumns = [
  AppTableColumn(label: 'Food Item', flex: 4),
  AppTableColumn(label: 'Discount Value', flex: 2),
  AppTableColumn(label: 'Active Days', flex: 3),
  AppTableColumn(label: 'Start-End Time', flex: 3),
  AppTableColumn(label: 'Status', flex: 2),
  AppTableColumn(label: 'Action', flex: 2),
];

class OffersTable extends StatelessWidget {
  const OffersTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        final offers = p.getTodayOfferModel?.data ?? [];
        final pagination = p.getTodayOfferModel?.pagination;

        return AppDataTable(
          columns: _kOfferColumns,
          isLoading: p.isGetLoading,
          isEmpty: offers.isEmpty,
          emptyMessage: 'No offers found',
          rows: offers.map((o) => _OfferRow(offer: o)).toList(),
          pagination: pagination,
          onPageChange: (page) => context
              .read<AddTodayOfferProvider>()
              .getTodayOfferFn(context: context, page: page),
        );
      },
    );
  }
}

class _OfferRow extends StatelessWidget {
  final Datum offer;
  const _OfferRow({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Food item with image
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: offer.picture != null && offer.picture!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: offer.picture!,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => _FoodPlaceholder(),
                        )
                      : _FoodPlaceholder(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    offer.foodName ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 13,
                      color: AppColor.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _cell('--')),
          Expanded(flex: 3, child: _cell('--')),
          Expanded(flex: 3, child: _cell('--')),
          Expanded(
            flex: 2,
            child: Text(
              'Active',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: const Color(0xFF16A34A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    /* TODO: edit */
                  },
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: AppColor.darkBlue,
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => _showDeleteConfirm(context, offer),
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

  void _showDeleteConfirm(BuildContext context, Datum offer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Delete Offer',
          style: GoogleFonts.urbanist(
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
        content: Text(
          'Are you sure you want to delete the offer for "${offer.foodName}"?',
          style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.urbanist(color: AppColor.black60),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.urbanist(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(
        Icons.fastfood_outlined,
        size: 18,
        color: Color(0xFFD1D5DB),
      ),
    );
  }
}
