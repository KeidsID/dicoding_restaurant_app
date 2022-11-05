import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../common/navigation.dart';
import '../data/model/from_api/restaurant.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? instance;

  NotificationHelper._internal() {
    instance = this;
  }

  factory NotificationHelper() => instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin plugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notifResponse) {
        if (notifResponse.payload != null) {
          debugPrint('notification payload: ${notifResponse.payload}');
        }
        selectNotificationSubject.add(notifResponse.payload ?? 'empty payload');
      },
    );
  }

  Future<void> showNotification(
    FlutterLocalNotificationsPlugin plugin,
    Restaurant restaurant,
  ) async {
    String channelId = "1";
    String channelName = "channel_01";
    String channelDescription = "Restaurant notif";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    String titleNotification = "<b>Trending Restaurant</b>";
    String restaurantName = restaurant.name;

    await plugin.show(
      0,
      titleNotification,
      restaurantName,
      platformChannelSpecifics,
      payload: json.encode(restaurant.toJson()),
    );
  }

  void configureNotifResponse(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));
        var restaurantId = data.id;
        Navigation.pushNamed(route, arguments: restaurantId);
      },
    );
  }
}
