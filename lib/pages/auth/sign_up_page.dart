import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app_project/common/navigation.dart';
import 'package:restaurant_app_project/utils/auth_service.dart';

import '../../common/common.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign_up_page';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailTxtFieldCtrler;
  late TextEditingController _passwordTxtFieldCtrler;

  bool _isLoading = false;

  @override
  void initState() {
    _emailTxtFieldCtrler = TextEditingController();
    _passwordTxtFieldCtrler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTxtFieldCtrler.dispose();
    _passwordTxtFieldCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: (_isLoading)
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primaryColorBrightest,
                    color: primaryColor,
                  ),
                )
              : _body(context),
        ),
      ),
    );
  }

  Column _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appName,
          style: txtThemeH4!.copyWith(color: primaryColor),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailTxtFieldCtrler,
          decoration: inputDeco(
            label: const Text('Email'),
            hintText: "example@example.com",
          ),
          keyboardType: TextInputType.emailAddress,
          style: textTheme.bodyText1?.copyWith(color: primaryColor),
          maxLines: 1,
          cursorColor: secondaryColor,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordTxtFieldCtrler,
          decoration: inputDeco(
            label: Text(
              AppLocalizations.of(context)!.password,
            ),
          ),
          style: textTheme.bodyText1?.copyWith(color: primaryColor),
          obscureText: true,
          maxLines: 1,
          cursorColor: secondaryColor,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!_isLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await AuthService.signUpWithEmail(
                      email: _emailTxtFieldCtrler.text,
                      password: _passwordTxtFieldCtrler.text,
                    );

                    Navigation.pop();
                  } on FirebaseAuthException catch (e) {
                    debugPrint(e.code);
                    switch (e.code) {
                      case 'email-already-in-use':
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.emailAlreadyInUse,
                            ),
                          ),
                        );
                        break;
                      case 'invalid-email':
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.invalidEmail,
                            ),
                          ),
                        );
                        break;
                      case 'operation-not-allowed':
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.operationNotAllowed,
                            ),
                          ),
                        );
                        break;
                      case 'weak-password':
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.weakPassword,
                            ),
                          ),
                        );
                        break;
                      default:
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.signUpBtn),
            ),
            ElevatedButton(
              onPressed: () {
                Navigation.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: secondaryColor,
              ),
              child: Text(AppLocalizations.of(context)!.goBackBtn),
            ),
          ],
        )
      ],
    );
  }
}
