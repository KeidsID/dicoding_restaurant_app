import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles/style.dart';
import '../data/api/api_service.dart';
import '../data/model/from_api/restaurant_detail.dart';
import '../providers/restaurant_detail_provider.dart';
import '../widgets/fade_on_scroll.dart';

Size _screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

TextStyle? _txtThemeH3SColor(BuildContext context) {
  return Theme.of(context).textTheme.headline3?.copyWith(color: secondaryColor);
}

TextStyle? _txtThemeH6PColor(BuildContext context) {
  return Theme.of(context).textTheme.headline6?.copyWith(color: primaryColor);
}

TextStyle? _txtThemeOverlinePColor(BuildContext context) {
  return Theme.of(context).textTheme.overline?.copyWith(color: primaryColor);
}

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
Widget _iconWithText(
  BuildContext context, {
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
        style: Theme.of(context)
            .textTheme
            .subtitle1
            ?.copyWith(color: primaryColor),
      )
    ],
  );
}

Widget _foodAndDrinkWidget(String e, TextStyle? textStyle) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Text(
      e,
      style: textStyle,
    ),
  );
}

List<Widget> _foodWidgets(BuildContext context, Restaurant restaurant) {
  return restaurant.menus.foods.map(
    (e) {
      return _foodAndDrinkWidget(
          '\u003E ${e.name}', _txtThemeH6PColor(context));
    },
  ).toList();
}

List<Widget> _drinkWidgets(BuildContext context, Restaurant restaurant) {
  return restaurant.menus.drinks.map(
    (e) {
      return _foodAndDrinkWidget(
          '\u003E ${e.name}', _txtThemeH6PColor(context));
    },
  ).toList();
}

class DetailPage extends StatelessWidget {
  static String routeName = '/detail_page';
  final String pictureId;

  const DetailPage({super.key, required this.pictureId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestaurantDetailProvider(pictureId),
      child: Consumer<RestaurantDetailProvider>(
        builder: (_, restaurantDetailProvider, __) {
          if (restaurantDetailProvider.state == ResultState.loading) {
            // loading widget
            return const Center(child: CircularProgressIndicator());
          } else {
            if (restaurantDetailProvider.state == ResultState.hasData) {
              // success widget
            } else if (restaurantDetailProvider.state == ResultState.noData) {
              // no data
              return Center(
                child: Text(
                  restaurantDetailProvider.message,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (restaurantDetailProvider.state == ResultState.error) {
              // error widget
              return Center(
                child: Text(
                  restaurantDetailProvider.message,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: Text(
                  restaurantDetailProvider.message,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      ?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }

          final restaurant = restaurantDetailProvider.result.restaurant;

          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth <= 600) {
                return _DetailPagePortrait(restaurant);
              } else {
                return _DetailPageLandscape(restaurant);
              }
            },
          );
        },
      ),
    );
  }
}

class _DetailPagePortrait extends StatelessWidget {
  final Restaurant restaurant;

  _DetailPagePortrait(this.restaurant, {Key? key}) : super(key: key);

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    EdgeInsets mainHMargin = const EdgeInsets.symmetric(horizontal: 16);

    Widget description() {
      return Column(
        children: [
          Text(
            restaurant.description,
            style: _txtThemeH6PColor(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'ID: ${restaurant.id.toUpperCase()}',
            style: _txtThemeOverlinePColor(context),
          ),
        ],
      );
    }

    return Scaffold(
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
                    restaurant.name,
                    style: _txtThemeH3SColor(context),
                    textAlign: TextAlign.center,
                  ),
                ),

                // description
                _descriptionContainer(
                  margin: mainHMargin,
                  child: description(),
                ),

                // location & rating
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: mainHMargin,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _iconWithText(
                          context,
                          icon: Icons.location_on,
                          text: restaurant.city,
                        ),
                        _iconWithText(
                          context,
                          icon: Icons.star,
                          text: '${restaurant.rating}',
                        ),
                      ],
                    ),
                  ),
                ),

                // Menu and Go Back Button
                Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 16),
                  width: _screenSize(context).width,
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
                          Navigator.pop(context);
                        },
                        child: Text(
                          'GO BACK',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(color: secondaryColor),
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
        fullOpacityOffset: 180,
        child: Text(
          appName,
          style: _txtThemeH6PColor(context),
        ),
      );
    }

    Widget flexibleSpaceBackground() {
      return Hero(
        tag: restaurant.id,
        child: Image.network(
          ApiService.imageMedium(restaurant.pictureId),
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              'assets/images/photo_error_icon.png',
              fit: BoxFit.fill,
            );
          },
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
            const TabBar(
              tabs: [
                Tab(text: 'FOODS'),
                Tab(text: 'DRINKS'),
              ],
            ),
            SizedBox(
              height:
                  _screenSize(context).height - _screenSize(context).height / 2,
              child: TabBarView(
                children: [
                  ListView(
                    children: _foodWidgets(context, restaurant),
                  ),
                  ListView(
                    children: _drinkWidgets(context, restaurant),
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
  final Restaurant restaurant;

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
    EdgeInsets appBarHMargin = (_screenSize(context).width <= 1200)
        ? const EdgeInsets.symmetric(horizontal: 16)
        : const EdgeInsets.symmetric(horizontal: 32);

    EdgeInsets bodyHMargin = (_screenSize(context).width <= 1200)
        ? const EdgeInsets.symmetric(horizontal: 32)
        : const EdgeInsets.symmetric(horizontal: 48);

    return Scaffold(
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
      width: _screenSize(context).width,
      margin: mainHMargin,
      child: Row(
        children: [
          // title
          Expanded(
            child: Text(
              appName,
              style: _txtThemeH6PColor(context),
            ),
          ),

          // TabBar
          const Expanded(
            child: TabBar(
              tabs: [
                Tab(text: 'FOODS'),
                Tab(text: 'DRINKS'),
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
              style: _txtThemeH6PColor(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'ID: ${widget.restaurant.id.toUpperCase()}',
              style: _txtThemeOverlinePColor(context),
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
                child: Image.network(
                  ApiService.imageMedium(
                    widget.restaurant.pictureId,
                  ),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/images/photo_error_icon.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            // title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                widget.restaurant.name,
                style: _txtThemeH3SColor(context),
                textAlign: TextAlign.center,
              ),
            ),

            // description
            _descriptionContainer(
              margin: EdgeInsets.symmetric(horizontal: mainHMargin),
              child: description(),
            ),

            // location & rating
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.symmetric(horizontal: mainHMargin),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _iconWithText(
                      context,
                      icon: Icons.location_on,
                      text: widget.restaurant.city,
                    ),
                    _iconWithText(
                      context,
                      icon: Icons.star,
                      text: '${widget.restaurant.rating}',
                    ),
                  ],
                ),
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
              height: _screenSize(context).height - 100,
              child: restaurantDetail(context),
            ),
          ),

          // TabBarView + Button
          Expanded(
            child: SizedBox(
              height: _screenSize(context).height - 100,
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
                            children: _foodWidgets(context, widget.restaurant),
                          ),
                        ),
                        Scrollbar(
                          controller: drinksScrollCtrler,
                          thumbVisibility: true,
                          child: ListView(
                            controller: drinksScrollCtrler,
                            children: _drinkWidgets(context, widget.restaurant),
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
                          Navigator.pop(context);
                        },
                        child: Text(
                          'GO BACK',
                          style: Theme.of(context)
                              .textTheme
                              .button
                              ?.copyWith(color: secondaryColor),
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
