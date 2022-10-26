import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/pages/auth/sign_up_page.dart';
import 'package:restaurant_app_project/pages/auth/user_first_setup.dart';
import 'package:restaurant_app_project/pages/auth/wrapper.dart';
import 'package:restaurant_app_project/pages/detail/post_review_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/single_child_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'common/common.dart';
import 'common/navigation.dart';
import 'data/db/database_helper.dart';
import 'data/model/from_api/restaurant_detail.dart';
import 'data/preferences/preferences_helper.dart';

import 'pages/detail/detail_page.dart';
import 'pages/home/search_result_page.dart';
import 'pages/detail/reviews_page.dart';
import 'pages/home/wishlist_page.dart';

import 'providers/notifications_provider.dart';
import 'providers/preferences_provider.dart';
import 'providers/restaurant_list_provider.dart';
import 'providers/db_provider.dart';
import 'utils/auth_service.dart';

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
        initialRoute: Wrapper.routeName,
        routes: _routes,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  final List<SingleChildWidget> _providerList = [
    ChangeNotifierProvider<RestaurantListProvider>(
      create: (context) => RestaurantListProvider(),
    ),
    ChangeNotifierProvider<NotificationsProvider>(
      create: (context) => NotificationsProvider(),
    ),
    ChangeNotifierProvider<PreferencesProvider>(
      create: (context) => PreferencesProvider(
        preferencesHelper: PreferencesHelper(
          sharedPreferences: SharedPreferences.getInstance(),
        ),
      ),
    ),
    ChangeNotifierProvider<DbProvider>(
      create: (context) => DbProvider(
        databaseHelper: DatabaseHelper(),
      ),
    ),
    StreamProvider<User?>.value(
      value: AuthService.firebaseUserStream,
      initialData: null,
    ),
  ];

  final Map<String, WidgetBuilder> _routes = {
    Wrapper.routeName: (context) => const Wrapper(),
    SignUpPage.routeName: (context) => const SignUpPage(),
    DetailPage.routeName: (context) {
      return DetailPage(
        restaurantId: ModalRoute.of(context)?.settings.arguments as String,
      );
    },
    ReviewsPage.routeName: (context) {
      return ReviewsPage(
        restaurant:
            ModalRoute.of(context)?.settings.arguments as RestaurantDetailed,
      );
    },
    PostReviewPage.routeName: (context) {
      return PostReviewPage(
        restaurant:
            ModalRoute.of(context)?.settings.arguments as RestaurantDetailed,
      );
    },
    SearchResultPage.routeName: (context) {
      return SearchResultPage(
        query: ModalRoute.of(context)?.settings.arguments as String,
      );
    },
    WishlistPage.routeName: (context) => const WishlistPage()
  };
}
