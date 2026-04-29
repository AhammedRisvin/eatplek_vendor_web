import 'dart:typed_data';

import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFoodUploadBox extends StatelessWidget {
  final String imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onTap;
  final double height;
  final String helperText;

  const AddFoodUploadBox({
    super.key,
    required this.imageUrl,
    this.imageBytes,
    required this.onTap,
    this.height = 208,
    this.helperText = 'Add Food Image',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: DottedBorder(
        color: AppColor.darkBlue,
        dashPattern: const [3, 2],
        strokeWidth: 1,
        borderType: BorderType.RRect,
        radius: const Radius.circular(2),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF4F8),
            borderRadius: BorderRadius.circular(2),
          ),
          child: imageBytes != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.memory(imageBytes!, fit: BoxFit.cover),
                )
              : imageUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _emptyState(),
                  ),
                )
              : _emptyState(),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          color: AppColor.darkBlue,
          size: 32,
        ),
        const SizedBox(height: 8),
        Text(
          'Drop file or browse',
          style: GoogleFonts.urbanist(fontSize: 12, color: AppColor.black),
        ),
        Text(
          helperText,
          style: GoogleFonts.urbanist(fontSize: 10, color: AppColor.black40),
        ),
        const SizedBox(height: 10),
        Container(
          width: 92,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.darkBlue,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Browse Files',
            style: GoogleFonts.urbanist(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
