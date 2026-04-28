import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/screens/login/view_model/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.38).clamp(340.0, 460.0);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F2F2),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 24,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Consumer<AuthProvider>(
              builder: (context, provider, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      'Welcome Back, Vendor!',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColor.darkBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),

                    // Subtitle
                    Text(
                      'Access your restaurant dashboard and manage your\norders, menu, and earnings from one place.',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black60,
                        height: 1.65,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Enter Your Phone Number',
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E2E2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Color(0xFFE2E2E2)),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  provider.dialCode,
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.black,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 20,
                                  color: AppColor.black40,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: provider.phoneController,
                              keyboardType: TextInputType.phone,
                              style: GoogleFonts.urbanist(
                                fontSize: 14,
                                color: AppColor.black,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                hintStyle: GoogleFonts.urbanist(
                                  color: AppColor.hintText,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.signInFn(context: context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.darkBlue,
                          disabledBackgroundColor: AppColor.darkBlue
                              .withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
