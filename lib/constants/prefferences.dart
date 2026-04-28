import 'package:shared_preferences/shared_preferences.dart';

class AppPref {
  static const String _userToken = 'accessToken';
  static const String _isSignedIn = 'isSignedIn';
  static const String _fcmToken = 'fcmToken';
  static const String _country = 'country';
  static const String _userName = 'userName';
  static const String _userProfileImage = 'userProfileImage';
  static const String _userId = 'userId';
  static const String _deviceOs = 'deviceOs';
  static const String _deviceName = 'deviceName';
  static const String _userPhone = 'userPhone';
  static const String _userDialCode = 'userDialCode';

  static late SharedPreferences _preference;

  static Future<void> init() async {
    _preference = await SharedPreferences.getInstance();
  }

  void reloadPreference() async {
    await _preference.reload();
  }

  Future<void> clear() async {
    await _preference.clear();
  }

  // User Token
  static String get userToken => _preference.getString(_userToken) ?? '';
  static set userToken(String value) =>
      _preference.setString(_userToken, value);

  // User Is SignedIn or not
  static bool get isSignedIn => _preference.getBool(_isSignedIn) ?? false;
  static set isSignedIn(bool value) => _preference.setBool(_isSignedIn, value);

  // FCM Token
  static String get fcmToken => _preference.getString(_fcmToken) ?? '';
  static set fcmToken(String value) => _preference.setString(_fcmToken, value);

  // Country
  static String get country => _preference.getString(_country) ?? '';
  static set country(String value) => _preference.setString(_country, value);

  // User Name
  static String get userName => _preference.getString(_userName) ?? '';
  static set userName(String value) => _preference.setString(_userName, value);

  // User Profile Image
  static String get userProfileImage =>
      _preference.getString(_userProfileImage) ?? '';
  static set userProfileImage(String value) =>
      _preference.setString(_userProfileImage, value);

  // User Id
  static String get userId => _preference.getString(_userId) ?? '';
  static set userId(String value) => _preference.setString(_userId, value);

  // Device Os (kept for API compatibility, empty on web)
  static String get deviceOs => _preference.getString(_deviceOs) ?? '';
  static set deviceOs(String value) => _preference.setString(_deviceOs, value);

  // Device Name (kept for API compatibility, empty on web)
  static String get deviceName => _preference.getString(_deviceName) ?? '';
  static set deviceName(String value) =>
      _preference.setString(_deviceName, value);

  // User Phone — stored after login to pass to OTP screen
  static String get userPhone => _preference.getString(_userPhone) ?? '';
  static set userPhone(String value) =>
      _preference.setString(_userPhone, value);

  // User Dial Code — stored after login to pass to OTP screen
  static String get userDialCode =>
      _preference.getString(_userDialCode) ?? '+91';
  static set userDialCode(String value) =>
      _preference.setString(_userDialCode, value);
}
