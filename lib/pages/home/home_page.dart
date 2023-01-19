import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/model/from_api/restaurant.dart';
import '../../providers/api/restaurant_list_provider.dart';
import '../../providers/data/notifications_provider.dart';
import '../../providers/data/preferences_provider.dart';
import '../../utils/auth_service.dart';
import '../../utils/background_service.dart';
import '../../utils/notification_helper.dart';
import '../../widgets/list_pages/restaurant_grid_view.dart';
import '../../widgets/list_pages/restaurant_list_view.dart';
import '../../widgets/locked_feature_dialog.dart';
import '../../widgets/search_text_field.dart';
import '../detail/detail_page.dart';
import 'about_app_page.dart';
import 'wishlist_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchTextFieldCtrler;

  bool _isSearchMode = false;

  @override
  void initState() {
    NotificationHelper.instance!.configureNotifResponse(DetailPage.routeName);

    _searchTextFieldCtrler = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchTextFieldCtrler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(screenSize: screenSize(context), appName: appName),
      body: _body(context),
      drawer: _drawer(context),
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
          title: SizedBox(
            height: kToolbarHeight,
            child: SearchTextField(controller: _searchTextFieldCtrler),
          ),
        );
      } else {
        return AppBar(
          title: Text(appName),
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
            SizedBox(
              width: 350,
              height: kToolbarHeight,
              child: SearchTextField(controller: _searchTextFieldCtrler),
            ),
          ],
        ),
      );
    }
  }

  Widget _body(BuildContext context) {
    return Consumer<RestaurantListProvider>(
      builder: (context, rListProv, _) {
        if (rListProv.state == ResultState.loading) {
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

        if (rListProv.state == ResultState.noData) {
          return SizedBox.expand(
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
                    rListProv.fetchAllRestaurants();
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        if (rListProv.state == ResultState.error) {
          return SizedBox.expand(
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
                    rListProv.fetchAllRestaurants();
                  },
                  icon: const Icon(Icons.restart_alt),
                  label: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        final List<Restaurant> restaurants = rListProv.result.restaurants;

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

  Drawer _drawer(BuildContext context) {
    final User? firebaseUser = Provider.of<User?>(context);
    final String displayName = firebaseUser!.displayName ?? 'Anonymous';
    final String email =
        firebaseUser.email ?? AppLocalizations.of(context)!.emailNotAvailable;

    return Drawer(
      child: Consumer<PreferencesProvider>(
        builder: (context, preferencesProv, _) {
          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
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
                    const SizedBox(height: 8),
                    Text(
                      displayName,
                      style: txtThemeH6!.copyWith(color: secondaryColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      email,
                      style: txtThemeSub1!.copyWith(
                        color: primaryColor.withOpacity(0.75),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const Divider(color: secondaryColor),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Sign Out'),
                onTap: () async {
                  if (!firebaseUser.isAnonymous) {
                    await AuthService.signOut();
                  } else {
                    await firebaseUser.delete();
                  }
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
                        style:
                            txtThemeSub1?.copyWith(color: primaryColorBrighter),
                      ),
                onTap: () async {
                  if (!Platform.isAndroid) {
                    lockedFeatureDialog(context);
                  } else {
                    if (!preferencesProv.isNotifTestInProgress) {
                      preferencesProv.enableNotifTest(true);
                      await Future.delayed(const Duration(seconds: 5));
                      await BackgroundService.notifTestCallback();
                      preferencesProv.enableNotifTest(false);
                    }
                  }
                },
              ),
              const Divider(color: secondaryColor),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(AppLocalizations.of(context)!.appInfo),
                onTap: () {
                  Navigation.pushNamed(AboutAppPage.routeName);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
