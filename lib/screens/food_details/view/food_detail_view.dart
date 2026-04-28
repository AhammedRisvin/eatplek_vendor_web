import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/screens/add_food/view/add_food_view.dart';
import 'package:eatplek_vendor_web/screens/foods/model/get_food_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/stats_row.dart';
import '../../foods/view_model/foods_provider.dart';
import '../view_model/food_detail_provider.dart';

class FoodDetailView extends StatefulWidget {
  final FoodData food;
  final bool isPrebook;

  const FoodDetailView({super.key, required this.food, this.isPrebook = false});

  @override
  State<FoodDetailView> createState() => _FoodDetailViewState();
}

class _FoodDetailViewState extends State<FoodDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoodDetailsProvider>().getFoodDetailFn(
        foodId: widget.food.id ?? '',
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _TopBar(isPrebook: widget.isPrebook),
          Expanded(
            child: Consumer<FoodDetailsProvider>(
              builder: (context, p, _) {
                if (p.isFetching) {
                  return const Center(child: CircularProgressIndicator());
                }

                final detail = p.getFoodDetailModel?.data;
                final more = p.getFoodDetailModel?.moreDetails;

                if (detail == null) {
                  return Center(
                    child: Text(
                      'Failed to load food details',
                      style: GoogleFonts.urbanist(color: AppColor.black60),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Main detail card ──────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Text(
                                  widget.isPrebook
                                      ? 'Pre-BK Details'
                                      : 'Food Details',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.black,
                                  ),
                                ),
                                const Spacer(),
                                // Stock & Availability dropdown
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Stock & Availability: ',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          color: AppColor.black60,
                                        ),
                                      ),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value:
                                              p.selectedAvalilability ??
                                              'Available',
                                          isDense: true,
                                          style: GoogleFonts.urbanist(
                                            fontSize: 13,
                                            color: AppColor.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          items: ['Available', 'Not Available']
                                              .map(
                                                (s) => DropdownMenuItem(
                                                  value: s,
                                                  child: Text(s),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              p.selectAvalilability(
                                                val,
                                                context,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Content row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 280,
                                    height: 200,
                                    child:
                                        detail.foodImage != null &&
                                            detail.foodImage!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: detail.foodImage!,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) =>
                                                _ImgPlaceholder(),
                                          )
                                        : _ImgPlaceholder(),
                                  ),
                                ),
                                const SizedBox(width: 28),

                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            detail.foodName ?? '',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            detail.type ?? '',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  (detail.type ?? '')
                                                          .toLowerCase() ==
                                                      'veg'
                                                  ? const Color(0xFF16A34A)
                                                  : const Color(0xFFEF4444),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),

                                      // Prebook date range
                                      if (widget.isPrebook &&
                                          detail.prebookStartDate != null &&
                                          detail.prebookEndDate != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColor.darkBlue
                                                .withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            'Pre-BK Period: ${DateFormat('dd/MM/yyyy').format(detail.prebookStartDate!)} – ${DateFormat('dd/MM/yyyy').format(detail.prebookEndDate!)}',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 12,
                                              color: AppColor.darkBlue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],

                                      Text(
                                        'About The Food',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.black,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        detail.description ?? '',
                                        style: GoogleFonts.urbanist(
                                          fontSize: 13,
                                          color: AppColor.black60,
                                          height: 1.6,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          _InfoChip(
                                            label: 'Preparation Time',
                                            value:
                                                '${detail.preparationTime ?? '--'} mins',
                                          ),
                                          const SizedBox(width: 32),
                                          _InfoChip(
                                            label: 'Category',
                                            value:
                                                detail.category?.categoryName ??
                                                '--',
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${detail.effectivePrice?.toStringAsFixed(0) ?? detail.basePrice?.toStringAsFixed(0) ?? '0'}',
                                            style: GoogleFonts.urbanist(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: AppColor.black,
                                            ),
                                          ),
                                          if (detail.discountPrice != null &&
                                              (detail.discountPrice ?? 0) >
                                                  0) ...[
                                            const SizedBox(width: 8),
                                            Text(
                                              '₹${detail.discountPrice?.toStringAsFixed(0)}',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 15,
                                                color: AppColor.black40,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Add-ons
                            if (detail.addOns != null &&
                                detail.addOns!.isNotEmpty) ...[
                              Text(
                                'Customizations (Add-ons)',
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: detail.addOns!
                                    .map((a) => _AddOnChip(addOn: a))
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Action buttons
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddFoodView(
                                        foodData: detail,
                                        isPrebook: widget.isPrebook,
                                      ),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.darkBlue,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Edit Food',
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () =>
                                      _showDeleteDialog(context, p),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFEF4444),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Remove Food',
                                    style: GoogleFonts.urbanist(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // More Details stats
                      if (more != null) ...[
                        Text(
                          'More Details',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        StatsRow(
                          stats: [
                            (
                              'Total Orders Today',
                              more.totalOrders?.toString() ?? '0',
                            ),
                            (
                              'Today\'s Orders',
                              more.todayOrders?.toString() ?? '0',
                            ),
                            (
                              'Revenue Generated',
                              more.revenueGenerated?.toString() ?? '0',
                            ),
                            (
                              'Delivery Orders',
                              more.ordersByServiceType?.delivery?.toString() ??
                                  '0',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _StatCard(
                              label: 'Total Orders',
                              value: more.totalOrders?.toString() ?? '0',
                              icon: Icons.shopping_bag_outlined,
                              iconBg: const Color(0xFFEDE9FE),
                              iconColor: const Color(0xFF7C3AED),
                            ),
                            const SizedBox(width: 16),
                            _StatCard(
                              label: "Today's Orders",
                              value: more.todayOrders?.toString() ?? '0',
                              icon: Icons.trending_up_rounded,
                              iconBg: const Color(0xFFFFF7E6),
                              iconColor: const Color(0xFFD97706),
                            ),
                            const SizedBox(width: 16),
                            _StatCard(
                              label: 'Revenue Generated',
                              value: more.revenueGenerated?.toString() ?? '0',
                              icon: Icons.payments_outlined,
                              iconBg: const Color(0xFFFFEDE9),
                              iconColor: const Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 16),
                            _StatCard(
                              label: 'Delivery Orders',
                              value:
                                  more.ordersByServiceType?.delivery
                                      ?.toString() ??
                                  '0',
                              icon: Icons.delivery_dining_outlined,
                              iconBg: const Color(0xFFE6F4EA),
                              iconColor: const Color(0xFF16A34A),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, FoodDetailsProvider p) {
    showDialog(
      context: context,
      builder: (_) => _DeleteFoodDialog(
        foodName: p.getFoodDetailModel?.data?.foodName ?? '',
        onConfirm: () {
          // Delete via FoodsProvider so list updates too
          context.read<FoodsProvider>().deleteFoodFn(
            p.getFoodDetailModel?.data?.id ?? '',
            context,
            isPrebook: widget.isPrebook,
          );
          Navigator.of(context).pop(); // pop detail screen
        },
      ),
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final bool isPrebook;
  const _TopBar({required this.isPrebook});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : hour < 17
        ? 'Good Afternoon,'
        : 'Good Evening,';

    return Container(
      height: 64,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColor.darkBlue,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.urbanist(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
              Text(
                AppPref.userName,
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  color: AppColor.black60,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            AppPref.userName,
            style: GoogleFonts.urbanist(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.darkBlue.withOpacity(0.12),
            child: Text(
              AppPref.userName.isNotEmpty
                  ? AppPref.userName[0].toUpperCase()
                  : 'V',
              style: GoogleFonts.urbanist(
                color: AppColor.darkBlue,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Small widgets ────────────────────────────────────────────────────────────
class _ImgPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFFF3F4F6),
    child: const Center(
      child: Icon(Icons.fastfood_outlined, color: Color(0xFFD1D5DB), size: 40),
    ),
  );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(color: AppColor.black60),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AddOnChip extends StatelessWidget {
  final dynamic addOn;
  const _AddOnChip({required this.addOn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (addOn.image != null && (addOn.image as String).isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: CachedNetworkImage(
                imageUrl: addOn.image as String,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const Icon(
                  Icons.fastfood_outlined,
                  size: 24,
                  color: AppColor.black40,
                ),
              ),
            ),
          if (addOn.image != null && (addOn.image as String).isNotEmpty)
            const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                addOn.name?.toString() ?? '',
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColor.black,
                ),
              ),
              Text(
                'Rs.${addOn.price?.toString() ?? '0'}',
                style: GoogleFonts.urbanist(
                  fontSize: 11,
                  color: AppColor.black60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColor.black60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: GoogleFonts.urbanist(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Delete dialog ────────────────────────────────────────────────────────────
class _DeleteFoodDialog extends StatelessWidget {
  final String foodName;
  final VoidCallback onConfirm;

  const _DeleteFoodDialog({required this.foodName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete Food Item',
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Are you sure you want to delete $foodName from your menu?',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: AppColor.black60,
                height: 1.6,
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
                      'Cancel',
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
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Confirm Delete',
                      style: GoogleFonts.urbanist(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This action cannot be undone. Customers will no longer see or order this item.*',
              style: GoogleFonts.urbanist(
                fontSize: 11,
                color: AppColor.black40,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
