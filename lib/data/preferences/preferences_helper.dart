import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const dailyReminder = "DAILY_REMINDER";
  static const notificationsTest = "NOTIFICATIONS_TEST";

  Future<bool> get isDailyReminderActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(dailyReminder) ?? false;
  }

  void setDailyReminder(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(dailyReminder, value);
  }

  Future<bool> get isNotifTestActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(notificationsTest) ?? false;
  }

  void setNotificationsTest(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(notificationsTest, value);
  }
}
