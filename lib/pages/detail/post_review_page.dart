import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant_app_project/common/styles/input_decoration.dart';
import 'package:restaurant_app_project/pages/auth/wrapper.dart';
import 'package:restaurant_app_project/pages/home/home_page.dart';

import '../../common/common.dart';
import '../../common/image_network_builder.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_detail.dart';
import 'detail_page.dart';

class PostReviewPage extends StatefulWidget {
  static String routeName = '/post_review_page';
  final RestaurantDetailed restaurant;

  const PostReviewPage({super.key, required this.restaurant});

  @override
  State<PostReviewPage> createState() => _PostReviewPageState();
}

class _PostReviewPageState extends State<PostReviewPage> {
  late TextEditingController _postTxtCtrler;

  @override
  void initState() {
    _postTxtCtrler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _postTxtCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);

    var bodyPadding = (screenSize(context).width <= 750)
        ? EdgeInsets.zero
        : EdgeInsets.symmetric(horizontal: 24);

    return Scaffold(
      appBar: _appBar(context, firebaseUser: firebaseUser),
      body: Padding(
        padding: bodyPadding,
        child: _body(context, firebaseUser: firebaseUser),
      ),
    );
  }

  AppBar _appBar(BuildContext context, {User? firebaseUser}) {
    final String displayName = firebaseUser!.displayName ?? 'Anonymous';

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
              ApiService.instance!.imageSmall(widget.restaurant.pictureId),
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
                  widget.restaurant.name,
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
        onPressed: () {
          try {
            if (_postTxtCtrler.text != '') {
              ApiService.instance!.postReview(
                restaurantId: widget.restaurant.id,
                name: displayName,
                review: _postTxtCtrler.text,
              );

              Navigator.popUntil(
                context,
                ModalRoute.withName(Wrapper.routeName),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.reviewCantEmpty,
                ),
              ));
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("$e"),
            ));
          }
        },
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
              controller: _postTxtCtrler,
              maxLength: 500,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: textTheme.bodyText1?.copyWith(color: primaryColor),
              cursorColor: secondaryColor,
              decoration: inputDeco(
                hintText: AppLocalizations.of(context)!.reviewTxtFieldHint,
              ),
            )
          ],
        ),
      ),
    );
  }
}
