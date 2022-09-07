import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'common.dart';
import 'data/model/from_api/restaurant_detail.dart';
import 'pages/home_page.dart';
import 'pages/detail_page.dart';
import 'pages/search_result_page.dart';
import 'pages/reviews_page.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: myTheme,
      initialRoute: HomePage.routeName,
      routes: routes,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  Map<String, WidgetBuilder> get routes {
    return {
      HomePage.routeName: (context) {
        return const HomePage();
      },
      DetailPage.routeName: (context) {
        return DetailPage(
          pictureId: ModalRoute.of(context)?.settings.arguments as String,
        );
      },
      SearchResultPage.routeName: (context) {
        return SearchResultPage(
          query: ModalRoute.of(context)?.settings.arguments as String,
        );
      },
      ReviewsPage.routeName: (context) {
        return ReviewsPage(
          restaurant:
              ModalRoute.of(context)?.settings.arguments as DetailedRestaurant,
        );
      }
    };
  }
}
