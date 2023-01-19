import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../common/common.dart';
import '../../utils/auth_service.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/sign_up_page';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _emailTxtFieldCtrler;
  late TextEditingController _passTxtFieldCtrler;
  late TextEditingController _passTxtFieldCtrler2;

  bool _isLoading = false;
  bool _isHidePass = true;
  bool _isHidePass2 = true;

  @override
  void initState() {
    _emailTxtFieldCtrler = TextEditingController();
    _passTxtFieldCtrler = TextEditingController();
    _passTxtFieldCtrler2 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTxtFieldCtrler.dispose();
    _passTxtFieldCtrler.dispose();
    _passTxtFieldCtrler2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mainPadding = (screenSize(context).width <= 750)
        ? const EdgeInsets.symmetric(horizontal: 16)
        : const EdgeInsets.symmetric(horizontal: 32);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: mainPadding,
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
          AppLocalizations.of(context)!.signUpPageHeader,
          style: txtThemeH4!.copyWith(color: primaryColor),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 500,
          child: TextField(
            controller: _emailTxtFieldCtrler,
            decoration: inputDeco(
              label: const Text('Email'),
              hintText: "example@gmail.com",
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
            controller: _passTxtFieldCtrler,
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
        const SizedBox(height: 16),
        SizedBox(
          width: 500,
          child: TextField(
            controller: _passTxtFieldCtrler2,
            decoration: inputDeco(
              hintText: AppLocalizations.of(context)!.passConfirmHint,
              label: Text(
                AppLocalizations.of(context)!.passConfirm,
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  if (_isHidePass2) {
                    setState(() {
                      _isHidePass2 = false;
                    });
                    return;
                  }
                  setState(() {
                    _isHidePass2 = true;
                  });
                },
                icon: Icon(
                  (_isHidePass2) ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
            style: textTheme.bodyText1?.copyWith(color: primaryColor),
            obscureText: _isHidePass2,
            maxLines: 1,
            cursorColor: secondaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                String emailInput = _emailTxtFieldCtrler.text;
                String passInput = _passTxtFieldCtrler.text;
                String confirmPassInput = _passTxtFieldCtrler2.text;

                bool isPassSame = passInput == confirmPassInput;

                if (emailInput == '' ||
                    passInput == '' ||
                    confirmPassInput == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.emptyTxtField,
                      ),
                    ),
                  );
                  return;
                }

                if (!_isLoading && isPassSame) {
                  setState(() {
                    _isLoading = true;
                  });
                  try {
                    await AuthService.signUpWithEmail(
                      email: emailInput,
                      password: passInput,
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.noInternetAccess,
                            ),
                          ),
                        );
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.passNotSame,
                    ),
                  ),
                );
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
