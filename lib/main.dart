import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app_project/data/api/api_service.dart';
import 'package:http/http.dart' as http;

import 'my_app.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

final localNotifPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  widgetsBinding;
  ApiService(client: http.Client());

  final notifHelper = NotificationHelper();
  final bgService = BackgroundService();

  bgService.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notifHelper.initNotifications(localNotifPlugin);

  runApp(MyApp());
}
