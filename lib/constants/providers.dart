import 'package:eatplek_vendor_web/screens/otp_view/view_model/otp_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../screens/add_food/view_model/add_food_provider.dart';
import '../screens/banners/view_model.dart/banner_notifylistener.dart';
import '../screens/category/view_model/category_provider.dart';
import '../screens/dashboard/view_model/dashboard_provider.dart';
import '../screens/delivery_boy/view_model/delivery_boy_provider.dart';
import '../screens/earnings/view_model/revenue_notify_listner.dart';
import '../screens/food_details/view_model/food_detail_provider.dart';
import '../screens/foods/view_model/foods_provider.dart';
import '../screens/login/view_model/auth_provider.dart';
import '../screens/orders/view_model/order_provider.dart';
import '../screens/profile/view_model/profile_provider.dart';
import '../screens/side_nav/view_model/side_nav_provider.dart';
import '../screens/today_offer/view_model/today_offer_provider.dart';
import 'upload_image/view_model/upload_image_provider.dart';

class Providers {
  final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => OtpProvider()),
    ChangeNotifierProvider(create: (context) => SideNavProvider()),
    ChangeNotifierProvider(create: (context) => DashboardProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
    ChangeNotifierProvider(create: (context) => FoodsProvider()),
    ChangeNotifierProvider(create: (context) => FoodDetailsProvider()),
    ChangeNotifierProvider(create: (context) => AddFoodProvider()),
    ChangeNotifierProvider(create: (context) => UploadImageProvider()),
    ChangeNotifierProvider(create: (context) => RevenueNotifylistner()),
    ChangeNotifierProvider(create: (context) => AddTodayOfferProvider()),
    ChangeNotifierProvider(create: (context) => BannerNotifiylistener()),
    ChangeNotifierProvider(create: (context) => CategoryProvider()),
    ChangeNotifierProvider(create: (context) => DeliveryBoyProvider()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),

    // ── Uncomment as each screen is built ──

    // ChangeNotifierProvider(create: (context) => HomeProvider()),
    // ChangeNotifierProvider(create: (context) => BottomBarProvider()),
    // ChangeNotifierProvider(create: (context) => OrderProvider()),
    // ChangeNotifierProvider(create: (context) => FoodsProvider()),
    // ChangeNotifierProvider(create: (context) => AddFoodProvider()),
    // ChangeNotifierProvider(create: (context) => CountryController()),
    // ChangeNotifierProvider(create: (context) => AddSpecialOfferProvider()),
    // ChangeNotifierProvider(create: (context) => SpecialOfferProvider()),
    // ChangeNotifierProvider(create: (context) => ProfileProvider()),
    // ChangeNotifierProvider(create: (context) => EditProfileProvider()),
    // ChangeNotifierProvider(create: (context) => BannerNotifiylistener()),
    // ChangeNotifierProvider(create: (context) => CouponNotifylistener()),
    // ChangeNotifierProvider(create: (context) => PaymentHistoryNotifier()),
    // ChangeNotifierProvider(create: (context) => RevenueNotifylistner()),
    // ChangeNotifierProvider(create: (context) => FoodDetailsProvider()),
    // ChangeNotifierProvider(create: (context) => CategoryProvider()),
    // ChangeNotifierProvider(create: (context) => UploadImageProvider()),
    // ChangeNotifierProvider(create: (context) => AddTodayOfferProvider()),
    // ChangeNotifierProvider(create: (context) => OrderDetailNotifier()),
  ];
}
