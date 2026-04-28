class Urls {
  static String baseUrl = 'https://eatplek-server-dev.onrender.com/api/';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static String loginUrl = '${baseUrl}vendor-auth/send-otp';
  static String verifyOtp = '${baseUrl}vendor-auth/verify-otp';

  // ── Dashboard ─────────────────────────────────────────────────────────────
  static String getHomeData = '${baseUrl}vendor/orders';
  static String putAcceptBookingsUrl = '${baseUrl}vendor/acceptBookings';
  static String accpetedFoodStatusUpdateUrl = '${baseUrl}vendor/orders';

  // ── Orders ────────────────────────────────────────────────────────────────
  static String getOrders = '${baseUrl}vendor/getMyAcceptedBookings';
  static String getCompletedOrders = '${baseUrl}vendor/getMyCompletedBookings';
  static String updateOrderStatus = '${baseUrl}vendor/updateOrderStatus';

  // ── Foods ─────────────────────────────────────────────────────────────────
  static String getFoodUrl = '${baseUrl}foods?';
  static String getFoodDetailUrl = '${baseUrl}foods/';
  static String addFoodUrl = '${baseUrl}foods';
  static String updateFoodUrl = '${baseUrl}vendor/updateFood/';
  static String deleteFoodUrl = '${baseUrl}vendor/deleteFood/';
  static String searchFoodUrl = '${baseUrl}vendor/searchFood?search=';

  // ── Categories ────────────────────────────────────────────────────────────
  static String getFoodCategoryUrl = '${baseUrl}food-categories';
  static String addCategoryUrl = '${baseUrl}food-categories';
  static String deleteCategoryUrl = '${baseUrl}food-categories/';

  // ── Special Offers ────────────────────────────────────────────────────────
  static String addSpecialOfferUrl = '${baseUrl}vendor/addSpecialOffer';
  static String getSpecialFoodUrl = '${baseUrl}vendor/getSpecialOffer';
  static String deleteSpecialFoodUrl =
      '${baseUrl}vendor/deleteSpecialOffer?specialOfferID=';

  // ── Pre-Booking ───────────────────────────────────────────────────────────
  static String getPreBookingUrl = '${baseUrl}vendor/getPreBooking';
  static String getPreBookingOrderUrl = '${baseUrl}vendor/getPreBookingOrders';
  static String addPreBookingUrl = '${baseUrl}vendor/addPreBooking';
  static String updatePreBookingUrl = '${baseUrl}vendor/updatePreBooking';
  static String deletePreBookingUrl = '${baseUrl}vendor/deletePreBooking';

  // ── Banners ───────────────────────────────────────────────────────────────
  static String getBannersUrl = '${baseUrl}banners';
  static String deleteBannerUrl = '${baseUrl}vendor/deleteBanner';

  // ── Profile ───────────────────────────────────────────────────────────────
  static String getVendorProfileUrl = '${baseUrl}vendors/';
  static String editProfileUrl = '${baseUrl}vendor/vendorProfileEdit';

  // ── Delivery Boys ─────────────────────────────────────────────────────────
  static String getDeliveryBoysUrl = '${baseUrl}vendor/delivery-boys';
  static String addDeliveryBoyUrl = '${baseUrl}vendor/delivery-boys';
  static String deleteDeliveryBoyUrl = '${baseUrl}vendor/delivery-boys/';

  // ── Earnings / Revenue ────────────────────────────────────────────────────
  static String getRevenueUrl = '${baseUrl}vendor/getDashboardData';
  static String getPaymentHistoryUrl = '${baseUrl}vendor/getPaymentHistory';

  // ── Today Offers ──────────────────────────────────────────────────────────
  // Uses getFoodUrl with isPrebook=true — no separate URL needed

  // ── Coupons ───────────────────────────────────────────────────────────────
  static String getcouponUrl = '${baseUrl}vendor/getCoupons';
  static String addcouponUrl = '${baseUrl}vendor/addCoupon';
  static String editCouponUrl = '${baseUrl}vendor/updateCoupon';
  static String deletecouponUrl = '${baseUrl}vendor/deleteCoupon?couponId=';

  // ── Notifications ─────────────────────────────────────────────────────────
  static String getnotificationUrl =
      '${baseUrl}vendor/getVendorAppNotification';
  static String sendNotificationToUser =
      '${baseUrl}vendor/sendNotificationToUser';

  // ── Reviews ───────────────────────────────────────────────────────────────
  static String getReviewUrl = '${baseUrl}vendor/getReviews';
}
