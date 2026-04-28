import 'package:go_router/go_router.dart';

import '../screens/login/view/login_view.dart';
import '../screens/main_scaffold/main_scafforld.dart';
import '../screens/otp_view/view/otp_view.dart';
import 'error_widget.dart';

class AppRouter {
  static const String initial = '/';
  static const String food = '/food';
  static const String home = '/home';
  static const String orderDetailView = '/orderDetailView';
  static const String foodDetailView = '/foodDetailView';

  static const String allReview = '/allReview';
  static const String profile = '/profile';
  static const String editProfileView = '/editProfileView';
  static const String couponsView = '/couponsView';
  static const String addCoupons = '/addCoupons';
  static const String paymentHistory = '/paymentHistory';
  static const String specialOffers = '/specialOffers';
  static const String addSpecialOffers = '/addSpecialOffers';
  static const String bannerHome = '/bannerHome';
  static const String categoryHome = '/categoryHome';
  static const String todayOfferHome = '/todayOfferHome';

  static const String addFood = '/addFood';
  static const String foodDetails = '/foodDetails';
  static const String countryPicker = '/countryPicker';
  static const String otpScreen = '/otpScreen';
  static const String sideNav = '/sideNav';
  static const String login = '/login';
  static const String sessionExpired = '/sessionExpired';
  static const String noInternet = '/noInternet';

  static const String ongoingOrders = '/ongoingOrders';
  static const String completedOngoingOrdersView =
      '/completedOngoingOrdersView';
  static const String deliveryBoyHome = '/deliveryBoyHome';
  static const String addDeliveryBoy = '/addDeliveryBoy';
  static const String addTodayOfferView = '/addTodayOfferView';
  static const String locationView = '/locationView';

  static final _router = GoRouter(
    initialLocation: login, // ← start at login
    redirect: (context, state) {
      if (state.matchedLocation == '/') return login;
      return null;
    },
    routes: [
      GoRoute(
        path: login,
        name: login,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: otpScreen,
        name: otpScreen,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: noInternet,
        name: noInternet,
        builder: (context, state) => NoInternetScreen(onPressed: () {}),
      ),

      // ── Uncomment as each screen is built ──
      GoRoute(
        path: sideNav,
        name: sideNav,
        builder: (context, state) => const MainScaffold(),
      ),
      // GoRoute(path: home, name: home, builder: (context, state) => const HomeView()),
      // GoRoute(path: food, name: food, builder: (context, state) => const FoodsView()),
      // GoRoute(path: orderDetailView, name: orderDetailView, builder: (context, state) => const OrderDetailView()),
      // GoRoute(path: foodDetailView, name: foodDetailView, builder: (context, state) => const FoodDetailView()),
      // GoRoute(path: profile, name: profile, builder: (context, state) => const ProfileView()),
      // GoRoute(path: editProfileView, name: editProfileView, builder: (context, state) => const EditProfileView()),
      // GoRoute(path: couponsView, name: couponsView, builder: (context, state) => const CouponsView()),
      // GoRoute(path: addCoupons, name: addCoupons, builder: (context, state) => const AddCouponsView()),
      // GoRoute(path: paymentHistory, name: paymentHistory, builder: (context, state) => const PaymentHistoryView()),
      // GoRoute(path: specialOffers, name: specialOffers, builder: (context, state) => const SpecialOffersView()),
      // GoRoute(path: addSpecialOffers, name: addSpecialOffers, builder: (context, state) => const AddSpecialOffersView()),
      // GoRoute(path: bannerHome, name: bannerHome, builder: (context, state) => const BannerHome()),
      // GoRoute(path: categoryHome, name: categoryHome, builder: (context, state) => const CategoryHome()),
      // GoRoute(path: todayOfferHome, name: todayOfferHome, builder: (context, state) => const TodayOfferHome()),
      // GoRoute(path: countryPicker, name: countryPicker, builder: (context, state) => const CountryPicker()),
      // GoRoute(path: sessionExpired, name: sessionExpired, builder: (context, state) => const SessionExpiredView()),
      // GoRoute(path: ongoingOrders, name: ongoingOrders, builder: (context, state) => OngoingOrdersView(title: state.uri.queryParameters['title'] ?? '')),
      // GoRoute(path: completedOngoingOrdersView, name: completedOngoingOrdersView, builder: (context, state) => const CompletedOngoingOrdersView()),
      // GoRoute(path: deliveryBoyHome, name: deliveryBoyHome, builder: (context, state) => const DeliveryBoyHome()),
      // GoRoute(path: addDeliveryBoy, name: addDeliveryBoy, builder: (context, state) => const AddDeliveryBoy()),
      // GoRoute(path: addTodayOfferView, name: addTodayOfferView, builder: (context, state) => const AddTodayOfferView()),
      // GoRoute(path: locationView, name: locationView, builder: (context, state) => const LocationView()),
    ],
  );

  static GoRouter get router => _router;
}
