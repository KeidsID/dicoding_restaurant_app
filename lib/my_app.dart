import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/providers/notifications_provider.dart';
import 'package:restaurant_app_project/providers/restaurant_list_provider.dart';

import 'common/common.dart';
import 'data/model/from_api/restaurant_detail.dart';
import 'pages/home_page.dart';
import 'pages/detail_page.dart';
import 'pages/search_result_page.dart';
import 'pages/reviews_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providerList,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        initialRoute: HomePage.routeName,
        routes: _routes,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  final List<ChangeNotifierProvider> _providerList = [
    ChangeNotifierProvider<RestaurantListProvider>(
      create: (context) => RestaurantListProvider(),
    ),
    ChangeNotifierProvider<NotificationsProvider>(
      create: (context) => NotificationsProvider(),
    ),
  ];

  final Map<String, WidgetBuilder> _routes = {
    HomePage.routeName: (context) {
      return const HomePage();
    },
    DetailPage.routeName: (context) {
      return DetailPage(
        restaurantId: ModalRoute.of(context)?.settings.arguments as String,
      );
    },
    SearchResultPage.routeName: (context) {
      return SearchResultPage(
        query: ModalRoute.of(context)?.settings.arguments as String,
      );
    },
    ReviewsPage.routeName: (context) {
      return ReviewsPage(
        restaurant: ModalRoute.of(context)?.settings.arguments as Restaurant,
      );
    }
  };
}
