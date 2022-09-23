import 'dart:math';
import 'dart:ui';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';

import '../data/model/from_api/restaurant.dart';
import '../main.dart';
import '../data/api/api_service.dart';
import '../data/model/from_api/restaurant_list.dart';
import '../utils/notification_helper.dart';

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
    var notificationHelper = NotificationHelper();
    RestaurantList getData = await ApiService.getRestaurantList();
    List<Restaurant> restaurants = getData.restaurants;

    int randomIndex = Random().nextInt(restaurants.length);
    Restaurant randomizedRestaurant = restaurants[randomIndex];

    await notificationHelper.showNotification(
      localNotifPlugin,
      randomizedRestaurant,
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  static Future<void> notifTestCallback() async {
    debugPrint('Alarm fired!');
    var notificationHelper = NotificationHelper();
    RestaurantList getData = await ApiService.getRestaurantList();
    List<Restaurant> restaurants = getData.restaurants;

    await notificationHelper.showNotification(
      localNotifPlugin,
      restaurants[0],
    );

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
