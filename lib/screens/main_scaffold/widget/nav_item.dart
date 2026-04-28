import 'package:eatplek_vendor_web/constants/assets.dart';
import 'package:eatplek_vendor_web/constants/colors.dart';
import 'package:eatplek_vendor_web/constants/prefferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants/router.dart';
import '../../side_nav/view_model/side_nav_provider.dart';

class SideNav extends StatelessWidget {
  const SideNav({super.key});

  Widget _navItem({
    required BuildContext context,
    required String tappedSvg,
    required String untappedSvg,
    required String label,
    required int index,
    required bool selected,
  }) {
    return GestureDetector(
      onTap: () => context.read<SideNavProvider>().selectTab(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColor.darkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              selected ? tappedSvg : untappedSvg,
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? Colors.white : const Color(0xFF64748B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutTile(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppPref.isSignedIn = false;
        AppPref.userToken = '';
        context.goNamed(AppRouter.login);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(logoutIcon, width: 18, height: 18),
            const SizedBox(width: 10),
            Text(
              'Logout',
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFE51A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SideNavProvider>(
      builder: (context, nav, _) {
        return Container(
          width: 200,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Image.asset(
                  eatplekLogoWithName,
                  height: 32,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 8),

              // Nav items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _navItem(
                      context: context,
                      tappedSvg: dashBoardTapped,
                      untappedSvg: dashBoarduntapped,
                      label: 'Dashboard',
                      index: 0,
                      selected: nav.selectedIndex == 0,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: ordersTapped,
                      untappedSvg: ordersUntapped,
                      label: 'Orders Management',
                      index: 1,
                      selected: nav.selectedIndex == 1,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: foodTapped,
                      untappedSvg: foodUntapped,
                      label: 'Menu Management',
                      index: 2,
                      selected: nav.selectedIndex == 2,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: paymentTapped,
                      untappedSvg: paymentUntapped,
                      label: 'Payments & Earnings',
                      index: 3,
                      selected: nav.selectedIndex == 3,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: todayOfferTapped,
                      untappedSvg: todayOfferUntapped,
                      label: "Today's Offers",
                      index: 4,
                      selected: nav.selectedIndex == 4,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: bannerTapped,
                      untappedSvg: bannerUntapped,
                      label: 'Banner',
                      index: 5,
                      selected: nav.selectedIndex == 5,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: deliveryBoyTapped,
                      untappedSvg: deliveryBoyUntapped,
                      label: 'Delivery Boy',
                      index: 6,
                      selected: nav.selectedIndex == 6,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: categoryTapped,
                      untappedSvg: categoryUntapped,
                      label: 'Category',
                      index: 7,
                      selected: nav.selectedIndex == 7,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: spDayTapped,
                      untappedSvg: spDayUntapped,
                      label: 'Special Day Pre-BK',
                      index: 8,
                      selected: nav.selectedIndex == 8,
                    ),
                    _navItem(
                      context: context,
                      tappedSvg: profileTapped,
                      untappedSvg: profileUntapped,
                      label: 'Profile & Settings',
                      index: 9,
                      selected: nav.selectedIndex == 9,
                    ),
                  ],
                ),
              ),

              // Logout
              const Divider(height: 1, thickness: 0.5),
              Padding(
                padding: const EdgeInsets.all(8),
                child: _logoutTile(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
