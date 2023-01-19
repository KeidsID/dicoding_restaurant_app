import 'package:flutter/material.dart';

import '../../data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper prefHelper;

  PreferencesProvider({required this.prefHelper}) {
    _getDailyReminderPref();
    _getNotifTestPref();
  }

  bool _isDailyReminderActive = false;
  bool _isNotifTestInProgress = false;

  bool get isDailyReminderActive => _isDailyReminderActive;
  bool get isNotifTestInProgress => _isNotifTestInProgress;

  void _getDailyReminderPref() async {
    _isDailyReminderActive = await prefHelper.isDailyReminderActive;
    notifyListeners();
  }

  void _getNotifTestPref() async {
    _isNotifTestInProgress = await prefHelper.isNotifTestActive;
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    prefHelper.setDailyReminder(value);
    _getDailyReminderPref();
  }

  void enableNotifTest(bool value) {
    prefHelper.setNotificationsTest(value);
    _getNotifTestPref();
  }
}
