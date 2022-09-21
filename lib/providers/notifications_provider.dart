import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../utils/background_service.dart';
import '../utils/date_time_helper.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _isScheduled = false;
  bool _isScheduled2 = false;

  bool get isScheduled => _isScheduled;
  bool get isScheduled2 => _isScheduled2;

  Future<bool> scheduled(bool value) async {
    _isScheduled = value;

    if (_isScheduled) {
      debugPrint('Reminder Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.scheduledCallback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      debugPrint('Reminder Deactived');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }

  Future<bool> afterTenSec(bool value) async {
    _isScheduled2 = value;
    if (_isScheduled2) {
      debugPrint('Notification will spawn after 10 seconds');
      notifyListeners();
      return await AndroidAlarmManager.oneShot(
        const Duration(seconds: 10),
        2,
        BackgroundService.scheduledCallback,
        exact: true,
        wakeup: true,
      );
    } else {
      debugPrint('Notification spawn canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
