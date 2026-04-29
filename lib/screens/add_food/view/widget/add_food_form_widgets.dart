import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFoodSectionTitle extends StatelessWidget {
  final String text;
  const AddFoodSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColor.darkBlue,
      ),
    );
  }
}

class AddFoodFieldLabel extends StatelessWidget {
  final String text;
  const AddFoodFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColor.black,
      ),
    );
  }
}

class AddFoodTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const AddFoodTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.urbanist(fontSize: 12, color: AppColor.hintText),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        filled: true,
        fillColor: Colors.white,
        border: _border(const Color(0xFFE5E7EB)),
        enabledBorder: _border(const Color(0xFFE5E7EB)),
        focusedBorder: _border(AppColor.darkBlue, width: 1.2),
      ),
    );

    if (maxLines > 1) return field;
    return SizedBox(height: 42, child: field);
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class AddFoodDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AddFoodDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.hintText),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColor.black40,
          ),
          style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class AddFoodCheckbox extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AddFoodCheckbox({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: selected ? AppColor.darkBlue : Colors.white,
              border: Border.all(
                color: selected ? AppColor.darkBlue : const Color(0xFFD1D5DB),
              ),
              borderRadius: BorderRadius.circular(3),
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 11)
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
          ),
        ],
      ),
    );
  }
}

class AddFoodRadioPill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const AddFoodRadioPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColor.darkBlue : const Color(0xFFD1D5DB),
                width: 1.4,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColor.darkBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
          ),
        ],
      ),
    );
  }
}

class AddFoodMiniButton extends StatelessWidget {
  final VoidCallback onTap;
  const AddFoodMiniButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColor.darkBlue,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add',
              style: GoogleFonts.urbanist(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.add, color: Colors.white, size: 12),
          ],
        ),
      ),
    );
  }
}
