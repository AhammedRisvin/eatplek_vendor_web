import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/assets.dart';

class StatsRow extends StatelessWidget {
  final List<(String label, String value)> stats;
  final bool isLoading;

  const StatsRow({super.key, required this.stats, this.isLoading = false});

  static final _styles = [
    (
      bg: const Color(0xFFEDE9FE),
      iconColor: const Color(0xFF7C3AED),
      image: commonFirstWidgetIcon,
    ),
    (
      bg: const Color(0xFFFFF7E6),
      iconColor: const Color(0xFFD97706),
      image: commonSecondWidgetIcon,
    ),
    (
      bg: const Color(0xFFFFEDE9),
      iconColor: const Color(0xFFEF4444),
      image: commonThirdWidgetIcon,
    ),
    (
      bg: const Color(0xFFE6F4EA),
      iconColor: const Color(0xFF16A34A),
      image: commonFourthWidgetIcon,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 16),
          _buildStatCard(stats[i], _styles[i]),
        ],
      ],
    );
  }

  Widget _buildStatCard(
    (String label, String value) data,
    ({Color bg, Color iconColor, String image}) style,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF979797).withOpacity(0.6),
            width: 0.2,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 54,
              color: const Color(0xff000000).withOpacity(0.05),
              offset: const Offset(6, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.$1,
                    style: GoogleFonts.urbanist(
                      fontSize: 12,
                      color: AppColor.black60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  isLoading
                      ? Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : Text(
                          data.$2,
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
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
                color: style.bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(style.image, color: style.iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
