import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/assets.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [_TopBanner(), _LogoStrip()],
    );
  }
}

class _TopBanner extends StatelessWidget {
  const _TopBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: AppColor.darkBlue,
        image: DecorationImage(
          image: AssetImage(authHeaderBg),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.storefront_outlined,
            color: Colors.white70,
            size: 16,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'New to our platform? Register now to create your vendor profile and begin receiving orders',
              style: GoogleFonts.urbanist(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoStrip extends StatelessWidget {
  const _LogoStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Image.asset(eatplekLogoWithName, height: 32, fit: BoxFit.contain),
    );
  }
}

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF042E60).withOpacity(0.07),
        image: DecorationImage(
          image: AssetImage(authFooterBg),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
      child: Text(
        'Enter your registered phone number to receive a secure one-time OTP. '
        "If you haven't registered your restaurant yet, please use the sign-up option below.",
        style: GoogleFonts.urbanist(
          fontSize: 12,
          color: AppColor.black60,
          height: 1.65,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
