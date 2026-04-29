import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/food_details/model/food_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../view_model/add_food_provider.dart';
import 'widget/add_food_actions.dart';
import 'widget/add_food_addons_section.dart';
import 'widget/add_food_basic_section.dart';
import 'widget/add_food_description_section.dart';
import 'widget/add_food_order_types_section.dart';
import 'widget/add_food_prebook_section.dart';
import 'widget/add_food_pricing_section.dart';
import 'widget/add_food_quantity_section.dart';

class AddFoodView extends StatefulWidget {
  final Data? foodData;
  final bool isPrebook;

  const AddFoodView({super.key, this.foodData, this.isPrebook = false});

  @override
  State<AddFoodView> createState() => _AddFoodViewState();
}

class _AddFoodViewState extends State<AddFoodView> {
  bool get isEdit => widget.foodData != null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AddFoodProvider>();
      provider.clearAddFoodControllersFn();
      provider.setAddPreBook(widget.isPrebook);
      if (isEdit) {
        provider.setEditControllers(
          isEdit: true,
          context: context,
          foodData: widget.foodData,
        );
      }
      provider.getFoodCategoriesFn(context, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = isEdit
        ? (widget.isPrebook ? 'Edit Pre-BK Item' : 'Edit Food')
        : (widget.isPrebook ? 'Add Pre-BK Item' : 'Add Food');

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 36),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AddFoodHeader(title: title),
                const SizedBox(height: 18),
                const AddFoodBasicSection(),
                const SizedBox(height: 22),
                const AddFoodPricingSection(),
                if (widget.isPrebook) ...[
                  const SizedBox(height: 22),
                  const AddFoodPrebookSection(),
                ],
                const SizedBox(height: 22),
                const AddFoodDescriptionSection(),
                const SizedBox(height: 22),
                const AddFoodOrderTypesSection(),
                Consumer<AddFoodProvider>(
                  builder: (context, provider, _) {
                    if (!provider.hasQuantityOptions) {
                      return const SizedBox.shrink();
                    }
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 22),
                        AddFoodQuantitySection(),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                const AddFoodAddOnsSection(),
                const SizedBox(height: 28),
                AddFoodActions(isEdit: isEdit, isPrebook: widget.isPrebook),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddFoodHeader extends StatelessWidget {
  final String title;

  const _AddFoodHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(19),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColor.darkBlue,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }
}
