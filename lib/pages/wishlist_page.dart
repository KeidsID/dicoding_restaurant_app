import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/providers/db_provider.dart';

import '../common/common.dart';
import '../widgets/for_restaurant_list_page/restaurant_grid_view.dart';
import '../widgets/for_restaurant_list_page/restaurant_list_view.dart';

class WishlistPage extends StatelessWidget {
  static String routeName = '/wishlist_page';

  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$appName Wishlist'),
      ),
      body: Consumer<DbProvider>(
        builder: (_, dbProv, __) {
          if (dbProv.state == DbState.loading) {
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
            if (dbProv.state == DbState.hasData) {
              // success widget
            } else if (dbProv.state == DbState.noData) {
              // no data
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.noDbData,
                  style: txtThemeH4?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (dbProv.state == DbState.error) {
              // error widget
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.noDbData,
                  style: txtThemeH4?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: Text(
                  dbProv.message,
                  style: txtThemeH4?.copyWith(color: secondaryColor),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }

          return LayoutBuilder(
            builder: (_, constraints) {
              if (constraints.maxWidth <= 750) {
                return RestaurantsListView(
                  listItem: dbProv.bookmarks,
                );
              } else if (constraints.maxWidth <= 900) {
                return RestaurantsGridView(
                  gridCount: 2,
                  listItem: dbProv.bookmarks,
                );
              } else if (constraints.maxWidth <= 1200) {
                return RestaurantsGridView(
                  gridCount: 3,
                  listItem: dbProv.bookmarks,
                );
              } else {
                return RestaurantsGridView(
                  gridCount: 4,
                  listItem: dbProv.bookmarks,
                );
              }
            },
          );
        },
      ),
    );
  }
}
