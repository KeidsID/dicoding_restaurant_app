import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/pages/auth/user_first_setup.dart';

import 'login_page.dart';
import '../home/home_page.dart';

class Wrapper extends StatefulWidget {
  static String routeName = '/';

  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.
    await Future.delayed(const Duration(seconds: 1));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);

    return (firebaseUser == null)
        ? const LoginPage()
        : (!firebaseUser.isAnonymous && firebaseUser.displayName == null)
            ? const UserFirstSetup()
            : const HomePage();
  }
}
