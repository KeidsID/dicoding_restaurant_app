import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/common.dart';
import 'sign_up_page.dart';
import '../../utils/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailTxtFieldCtrler;
  late TextEditingController _passwordTxtFieldCtrler;

  bool _isLoading = false;
  bool _isHidePass = true;

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
              : SizedBox(
                  width: screenSize(context).width,
                  child: _body(context),
                ),
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
        SizedBox(
          width: 500,
          child: TextField(
            controller: _emailTxtFieldCtrler,
            decoration: inputDeco(
              label: const Text('Email'),
              hintText: "example@example.com",
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: textTheme.bodyText1?.copyWith(color: primaryColor),
            maxLines: 1,
            cursorColor: secondaryColor,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 500,
          child: TextField(
            controller: _passwordTxtFieldCtrler,
            decoration: inputDeco(
              label: Text(
                AppLocalizations.of(context)!.password,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (_isHidePass) {
                    setState(() {
                      _isHidePass = false;
                    });
                    return;
                  }
                  setState(() {
                    _isHidePass = true;
                  });
                },
                icon: Icon(
                  (_isHidePass) ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            style: textTheme.bodyText1?.copyWith(color: primaryColor),
            obscureText: _isHidePass,
            maxLines: 1,
            cursorColor: secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            String emailInput = _emailTxtFieldCtrler.text;
            String passwordInput = _passwordTxtFieldCtrler.text;

            if (emailInput == '' && passwordInput == '') {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(AppLocalizations.of(context)!.emptyTxtField),
              ));
              return;
            }

            if (!_isLoading) {
              setState(() {
                _isLoading = true;
              });
              try {
                await AuthService.signInWithEmail(
                  email: emailInput,
                  password: passwordInput,
                );
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'invalid-email':
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!.invalidEmail),
                    ));
                    break;
                  case 'user-disabled':
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!.userDisabled),
                    ));
                    break;
                  case 'user-not-found':
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!.userNotFound),
                    ));
                    break;
                  case 'wrong-password':
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.wrongPassword,
                      ),
                    ));
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.noInternetAccess,
                      ),
                    ));
                }
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          child: Text(
            AppLocalizations.of(context)!.loginBtn,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, SignUpPage.routeName);
          },
          child: Text(
            AppLocalizations.of(context)!.toSignUpPageBtn,
            textAlign: TextAlign.center,
          ),
        ),
        TextButton(
          onPressed: () async {
            if (!_isLoading) {
              setState(() {
                _isLoading = true;
              });
              try {
                await AuthService.signInAnonymously();
              } on FirebaseAuthException catch (e) {
                switch (e.code) {
                  case 'operation-not-allowed':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.anonymousLoginDisabled,
                        ),
                      ),
                    );
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${AppLocalizations.of(context)!.noInternetAccess} / ${AppLocalizations.of(context)!.anonymousLoginDisabled}',
                        ),
                      ),
                    );
                }
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.anonymousLoginBtn),
        )
      ],
    );
  }
}
