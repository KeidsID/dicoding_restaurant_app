import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/common.dart';
import '../../common/image_network_builder.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_detail.dart';
import 'detail_page.dart';

class PostReviewPage extends StatelessWidget {
  static String routeName = '/post_review_page';
  final RestaurantDetailed restaurant;

  const PostReviewPage({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);

    return Scaffold(
      appBar: _appBar(context),
      body: _body(context, firebaseUser: firebaseUser),
    );
  }

  AppBar _appBar(BuildContext context) {
    Widget leading = IconButton(
      icon: Icon(Icons.close),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                AppLocalizations.of(context)!.discardDraft,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.cancelBtn),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(DetailPage.routeName),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.discardBtn),
                ),
              ],
            );
          },
        );
      },
    );

    Widget title = Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: kToolbarHeight,
      child: Row(
        children: [
          Flexible(
            child: Image.network(
              ApiService.instance!.imageSmall(restaurant.pictureId),
              fit: BoxFit.fill,
              errorBuilder: errorBuilder,
            ),
          ),
          const Flexible(child: SizedBox(width: 8)),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppBarTheme.of(context)
                      .titleTextStyle
                      ?.copyWith(color: secondaryColor),
                ),
                Text(
                  AppLocalizations.of(context)!.leaveAReview,
                  style: txtThemeCaption?.copyWith(
                    color: primaryColorBrighter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    List<Widget> actions = [
      TextButton(
        onPressed: () {},
        child: Text('POST'),
      ),
    ];

    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
    );
  }

  Widget _body(BuildContext context, {User? firebaseUser}) {
    final String displayName = firebaseUser!.displayName ?? 'Anonymous';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: primaryColorBrightest,
                        foregroundColor: primaryColor,
                        radius: 24,
                        child: Text(
                          displayName.substring(0, 1).toUpperCase(),
                          style: textTheme.headline6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        displayName,
                        style: textTheme.headline6?.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.postReviewInfo,
                    style: textTheme.subtitle1?.copyWith(
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            TextField(
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: textTheme.bodyText1?.copyWith(color: primaryColor),
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                filled: true,
                fillColor: primaryColorBrightest.withOpacity(0.25),
                hintText: AppLocalizations.of(context)!.reviewTxtFieldHint,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryColor),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: secondaryColor,
                    width: 2,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
