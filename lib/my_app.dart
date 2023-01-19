import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/common.dart';
import 'data/db/database_helper.dart';
import 'data/model/from_api/restaurant_detail.dart';
import 'data/preferences/preferences_helper.dart';
import 'pages/pages.dart';
import 'providers/my_provoders.dart';
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

  final _providerList = <SingleChildWidget>[
    ChangeNotifierProvider<RestaurantListProvider>(
      create: (context) => RestaurantListProvider(),
    ),
    ChangeNotifierProvider<NotificationsProvider>(
      create: (context) => NotificationsProvider(),
    ),
    ChangeNotifierProvider<PreferencesProvider>(
      create: (context) => PreferencesProvider(
        prefHelper: PreferencesHelper(
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

  final _routes = <String, WidgetBuilder>{
    Wrapper.routeName: (context) => const Wrapper(),
    SignUpPage.routeName: (context) => const SignUpPage(),
    AboutAppPage.routeName: (context) => AboutAppPage(),
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
