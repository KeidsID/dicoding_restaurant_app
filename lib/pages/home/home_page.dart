import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/model/from_api/restaurant.dart';

import '../detail/detail_page.dart';
import 'search_result_page.dart';
import 'wishlist_page.dart';

import '../../providers/notifications_provider.dart';
import '../../providers/preferences_provider.dart';
import '../../providers/restaurant_list_provider.dart';
import '../../utils/background_service.dart';
import '../../utils/notification_helper.dart';
import '../../utils/auth_service.dart';

import '../../widgets/locked_feature_dialog.dart';
import '../../widgets/search_text_field.dart';
import '../../widgets/list_pages/restaurant_grid_view.dart';
import '../../widgets/list_pages/restaurant_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isSearchMode;
  late TextEditingController _searchTextFieldCtrler;

  @override
  void initState() {
    super.initState();

    NotificationHelper.instance!.configureNotifResponse(DetailPage.routeName);

    _isSearchMode = false;
    _searchTextFieldCtrler = TextEditingController();
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
        child: Consumer<PreferencesProvider>(
          builder: (context, preferencesProv, _) {
            return ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: secondaryColor)),
                  ),
                  height: 55,
                  child: Center(
                    child: Text(
                      appName,
                      style: txtThemeH6?.copyWith(color: primaryColor),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Sign Out'),
                  onTap: () async {
                    await AuthService.signOut();
                  },
                ),
                const Divider(color: secondaryColor),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.dailyReminder),
                  trailing: Consumer<NotificationsProvider>(
                    builder: (_, notificationsProv, __) {
                      return Switch.adaptive(
                        value: preferencesProv.isDailyReminderActive,
                        onChanged: (value) {
                          if (!Platform.isAndroid) {
                            lockedFeatureDialog(context);
                          } else {
                            notificationsProv.scheduled(value);
                            preferencesProv.enableDailyReminder(value);
                          }
                        },
                        thumbColor: MaterialStateProperty.all(primaryColor),
                        inactiveTrackColor: primaryColorBrightest,
                        activeColor: secondaryColor,
                      );
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.notificationsTest,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: (preferencesProv.isNotifTestInProgress)
                      ? Text(
                          AppLocalizations.of(context)!.inProgress,
                          style: txtThemeSub1?.copyWith(color: secondaryColor),
                        )
                      : Text(
                          AppLocalizations.of(context)!.available,
                          style: txtThemeSub1?.copyWith(
                              color: primaryColorBrighter),
                        ),
                  onTap: () async {
                    if (!Platform.isAndroid) {
                      lockedFeatureDialog(context);
                    } else {
                      if (preferencesProv.isNotifTestInProgress) {
                        // do nothing
                      } else {
                        preferencesProv.enableNotifTest(true);
                        await Future.delayed(const Duration(seconds: 5));
                        await BackgroundService.notifTestCallback();
                        preferencesProv.enableNotifTest(false);
                      }
                    }
                  },
                ),
              ],
            );
          },
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
              onPressed: () {
                Navigator.pushNamed(context, WishlistPage.routeName);
              },
              icon: const Icon(Icons.bookmark_added_outlined),
              color: secondaryColor,
            ),
          ],
        );
      }
    } else {
      _isSearchMode = false;

      return AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(appName),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, WishlistPage.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: secondaryColor,
                shadowColor: primaryColorBrightest,
              ),
              child: Row(
                children: const [
                  Icon(Icons.bookmark_added_outlined),
                  SizedBox(width: 8),
                  Text('WISHLIST'),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 250,
                  child: SearchTextField(controller: _searchTextFieldCtrler),
                ),
                const SizedBox(width: 16),
                IconButton(
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
              ],
            )
          ],
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
              return RestaurantsListView(
                listItem: restaurants,
              );
            } else if (constraints.maxWidth <= 900) {
              return RestaurantsGridView(
                gridCount: 2,
                listItem: restaurants,
              );
            } else if (constraints.maxWidth <= 1200) {
              return RestaurantsGridView(
                gridCount: 3,
                listItem: restaurants,
              );
            } else {
              return RestaurantsGridView(
                gridCount: 4,
                listItem: restaurants,
              );
            }
          },
        );
      },
    );
  }
}
