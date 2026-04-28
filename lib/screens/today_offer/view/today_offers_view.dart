// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/common_widget.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/screens/foods/model/get_food_model.dart';
import 'package:eatplek_vendor_web/screens/today_offer/model/today_offer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/model/all_orders_model.dart';
import '../../dashboard/view/widget/top_bar.dart';
import '../view_model/today_offer_provider.dart';

// ════════════════════════════════════════════════════════════════════════════
//  LISTING SCREEN
// ════════════════════════════════════════════════════════════════════════════

class TodayOffersView extends StatefulWidget {
  const TodayOffersView({super.key});

  @override
  State<TodayOffersView> createState() => _TodayOffersViewState();
}

class _TodayOffersViewState extends State<TodayOffersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddTodayOfferProvider>().getTodayOfferFn(
        context: context,
        page: 1,
      );
    });
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
                      'Todays Offer',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AddTodayOfferView(),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Add Offer',
                        style: GoogleFonts.urbanist(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _OffersTable(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Offers table ─────────────────────────────────────────────────────────────
class _OffersTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        final offers = p.getTodayOfferModel?.data ?? [];
        final pagination = p.getTodayOfferModel?.pagination;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              // Table header
              Container(
                decoration: BoxDecoration(
                  color: AppColor.darkBlue.withOpacity(.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: const Row(
                  children: [
                    _HeaderCell('Food Item', flex: 4),
                    _HeaderCell('Discount Value', flex: 2),
                    _HeaderCell('Active Days', flex: 3),
                    _HeaderCell('Start-End Time', flex: 3),
                    _HeaderCell('Status', flex: 2),
                    _HeaderCell('Action', flex: 2),
                  ],
                ),
              ),

              // Body
              if (p.isGetLoading)
                const Padding(
                  padding: EdgeInsets.all(60),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (offers.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(60),
                  child: Center(
                    child: Text(
                      'No offers found',
                      style: GoogleFonts.urbanist(
                        color: AppColor.black60,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                ...offers.map((offer) => _OfferRow(offer: offer)),

              // Pagination
              if (pagination != null) _PaginationBar(pagination: pagination),
            ],
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColor.darkBlue,
        ),
      ),
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
          // Discount value — not in model, show placeholder
          Expanded(
            flex: 2,
            child: Text(
              '--',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          // Active days — not in model
          Expanded(
            flex: 3,
            child: Text(
              '--',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          // Start-End time — not in model
          Expanded(
            flex: 3,
            child: Text(
              '--',
              style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
            ),
          ),
          // Status
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
          // Actions — edit & delete
          Expanded(
            flex: 2,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: navigate to edit offer
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
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: wire delete API
              toast(
                context,
                title: 'Offer deleted',
                backgroundColor: AppColor.darkBlue,
              );
            },
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

class _PaginationBar extends StatelessWidget {
  final Pagination pagination;
  const _PaginationBar({required this.pagination});

  @override
  Widget build(BuildContext context) {
    final page = pagination.currentPage ?? 1;
    final limit = pagination.limit ?? 8;
    final total = pagination.totalCount ?? 0;
    final totalPages = pagination.totalPages ?? 1;
    final start = (page - 1) * limit + 1;
    final end = (page * limit).clamp(0, total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Row(
        children: [
          Text(
            '$start – $end of $total items',
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black60),
          ),
          const Spacer(),
          _PageBtn(
            label: 'Previous',
            enabled: page > 1,
            onTap: () => context.read<AddTodayOfferProvider>().getTodayOfferFn(
              context: context,
              page: page - 1,
            ),
          ),
          const SizedBox(width: 8),
          _PageBtn(
            label: 'Next',
            enabled: page < totalPages,
            onTap: () => context.read<AddTodayOfferProvider>().getTodayOfferFn(
              context: context,
              page: page + 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  const _PageBtn({
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xFFF5F6FA),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: enabled ? AppColor.black : AppColor.black40,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  ADD OFFER SCREEN
// ════════════════════════════════════════════════════════════════════════════

class AddTodayOfferView extends StatefulWidget {
  const AddTodayOfferView({super.key});

  @override
  State<AddTodayOfferView> createState() => _AddTodayOfferViewState();
}

class _AddTodayOfferViewState extends State<AddTodayOfferView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AddTodayOfferProvider>();
      p.clearControllers();
      p.getFoodForOfferFn(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _AddOfferTopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Offer',
                      style: GoogleFonts.urbanist(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColor.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _SelectFoodSection(),
                    const SizedBox(height: 24),
                    _DiscountTypeSection(),
                    const SizedBox(height: 24),
                    _ActiveDaysSection(),
                    const SizedBox(height: 24),
                    _OfferDurationSection(),
                    const SizedBox(height: 32),
                    _SaveButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddOfferTopBar extends StatelessWidget {
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

// ─── Section title helper ─────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColor.darkBlue,
        ),
      ),
    );
  }
}

// ─── Select Food ──────────────────────────────────────────────────────────────
class _SelectFoodSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        final foods = p.getFoodModel?.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Select Food Item'),
            // Custom dropdown with food image + name
            _CustomDropdown<FoodData>(
              hint: 'Select',
              selectedDisplay: p.foodData.foodName,
              isLoading: p.isLoading,
              items: foods,
              itemBuilder: (food) => Row(
                children: [
                  if (food.foodImage != null && food.foodImage!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: food.foodImage!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          width: 32,
                          height: 32,
                          color: const Color(0xFFF3F4F6),
                          child: const Icon(
                            Icons.fastfood_outlined,
                            size: 16,
                            color: Color(0xFFD1D5DB),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.foodName ?? '',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          color: AppColor.black,
                        ),
                      ),
                      Text(
                        food.type ?? '',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          color: AppColor.black60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onSelected: (food) => p.selectFoodFn(food),
            ),
          ],
        );
      },
    );
  }
}

// ─── Discount type ────────────────────────────────────────────────────────────
class _DiscountTypeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Discount Type'),
            Row(
              children: [
                // Discount type dropdown
                Expanded(
                  child: _StyledDropdown(
                    value: p.selectDiscountController.text.isEmpty
                        ? null
                        : p.selectDiscountController.text,
                    hint: 'Percentage (%)',
                    items: p.typeList,
                    onChanged: (val) {
                      if (val != null) p.selectTypeFn(val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Discount value
                Expanded(
                  child: _StyledTextField(
                    controller: p.discountController,
                    hint: '',
                    suffix: p.isPercent ? '%' : '₹',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            // Labels
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Select',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      color: AppColor.black60,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Discount Value',
                    style: GoogleFonts.urbanist(
                      fontSize: 11,
                      color: AppColor.black60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// ─── Active Days ──────────────────────────────────────────────────────────────
class _ActiveDaysSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Active Days'),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: p.activeDays.keys.map((day) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: p.activeDays[day] ?? false,
                      activeColor: AppColor.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) => p.toggleDay(day, val),
                    ),
                    Text(
                      day,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

// ─── Offer Duration ───────────────────────────────────────────────────────────
class _OfferDurationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle('Offer Duration'),
            Row(
              children: [
                // Start Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start Time',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _pickTime(context, p, isStart: true),
                        child: _TimeField(controller: p.startTimeController),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // End Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'End Time',
                        style: GoogleFonts.urbanist(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _pickTime(context, p, isStart: false),
                        child: _TimeField(controller: p.endTimeController),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    AddTodayOfferProvider p, {
    required bool isStart,
  }) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked == null) return;
    final now = DateTime.now();
    final dt = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );
    if (isStart) {
      p.setingStartTimeFn(timeDynamic: dt);
    } else {
      p.setingEndTimeFn(dateTimeDynamic: dt);
    }
  }
}

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  const _TimeField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              controller.text.isEmpty ? 'Select' : controller.text,
              style: GoogleFonts.urbanist(
                fontSize: 13,
                color: controller.text.isEmpty
                    ? AppColor.hintText
                    : AppColor.black,
              ),
            ),
          ),
          const Icon(
            Icons.access_time_rounded,
            size: 18,
            color: AppColor.black40,
          ),
        ],
      ),
    );
  }
}

// ─── Save button ──────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AddTodayOfferProvider>(
      builder: (context, p, _) {
        return SizedBox(
          height: 50,
          width: 160,
          child: ElevatedButton(
            onPressed: p.isOfferAdding
                ? null
                : () => p.addTodayOfferFn(context: context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.darkBlue,
              disabledBackgroundColor: AppColor.darkBlue.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: p.isOfferAdding
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Save Offer',
                    style: GoogleFonts.urbanist(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

// ─── Reusable widgets ─────────────────────────────────────────────────────────

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? suffix;
  final TextInputType keyboardType;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColor.hintText),
        suffixText: suffix,
        suffixStyle: GoogleFonts.urbanist(
          fontSize: 13,
          color: AppColor.black60,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColor.darkBlue, width: 1.5),
        ),
      ),
    );
  }
}

class _StyledDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final void Function(String?) onChanged;

  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.hintText),
          ),
          style: GoogleFonts.urbanist(fontSize: 13, color: AppColor.black),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// Generic custom dropdown with overlay
class _CustomDropdown<T> extends StatefulWidget {
  final String hint;
  final String? selectedDisplay;
  final bool isLoading;
  final List<T> items;
  final Widget Function(T) itemBuilder;
  final void Function(T) onSelected;

  const _CustomDropdown({
    required this.hint,
    required this.selectedDisplay,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.onSelected,
  });

  @override
  State<_CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<_CustomDropdown<T>> {
  final _key = GlobalKey();
  OverlayEntry? _overlay;
  bool _open = false;

  void _toggleDropdown() {
    if (_open) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    _overlay = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (_, i) {
                      final item = widget.items[i];
                      return GestureDetector(
                        onTap: () {
                          widget.onSelected(item);
                          _closeDropdown();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFF1F5F9)),
                            ),
                          ),
                          child: widget.itemBuilder(item),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlay!);
    setState(() => _open = true);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: _toggleDropdown,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: _open ? AppColor.darkBlue : const Color(0xFFE5E7EB),
            width: _open ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: widget.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.selectedDisplay ?? widget.hint,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: widget.selectedDisplay != null
                            ? AppColor.black
                            : AppColor.hintText,
                      ),
                    ),
            ),
            Icon(
              _open
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: AppColor.black40,
            ),
          ],
        ),
      ),
    );
  }
}
