import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:eatplek_vendor_web/screens/otp_view/view_model/otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpCard extends StatelessWidget {
  const OtpCard({super.key});

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
            child: Consumer<OtpProvider>(
              builder: (context, provider, _) {
                final defaultPinTheme = PinTheme(
                  width: 52,
                  height: 52,
                  textStyle: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColor.darkBlue,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E2E2)),
                  ),
                );

                final focusedPinTheme = defaultPinTheme.copyDecorationWith(
                  border: Border.all(color: AppColor.darkBlue, width: 1.5),
                  color: Colors.white,
                );

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'OTP Verification',
                      style: GoogleFonts.urbanist(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Enter the 6-digit code sent to your phone number.',
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black60,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),

                    Text(
                      '${AppPref.userDialCode} ${AppPref.userPhone}',
                      style: GoogleFonts.urbanist(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Pinput(
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      onChanged: (val) => provider.otp = val,
                      onCompleted: (val) {
                        provider.otp = val;
                        provider.verifyOtp(context: context);
                      },
                    ),
                    const SizedBox(height: 16),

                    Text(
                      provider.timerDisplay,
                      style: GoogleFonts.urbanist(
                        fontSize: 13,
                        color: AppColor.black60,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => provider.verifyOtp(context: context),
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
                                'Verify',
                                style: GoogleFonts.urbanist(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive the OTP? ",
                          style: GoogleFonts.urbanist(
                            fontSize: 13,
                            color: AppColor.black60,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        GestureDetector(
                          onTap: provider.canResend
                              ? () => provider.resendOtp(context: context)
                              : null,
                          child: Text(
                            'Resend',
                            style: GoogleFonts.urbanist(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: provider.canResend
                                  ? AppColor.darkBlue
                                  : AppColor.black40,
                            ),
                          ),
                        ),
                      ],
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
