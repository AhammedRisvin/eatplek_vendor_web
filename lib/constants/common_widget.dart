import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// ─── Text helper ──────────────────────────────────────────────────────────────
Widget text({
  String? text,
  double? size,
  Color? color,
  int? maxLines,
  TextAlign? textAlign,
  FontWeight? fontWeight,
  String? fontFamily,
  TextDecoration? decoration,
  TextOverflow? overFlow,
  double? wordSpacing,
  double? letterSpacing,
  TextDecorationStyle? decorationStyle,
  Color? decorationColor,
}) {
  return Text(
    text ?? '',
    maxLines: maxLines,
    textAlign: textAlign,
    overflow: overFlow,
    style: GoogleFonts.urbanist(
      fontSize: size,
      color: color ?? AppColor.white,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
      wordSpacing: wordSpacing,
      letterSpacing: letterSpacing,
      decorationStyle: decorationStyle,
    ),
  );
}

// ─── Button helper ────────────────────────────────────────────────────────────
Widget button({
  double? height,
  double? width,
  EdgeInsetsGeometry? padding,
  Color? color,
  Color? borderColor,
  BorderRadius? borderRadius,
  String? name,
  Function()? onTap,
  double? fontSize,
  Color? textColor = AppColor.white,
  bool isLoading = false,
  FontWeight? fontWeight,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: padding,
      height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColor.transparent),
        color: color ?? AppColor.darkBlue,
        borderRadius: borderRadius ?? BorderRadius.circular(3),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: AppColor.white,
                strokeWidth: 2,
              )
            : text(
                text: name ?? 'Continue',
                size: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
      ),
    ),
  );
}

// ─── Cached network image helper ──────────────────────────────────────────────
Widget image({
  required String url,
  double? height,
  double? width,
  double radius = 0,
}) {
  return CachedNetworkImage(
    imageUrl: url,
    height: height,
    width: width,
    imageBuilder: (context, imageProvider) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      );
    },
    placeholder: (context, url) => SizedBox(
      height: height,
      width: width,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.darkBlue,
          strokeWidth: 2,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Color(0xFFD1D5DB),
      ),
    ),
  );
}

// ─── Encode / decode params ───────────────────────────────────────────────────
String encodeParams(Map<String, dynamic> params) {
  return base64Url.encode(utf8.encode(jsonEncode(params)));
}

Map<String, dynamic> decodeParams(String token) {
  return jsonDecode(utf8.decode(base64Url.decode(token)));
}

// ─── Text form field ──────────────────────────────────────────────────────────
Widget buildCommonTextFormField({
  bool expands = false,
  Color borderColor = Colors.black12,
  required Color bgColor,
  required String hintText,
  Color hintTextColor = AppColor.black60,
  Widget? prefixIcon,
  Color color = AppColor.black,
  required TextInputType keyboardType,
  required TextInputAction textInputAction,
  String? Function(String?)? validator,
  int? maxLength,
  required TextEditingController? controller,
  EdgeInsetsGeometry? contentPadding = const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  ),
  bool obscureText = false,
  Widget? suffixIcon,
  void Function()? onTap,
  bool enabled = true,
  bool readOnly = false,
  double radius = 8,
  int? minLine,
  int? maxLine,
  FocusNode? focusNode,
  void Function(String)? onChanged,
  required BuildContext context,
}) {
  return TextFormField(
    onChanged: onChanged,
    onTapOutside: (event) => FocusScope.of(context).unfocus(),
    onTap: onTap,
    style: GoogleFonts.urbanist(color: color, fontSize: 14),
    expands: expands,
    keyboardType: keyboardType,
    obscureText: obscureText,
    textInputAction: textInputAction,
    enabled: enabled,
    focusNode: focusNode,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      counterText: '',
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColor.darkBlue, width: 1.5),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      suffixIcon: suffixIcon,
      fillColor: bgColor,
      filled: true,
      hintText: hintText,
      hintStyle: GoogleFonts.urbanist(
        color: AppColor.hintText,
        fontSize: 13,
        fontWeight: FontWeight.w300,
      ),
    ),
    validator: validator,
    maxLength: maxLength,
    controller: controller,
    readOnly: readOnly,
    minLines: minLine,
    maxLines: maxLine,
  );
}

// ─── Toast / Snackbar ─────────────────────────────────────────────────────────
void toast(
  BuildContext context, {
  String? title,
  int duration = 2,
  Color? backgroundColor,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? const Color(0xFF323232),
      duration: Duration(seconds: duration),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      content: Text(
        title ?? 'Something went wrong',
        textAlign: TextAlign.center,
        style: GoogleFonts.urbanist(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
