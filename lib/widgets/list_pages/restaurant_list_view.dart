import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant.dart';
import '../../pages/detail/detail_page.dart';
import '../../providers/data/db_provider.dart';
import 'restaurant_list_tile.dart';

/// Potrait layout for restaurant list
class RestaurantsListView extends StatelessWidget {
  final List<Restaurant> listItem;
  final bool isPushReplacement;

  const RestaurantsListView(
      {Key? key, required this.listItem, this.isPushReplacement = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItem.length,
      itemBuilder: (context, index) {
        return _buildRestaurantItem(context, listItem[index]);
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    Hero leading(Restaurant restaurant) {
      return Hero(
        tag: restaurant.id,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/photo_error_icon.png',
          image: ApiService.instance!.imageSmall(restaurant.pictureId),
          width: 100,
          fit: BoxFit.fill,
          placeholderFit: BoxFit.contain,
        ),
      );
    }

    Text title(Restaurant restaurant, BuildContext context) {
      return Text(
        restaurant.name,
        style: txtThemeH6?.copyWith(color: secondaryColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

    return Consumer<DbProvider>(
      builder: (context, dbProv, child) {
        return FutureBuilder<bool>(
          future: dbProv.isListed(restaurant.id),
          builder: (context, snapshot) {
            bool isBookmarked = snapshot.data ?? false;

            return Material(
              child: RestaurantListTile(
                leading: leading(restaurant),
                title: title(restaurant, context),
                subtitle: subtitle(restaurant),
                trailing: (isBookmarked)
                    ? IconButton(
                        onPressed: () => dbProv.removeWishlist(restaurant.id),
                        icon: const Icon(Icons.bookmark),
                        color: secondaryColor,
                      )
                    : IconButton(
                        onPressed: () => dbProv.addWishlist(restaurant),
                        icon: const Icon(Icons.bookmark_border),
                        color: secondaryColor,
                      ),
                onTap: (isPushReplacement)
                    ? () {
                        Navigator.pushReplacementNamed(
                          context,
                          DetailPage.routeName,
                          arguments: restaurant.id,
                        );
                      }
                    : () {
                        Navigator.pushNamed(
                          context,
                          DetailPage.routeName,
                          arguments: restaurant.id,
                        );
                      },
              ),
            );
          },
        );
      },
    );
  }
}
