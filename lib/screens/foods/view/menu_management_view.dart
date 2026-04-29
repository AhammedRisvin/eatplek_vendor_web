import 'package:cached_network_image/cached_network_image.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/add_food/view/add_food_view.dart';
import 'package:eatplek_vendor_web/screens/foods/model/get_food_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../dashboard/view/widget/top_bar.dart';
import '../../food_details/view/food_detail_view.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../view_model/foods_provider.dart';

class MenuManagementView extends StatefulWidget {
  final bool isPrebook;
  const MenuManagementView({super.key, this.isPrebook = false});

  @override
  State<MenuManagementView> createState() => _MenuManagementViewState();
}

class _MenuManagementViewState extends State<MenuManagementView> {
  // Tab indices: 2 = Menu Management, 8 = Special Day Pre-BK
  bool _hasFetched = false;

  int get _kTabIndex => widget.isPrebook ? 8 : 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nav = context.watch<SideNavProvider>();
    if (nav.selectedIndex == _kTabIndex && !_hasFetched) {
      _hasFetched = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<FoodsProvider>().getFoodFn(
          context: context,
          isPrebook: widget.isPrebook,
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
                Row(
                  children: [
                    Text(
                      widget.isPrebook ? 'Special Day Pre-BK' : 'Foods',
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
                          builder: (_) =>
                              AddFoodView(isPrebook: widget.isPrebook),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        widget.isPrebook ? 'Add Pre-BK' : 'Add Food',
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
                const SizedBox(height: 24),
                _FoodGrid(isPrebook: widget.isPrebook),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Food grid ────────────────────────────────────────────────────────────────
class _FoodGrid extends StatelessWidget {
  final bool isPrebook;
  const _FoodGrid({required this.isPrebook});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodsProvider>(
      builder: (context, p, _) {
        if (p.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(60),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final foods = isPrebook
            ? p.getPrebookFoodModel?.data ?? []
            : p.getFoodModel?.data ?? [];

        if (foods.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(60),
            child: Center(
              child: Text(
                isPrebook
                    ? 'No special day items found. Add your first pre-booking item!'
                    : 'No food items found. Add your first item!',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColor.black60,
                ),
              ),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            const cardHeight = 302.0;
            const spacing = 24.0;
            const minCardWidth = 274.0;
            final columns =
                ((constraints.maxWidth + spacing) / (minCardWidth + spacing))
                    .floor()
                    .clamp(1, 4);
            final cardWidth =
                (constraints.maxWidth - (spacing * (columns - 1))) / columns;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: cardWidth / cardHeight,
              ),
              itemCount: foods.length,
              itemBuilder: (context, index) =>
                  _FoodCard(food: foods[index], isPrebook: isPrebook),
            );
          },
        );
      },
    );
  }
}

// ─── Food card ────────────────────────────────────────────────────────────────
class _FoodCard extends StatelessWidget {
  final FoodData food;
  final bool isPrebook;
  const _FoodCard({required this.food, required this.isPrebook});

  String _fmtDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withValues(alpha: 0.10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 118,
                width: double.infinity,
                child: food.foodImage != null && food.foodImage!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: food.foodImage!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _ImgPlaceholder(),
                        errorWidget: (_, __, ___) => _ImgPlaceholder(),
                      )
                    : _ImgPlaceholder(),
              ),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.foodName ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.type ?? '',
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColor.black,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (isPrebook &&
                      food.prebookStartDate != null &&
                      food.prebookEndDate != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.darkBlue.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_fmtDate(food.prebookStartDate!)} – ${_fmtDate(food.prebookEndDate!)}',
                        style: GoogleFonts.urbanist(
                          fontSize: 10,
                          color: AppColor.darkBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        '₹${food.basePrice?.toStringAsFixed(0) ?? '0'}',
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.black,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FoodDetailView(
                              food: food,
                              isPrebook: isPrebook,
                            ),
                          ),
                        ),
                        child: Container(
                          width: 98,
                          height: 32,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColor.darkBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'View Details',
                            style: GoogleFonts.urbanist(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImgPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFFF3F4F6),
    child: const Center(
      child: Icon(Icons.fastfood_outlined, color: Color(0xFFD1D5DB), size: 32),
    ),
  );
}
