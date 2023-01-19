import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';

class UserFirstSetup extends StatefulWidget {
  const UserFirstSetup({super.key});

  @override
  State<UserFirstSetup> createState() => _UserFirstSetupState();
}

class _UserFirstSetupState extends State<UserFirstSetup> {
  late TextEditingController _nameTxtFieldCtler;

  bool _isLoading = false;

  @override
  void initState() {
    _nameTxtFieldCtler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameTxtFieldCtler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: (_isLoading)
              ? const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primaryColorBrightest,
                    color: primaryColor,
                  ),
                )
              : _body(context, firebaseUser),
        ),
      ),
    );
  }

  Column _body(BuildContext context, User? firebaseUser) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.setUsernamePageHeading,
          style: txtThemeH5!.copyWith(color: primaryColor),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameTxtFieldCtler,
          decoration: inputDeco(
            label: Text(AppLocalizations.of(context)!.name),
            hintText: AppLocalizations.of(context)!.nameTxtFieldHint,
          ),
          keyboardType: TextInputType.name,
          style: textTheme.bodyText1?.copyWith(color: primaryColor),
          maxLines: 1,
          cursorColor: secondaryColor,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            if (!_isLoading) {
              setState(() {
                _isLoading = true;
              });
              try {
                await firebaseUser!.updateDisplayName(
                  _nameTxtFieldCtler.text,
                );
              } catch (e) {
                debugPrint("$e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.noInternetAccess,
                    ),
                  ),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.confirmBtn),
        )
      ],
    );
  }
}
