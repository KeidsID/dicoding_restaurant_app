import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/providers/notifications_provider.dart';
import 'package:restaurant_app_project/utils/notification_helper.dart';

import '../widgets/custom_dialog.dart';
import 'detail_page.dart';
import 'search_result_page.dart';
import '../common/common.dart';
import '../data/api/api_service.dart';
import '../data/model/from_api/restaurant_list.dart';
import '../providers/restaurant_list_provider.dart';
import '../widgets/restaurant_grid_view_container.dart';
import '../widgets/restaurant_list_tile.dart';
import '../widgets/search_text_field.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isSearchMode;
  late TextEditingController _searchTextFieldCtrler;

  final _notifHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.

    _notifHelper.configureSelectNotificationSubject(DetailPage.routeName);
    _isSearchMode = false;
    _searchTextFieldCtrler = TextEditingController();
    await Future.delayed(const Duration(seconds: 1));

    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextFieldCtrler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(screenSize: screenSize(context), appName: appName),
      body: _buildList(context),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Trending reminder'),
              trailing: Consumer<NotificationsProvider>(
                builder: (_, notificationsProv, __) {
                  return Switch(
                    value: notificationsProv.isScheduled,
                    onChanged: (value) {
                      if (!Platform.isAndroid) {
                        customDialog(context);
                      } else {
                        notificationsProv.scheduled(value);
                      }
                    },
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Notifications Test'),
              trailing: Consumer<NotificationsProvider>(
                builder: (_, notificationsProv, __) {
                  return Switch(
                    value: notificationsProv.isScheduled2,
                    onChanged: (value) {
                      if (!Platform.isAndroid) {
                        customDialog(context);
                      } else {
                        notificationsProv.afterTenSec(value);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar({required Size screenSize, required String appName}) {
    if (screenSize.width <= 750) {
      if (_isSearchMode) {
        return AppBar(
          leading: IconButton(
            onPressed: () => setState(() {
              _isSearchMode = false;
            }),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Row(
            children: _appBarSearchTextField(10),
          ),
        );
      } else {
        return AppBar(
          title: Text(appName),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => setState(() {
                _isSearchMode = true;
              }),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_added_outlined),
            ),
          ],
        );
      }
    } else {
      _isSearchMode = false;
      List<Widget> title = _appBarSearchTextField(5);
      title.insert(
        0,
        Flexible(
          child: Text(appName),
        ),
      );
      title.insert(
        1,
        const Flexible(
          child: SizedBox(width: 16),
        ),
      );

      return AppBar(
        title: Row(
          children: title,
        ),
      );
    }
  }

  List<Widget> _appBarSearchTextField([int flex = 1]) {
    return [
      Expanded(
        flex: flex,
        child: SearchTextField(controller: _searchTextFieldCtrler),
      ),
      const Flexible(child: SizedBox(width: 16)),
      Flexible(
        child: IconButton(
          onPressed: () {
            if (_searchTextFieldCtrler.text != '') {
              Navigator.pushNamed(
                context,
                SearchResultPage.routeName,
                arguments: _searchTextFieldCtrler.text,
              );
            }
          },
          icon: const Icon(Icons.search),
        ),
      ),
    ];
  }

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, restaurantListProvider, _) {
        if (restaurantListProvider.state == ResultState.loading) {
          // loading widget
          return Container(
            color: backgroundColor,
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColorBrightest,
                color: primaryColor,
              ),
            ),
          );
        } else {
          if (restaurantListProvider.state == ResultState.hasData) {
            // success widget
          } else if (restaurantListProvider.state == ResultState.noData) {
            // no data
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noApiData,
                style: txtThemeH4?.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
            );
          } else if (restaurantListProvider.state == ResultState.error) {
            // error widget
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noInternetAccess,
                style: txtThemeH4?.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return Center(
              child: Text(
                restaurantListProvider.message,
                style: txtThemeH4?.copyWith(color: secondaryColor),
                textAlign: TextAlign.center,
              ),
            );
          }
        }

        final List<Restaurant> restaurants =
            restaurantListProvider.result.restaurants;

        return LayoutBuilder(
          builder: (_, constraints) {
            if (constraints.maxWidth <= 750) {
              return _RestaurantsListView(restaurants);
            } else if (constraints.maxWidth <= 900) {
              return _RestaurantsGridView(
                gridCount: 2,
                restaurants: restaurants,
              );
            } else if (constraints.maxWidth <= 1200) {
              return _RestaurantsGridView(
                gridCount: 3,
                restaurants: restaurants,
              );
            } else {
              return _RestaurantsGridView(
                gridCount: 4,
                restaurants: restaurants,
              );
            }
          },
        );
      },
    );
  }
}

class _RestaurantsListView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const _RestaurantsListView(this.restaurants, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        return _buildRestaurantItem(context, restaurants[index]);
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    Hero leading(Restaurant restaurant) {
      return Hero(
        tag: restaurant.id,
        child: Image.network(
          ApiService.imageSmall(restaurant.pictureId),
          width: 100,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) {
            return Image.asset(
              'assets/images/photo_error_icon.png',
              width: 100,
              fit: BoxFit.fill,
            );
          },
        ),
      );
    }

    Text title(Restaurant restaurant, BuildContext context) {
      return Text(
        restaurant.name,
        style: txtThemeH6?.copyWith(color: secondaryColor),
      );
    }

    Column subtitle(Restaurant restaurant) {
      return Column(
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 23,
              ),
              Text(restaurant.city),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                size: 23,
              ),
              Text('${restaurant.rating}'),
            ],
          ),
        ],
      );
    }

    return Material(
      child: RestaurantListTile(
        leading: leading(restaurant),
        title: title(restaurant, context),
        subtitle: subtitle(restaurant),
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPage.routeName,
            arguments: restaurant.id,
          );
        },
      ),
    );
  }
}

class _RestaurantsGridView extends StatelessWidget {
  final int gridCount;
  final List<Restaurant> restaurants;

  const _RestaurantsGridView({
    Key? key,
    required this.gridCount,
    required this.restaurants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: gridCount,
      children:
          restaurants.map((e) => _buildRestaurantItem(context, e)).toList(),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    Hero image(Restaurant restaurant) {
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

    Row iconWithText({IconData? icon, required String text}) {
      return Row(
        children: [
          Icon(
            icon,
            size: 23,
          ),
          Text(
            text,
            style: txtThemeSub1?.copyWith(color: primaryColor),
          ),
        ],
      );
    }

    return RestaurantGridViewContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: backgroundColor,
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailPage.routeName,
          arguments: restaurant.id,
        );
      },
      child: Padding(
        // padding
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        // Container content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: image(restaurant),
            ),

            // name
            Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: txtThemeH5?.copyWith(color: secondaryColor),
            ),

            // location and rating
            iconWithText(
              icon: Icons.location_on,
              text: restaurant.city,
            ),
            iconWithText(
              icon: Icons.star,
              text: '${restaurant.rating}',
            ),
          ],
        ),
      ),
    );
  }
}
