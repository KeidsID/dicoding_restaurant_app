import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../../utils/background_service.dart';
import '../../utils/date_time_helper.dart';

class NotificationsProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

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
}
