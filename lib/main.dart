import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'common/styles/style.dart';
import 'common/styles/widgets_style.dart';
import 'data/model/from_assets/restaurant.dart';
import 'pages/detail_page.dart';
import 'pages/home_page.dart';

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
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: backgroundColor,
        textTheme: textTheme,
        appBarTheme: appBarTheme,
        listTileTheme: listTileThemeData,
        tabBarTheme: tabBarTheme,
        elevatedButtonTheme: elevatedButtonThemeData,
        iconTheme: iconThemeData,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        DetailPage.routeName: (context) => DetailPage(
            ModalRoute.of(context)?.settings.arguments as Restaurant),
      },
    );
  }
}
