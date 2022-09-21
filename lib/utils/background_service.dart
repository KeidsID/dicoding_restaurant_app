import 'dart:math';
import 'dart:ui';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';

import '../main.dart';
import '../utils/notification_helper.dart';
import '../data/api/api_service.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> scheduledCallback() async {
    debugPrint('Alarm fired!');
    final notificationHelper = NotificationHelper();
    var getData = await ApiService.getRestaurantList();
    var restaurants = getData.restaurants;

    var randomIndex = Random().nextInt(restaurants.length);
    var randomizedRestaurant = restaurants[randomIndex];

    await notificationHelper.showNotification(
      localNotifPlugin,
      randomizedRestaurant,
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  static Future<void> notifTestCallback() async {
    debugPrint('Alarm fired!');
    final notificationHelper = NotificationHelper();
    var getData = await ApiService.getRestaurantList();
    var restaurants = getData.restaurants;

    await notificationHelper.showNotification(
      localNotifPlugin,
      restaurants[0],
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
