import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/common.dart';

class AboutAppPage extends StatelessWidget {
  static const routeName = "/about_page";

  AboutAppPage({super.key});

  final Uri _sourceCodeUrl = Uri.parse(
    'https://github.com/KeidsID/restaurant_app_project',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appInfo),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) {
          if (constraint.maxWidth <= 750) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: constraint.maxWidth,
              height: constraint.maxHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bodyContent(context),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: _bodyContent(context),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _bodyContent(BuildContext context) {
    return [
      const SizedBox(height: 16),
      Text(
        appName,
        style: txtThemeH4!.copyWith(color: primaryColor),
      ),
      const SizedBox(height: 16),
      Image.asset(
        "assets/images/meal.png",
        width: 100,
        height: 100,
      ),
      const SizedBox(height: 16),
      Text(
        AppLocalizations.of(context)!.aboutApp,
        style: txtThemeBody1!.copyWith(color: primaryColor),
        textAlign: TextAlign.center,
      ),
      const Divider(color: secondaryColor),
      Text(
        "${AppLocalizations.of(context)!.appGithubRepo}:",
        style: txtThemeBody1!.copyWith(color: primaryColor),
        textAlign: TextAlign.center,
      ),
      TextButton(
        onPressed: () async {
          try {
            if (!await launchUrl(
              _sourceCodeUrl,
              mode: LaunchMode.externalApplication,
            )) {
              throw "Could not launch $_sourceCodeUrl";
            }
          } catch (e) {
            debugPrint("$e");
          }
        },
        child: const Text(
          "https://github.com/KeidsID/restaurant_app_project",
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }
}
