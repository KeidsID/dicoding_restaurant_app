import 'package:flutter/material.dart';

import '../data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyReminderPref();
    _getNotifTestPref();
  }

  bool _isDailyReminderActive = false;
  bool _isNotifTestInProgress = false;

  bool get isDailyReminderActive => _isDailyReminderActive;
  bool get isNotifTestInProgress => _isNotifTestInProgress;

  void _getDailyReminderPref() async {
    _isDailyReminderActive = await preferencesHelper.isDailyReminderActive;
    notifyListeners();
  }

  void _getNotifTestPref() async {
    _isNotifTestInProgress = await preferencesHelper.isNotifTestActive;
    notifyListeners();
  }

  void enableDailyReminder(bool value) {
    preferencesHelper.setDailyReminder(value);
    _getDailyReminderPref();
  }

  void enableNotifTest(bool value) {
    preferencesHelper.setNotificationsTest(value);
    _getNotifTestPref();
  }
}
