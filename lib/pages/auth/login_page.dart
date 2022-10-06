import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_project/utils/auth_service.dart';

import '../../common/common.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              await AuthService.signInAnonymously();
            } catch (e) {
              e as FirebaseAuthException;

              debugPrint(e.message);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.anonymousLoginDisabled,
                  ),
                ),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.anonymousLogin),
        ),
      ),
    );
  }
}
