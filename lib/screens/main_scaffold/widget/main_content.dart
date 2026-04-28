import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../banners/view/banner_view.dart';
import '../../category/view/category_view.dart';
import '../../dashboard/view/dashboard_view.dart';
import '../../delivery_boy/view/delivery_boy_view.dart';
import '../../earnings/view/payments_earnings_view.dart.dart';
import '../../foods/view/menu_management_view.dart';
import '../../orders/view/orders_management_view.dart';
import '../../profile/view/profile_view.dart';
import '../../side_nav/view_model/side_nav_provider.dart';
import '../../today_offer/view/today_offers_view.dart';

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SideNavProvider>(
      builder: (context, nav, _) {
        return IndexedStack(
          index: nav.selectedIndex,
          children: const [
            DashboardView(),
            OrdersManagementView(),
            MenuManagementView(),
            PaymentsEarningsView(),
            TodayOffersView(),
            BannerView(),
            DeliveryBoyView(),
            CategoryView(),
            MenuManagementView(isPrebook: true),
            ProfileSettingsView(),
          ],
        );
      },
    );
  }
}
