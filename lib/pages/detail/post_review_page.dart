import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/common.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_detail.dart';
import '../auth/wrapper.dart';
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
    var bodyPadding = (screenSize(context).width <= 750)
        ? EdgeInsets.zero
        : const EdgeInsets.symmetric(horizontal: 24);

    return Scaffold(
      appBar: _appBar(context),
      body: Padding(
        padding: bodyPadding,
        child: _body(context),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);
    final String displayName = firebaseUser!.displayName ?? 'Anonymous';

    Widget leading = IconButton(
      icon: const Icon(Icons.close),
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
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/photo_error_icon.png',
              image: ApiService.instance!.imageSmall(
                widget.restaurant.pictureId,
              ),
              fit: BoxFit.fill,
              placeholderFit: BoxFit.contain,
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
                  style: txtThemeCap?.copyWith(
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
        onPressed: () async {
          try {
            if (_postTxtCtrler.text != '') {
              await ApiService.instance!.postReview(
                restaurantId: widget.restaurant.id,
                name: displayName,
                review: _postTxtCtrler.text,
              );

              Navigation.popUntil(Wrapper.routeName);
              Navigation.pushNamed(
                DetailPage.routeName,
                arguments: widget.restaurant.id,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.reviewCantEmpty,
                ),
              ));
            }
          } catch (e) {
            debugPrint('$e');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.noInternetAccess),
            ));
          }
        },
        child: const Text('POST'),
      ),
    ];

    return AppBar(
      leading: leading,
      title: title,
      actions: actions,
    );
  }

  Widget _body(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);
    final String displayName = firebaseUser!.displayName ?? 'Anonymous';

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: primaryColorBrightest,
                      foregroundColor: primaryColor,
                      radius: 24,
                      child: Text(
                        displayName[0].toUpperCase(),
                        style: textTheme.headline6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      displayName,
                      style: textTheme.headline6?.copyWith(
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.postReviewInfo,
                  style: textTheme.subtitle1?.copyWith(
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _postTxtCtrler,
              decoration: inputDeco(
                hintText: AppLocalizations.of(context)!.reviewTxtFieldHint,
              ),
              keyboardType: TextInputType.multiline,
              style: textTheme.bodyText1?.copyWith(color: primaryColor),
              maxLines: null,
              maxLength: 500,
              cursorColor: secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
