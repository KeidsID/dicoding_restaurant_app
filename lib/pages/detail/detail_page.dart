import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_detail.dart';
import '../../providers/api/restaurant_detail_provider.dart';
import '../../widgets/fade_on_scroll.dart';
import '../../widgets/review_container.dart';
import '../auth/wrapper.dart';
import 'post_review_page.dart';
import 'reviews_page.dart';

Widget _descriptionContainer({EdgeInsetsGeometry? margin, Widget? child}) {
  return Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: primaryColorBrightest.withOpacity(0.15),
      border: const Border(
        top: BorderSide(color: primaryColorBrighter, width: 1),
        bottom: BorderSide(color: primaryColorBrighter, width: 1),
      ),
    ),
    margin: margin,
    child: child,
  );
}

// For location & rating
Widget _iconWithText({
  IconData? icon,
  required String text,
}) {
  return Row(
    children: [
      Icon(
        icon,
        size: 23,
      ),
      Text(
        text,
        style: txtThemeSub1?.copyWith(color: primaryColor),
      )
    ],
  );
}

Widget _foodAndDrinkWidget(String e, {TextStyle? style}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Text(
      e,
      style: style,
    ),
  );
}

List<Widget> _foodWidgets(RestaurantDetailed restaurant) {
  return restaurant.menus.foods.map(
    (e) {
      return _foodAndDrinkWidget(
        '\u003E ${e.name}',
        style: txtThemeH6?.copyWith(color: primaryColor),
      );
    },
  ).toList();
}

List<Widget> _drinkWidgets(RestaurantDetailed restaurant) {
  return restaurant.menus.drinks.map(
    (e) {
      return _foodAndDrinkWidget(
        '\u003E ${e.name}',
        style: txtThemeH6?.copyWith(color: primaryColor),
      );
    },
  ).toList();
}

class DetailPage extends StatelessWidget {
  static const routeName = '/detail_page';
  final String restaurantId;

  const DetailPage({super.key, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantDetailProvider(
        id: restaurantId,
      ),
      child: Consumer<RestaurantDetailProvider>(
        builder: (_, rDetailProv, __) {
          if (rDetailProv.state == ResultState.loading) {
            return Container(
              width: screenSize(context).width,
              height: screenSize(context).height,
              color: backgroundColor,
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: primaryColorBrightest,
                  color: primaryColor,
                ),
              ),
            );
          }

          if (rDetailProv.state == ResultState.noData) {
            return Container(
              width: screenSize(context).width,
              height: screenSize(context).height,
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noApiData,
                    style: txtThemeH4?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      rDetailProv.fetchRestaurantDetail();
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          if (rDetailProv.state == ResultState.error) {
            return Container(
              width: screenSize(context).width,
              height: screenSize(context).height,
              color: backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noInternetAccess,
                    style: txtThemeH4?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      rDetailProv.fetchRestaurantDetail();
                    },
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          final restaurant = rDetailProv.result.restaurant;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth <= 750) {
                return _DetailPagePortrait(restaurant);
              }
              return _DetailPageLandscape(restaurant);
            },
          );
        },
      ),
    );
  }
}

class _DetailPagePortrait extends StatefulWidget {
  final RestaurantDetailed restaurant;

  const _DetailPagePortrait(this.restaurant, {Key? key}) : super(key: key);

  @override
  State<_DetailPagePortrait> createState() => _DetailPagePortraitState();
}

class _DetailPagePortraitState extends State<_DetailPagePortrait> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets mainHMargin = const EdgeInsets.symmetric(horizontal: 16);

    Widget description() {
      return Column(
        children: [
          Text(
            widget.restaurant.description,
            style: txtThemeH6?.copyWith(color: primaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${widget.restaurant.id.toUpperCase()}',
            style: txtThemeOverline?.copyWith(color: primaryColor),
          ),
        ],
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, isScrolled) {
            return _sliverAppBar(context);
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                // title
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    widget.restaurant.name,
                    style: txtThemeH3?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                // description
                _descriptionContainer(
                  margin: mainHMargin,
                  child: description(),
                ),

                // location, rating, and categories
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: mainHMargin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _iconWithText(
                        icon: Icons.location_on,
                        text: widget.restaurant.city,
                      ),
                      _iconWithText(
                        icon: Icons.star,
                        text: '${widget.restaurant.rating}',
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.restaurant.categories
                      .map(
                        (e) => Chip(
                          label: Text('# ${e.name}'),
                        ),
                      )
                      .toList(),
                ),

                // review, ReviewPage button, and PostReviewPage button
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    AppLocalizations.of(context)!.reviewHeading(1),
                    style: txtThemeH4?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  margin: mainHMargin,
                  child: ReviewContainer(
                    customerReviews: widget.restaurant.customerReviews[0],
                    maxLinesReview: 2,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ReviewsPage.routeName,
                      arguments: widget.restaurant,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.reviewsCheck.toUpperCase(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      PostReviewPage.routeName,
                      arguments: widget.restaurant,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.leaveAReview.toUpperCase(),
                  ),
                ),

                // Menu and Go Back Button
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: screenSize(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _bottomModal(context);
                        },
                        child: const Text('MENU'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigation.popUntil(Wrapper.routeName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.goBackBtn,
                          style: txtThemeBtn?.copyWith(color: secondaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sliverAppBar(BuildContext context) {
    Widget title() {
      return FadeOnScroll(
        scrollController: scrollController,
        fullOpacityOffset: 250,
        child: Text(
          appName,
          style: txtThemeH6?.copyWith(color: primaryColor),
        ),
      );
    }

    Widget flexibleSpaceBackground() {
      return Hero(
        tag: widget.restaurant.id,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/photo_error_icon.png',
          image: ApiService.instance!.imageMedium(widget.restaurant.pictureId),
          fit: BoxFit.fill,
          placeholderFit: BoxFit.contain,
        ),
      );
    }

    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 250,
        automaticallyImplyLeading: false,
        flexibleSpace: FlexibleSpaceBar(
          title: title(),
          centerTitle: true,
          background: flexibleSpaceBackground(),
        ),
      ),
    ];
  }

  Future<dynamic> _bottomModal(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.foodsTab),
                Tab(text: AppLocalizations.of(context)!.drinksTab),
              ],
            ),
            SizedBox(
              height:
                  screenSize(context).height - screenSize(context).height / 2,
              child: TabBarView(
                children: [
                  ListView(
                    children: _foodWidgets(widget.restaurant),
                  ),
                  ListView(
                    children: _drinkWidgets(widget.restaurant),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailPageLandscape extends StatefulWidget {
  final RestaurantDetailed restaurant;

  const _DetailPageLandscape(
    this.restaurant, {
    Key? key,
  }) : super(key: key);

  @override
  State<_DetailPageLandscape> createState() => _DetailPageLandscapeState();
}

class _DetailPageLandscapeState extends State<_DetailPageLandscape> {
  late ScrollController detailScrollCtrler;
  late ScrollController foodsScrollCtrler;
  late ScrollController drinksScrollCtrler;

  @override
  void initState() {
    super.initState();
    detailScrollCtrler = ScrollController();
    foodsScrollCtrler = ScrollController();
    drinksScrollCtrler = ScrollController();
  }

  @override
  void dispose() {
    detailScrollCtrler.dispose();
    foodsScrollCtrler.dispose();
    drinksScrollCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets appBarHMargin = (screenSize(context).width <= 1200)
        ? const EdgeInsets.symmetric(horizontal: 16)
        : const EdgeInsets.symmetric(horizontal: 32);

    EdgeInsets bodyHMargin = (screenSize(context).width <= 1200)
        ? const EdgeInsets.symmetric(horizontal: 32)
        : const EdgeInsets.symmetric(horizontal: 48);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(context, appBarHMargin),
              const SizedBox(height: 16),
              _body(context, bodyHMargin),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, EdgeInsets mainHMargin) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: primaryColor,
            width: 0.5,
          ),
        ),
      ),
      width: screenSize(context).width,
      margin: mainHMargin,
      child: Row(
        children: [
          // title
          Expanded(
            child: Text(
              appName,
              style: txtThemeH6?.copyWith(color: primaryColor),
            ),
          ),

          // TabBar
          Expanded(
            child: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.foodsTab),
                Tab(text: AppLocalizations.of(context)!.drinksTab),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, EdgeInsets mainHMargin) {
    Widget restaurantDetail(BuildContext context) {
      double mainHMargin = 16;

      Widget description() {
        return Column(
          children: [
            Text(
              widget.restaurant.description,
              style: txtThemeH6?.copyWith(color: primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${widget.restaurant.id.toUpperCase()}',
              style: txtThemeOverline?.copyWith(color: primaryColor),
            ),
          ],
        );
      }

      return Scrollbar(
        controller: detailScrollCtrler,
        thumbVisibility: true,
        child: ListView(
          controller: detailScrollCtrler,
          children: [
            // Image
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: mainHMargin,
              ),
              child: Hero(
                tag: widget.restaurant.id,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/photo_error_icon.png',
                  image: ApiService.instance!.imageMedium(
                    widget.restaurant.pictureId,
                  ),
                  height: 225,
                  fit: BoxFit.cover,
                  placeholderFit: BoxFit.contain,
                ),
              ),
            ),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                widget.restaurant.name,
                style: txtThemeH3?.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
            ),

            // description
            _descriptionContainer(
              margin: EdgeInsets.symmetric(horizontal: mainHMargin),
              child: description(),
            ),

            // location, rating, and categories
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: mainHMargin),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconWithText(
                      icon: Icons.location_on,
                      text: widget.restaurant.city,
                    ),
                    _iconWithText(
                      icon: Icons.star,
                      text: '${widget.restaurant.rating}',
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: widget.restaurant.categories
                  .map(
                    (e) => Chip(
                      label: Text('# ${e.name}'),
                    ),
                  )
                  .toList(),
            ),

            // reviews
            // heading
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                AppLocalizations.of(context)!.reviewHeading(1),
                style: txtThemeH4?.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
            ),
            // review, and ReviewPage button
            Container(
              margin: EdgeInsets.symmetric(horizontal: mainHMargin),
              child: ReviewContainer(
                customerReviews: widget.restaurant.customerReviews[0],
                maxLinesReview: 2,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ReviewsPage.routeName,
                  arguments: widget.restaurant,
                );
              },
              child: Text(
                AppLocalizations.of(context)!.reviewsCheck.toUpperCase(),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PostReviewPage.routeName,
                  arguments: widget.restaurant,
                );
              },
              child: Text(
                AppLocalizations.of(context)!.leaveAReview.toUpperCase(),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: mainHMargin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant detail
          Expanded(
            child: SizedBox(
              height: screenSize(context).height - 100,
              child: restaurantDetail(context),
            ),
          ),

          // TabBarView + Button
          Expanded(
            child: SizedBox(
              height: screenSize(context).height - 100,
              child: Column(
                children: [
                  // TabBar
                  Expanded(
                    flex: 4,
                    child: TabBarView(
                      children: [
                        Scrollbar(
                          controller: foodsScrollCtrler,
                          thumbVisibility: true,
                          child: ListView(
                            controller: foodsScrollCtrler,
                            children: _foodWidgets(widget.restaurant),
                          ),
                        ),
                        Scrollbar(
                          controller: drinksScrollCtrler,
                          thumbVisibility: true,
                          child: ListView(
                            controller: drinksScrollCtrler,
                            children: _drinkWidgets(widget.restaurant),
                          ),
                        )
                      ],
                    ),
                  ),

                  // Button
                  Flexible(
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigation.popUntil(Wrapper.routeName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.goBackBtn,
                          style: txtThemeBtn?.copyWith(color: secondaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
