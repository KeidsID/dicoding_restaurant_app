import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';

import 'my_app.dart';
import 'firebase_options.dart';
import 'data/api/api_service.dart';
import 'utils/background_service.dart';
import 'utils/notification_helper.dart';

final localNotifPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  ApiService(client: http.Client());
  widgetsBinding;

  final notifHelper = NotificationHelper();
  final bgService = BackgroundService();

  bgService.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }

  await notifHelper.initNotifications(localNotifPlugin);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}
