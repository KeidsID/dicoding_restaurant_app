import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant.dart';
import '../../pages/detail/detail_page.dart';
import '../../providers/db_provider.dart';
import 'grid_view_container.dart';

class RestaurantsGridView extends StatelessWidget {
  final int gridCount;
  final List<Restaurant> listItem;
  final bool isPushReplacement;

  const RestaurantsGridView({
    Key? key,
    this.gridCount = 1,
    required this.listItem,
    this.isPushReplacement = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: gridCount,
      children: listItem.map((e) => _buildRestaurantItem(context, e)).toList(),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    Hero image(Restaurant restaurant) {
      return Hero(
        tag: restaurant.id,
        child: FadeInImage.assetNetwork(
          placeholder: 'assets/images/photo_error_icon.png',
          image: ApiService.instance!.imageSmall(restaurant.pictureId),
          fit: BoxFit.fill,
          placeholderFit: BoxFit.contain,
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

    return GridViewContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: backgroundColor,
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
      child: Padding(
        // padding
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        // Container content
        child: Consumer<DbProvider>(
          builder: (_, dbProv, __) {
            return FutureBuilder<bool>(
              future: dbProv.isListed(restaurant.id),
              builder: (context, snapshot) {
                bool isBookmarked = snapshot.data ?? false;

                Widget iconButton = (isBookmarked)
                    ? ElevatedButton(
                        onPressed: () => dbProv.removeWishlist(restaurant.id),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          foregroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Icon(Icons.bookmark),
                      )
                    : ElevatedButton(
                        onPressed: () => dbProv.addWishlist(restaurant),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.5),
                          foregroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Icon(Icons.bookmark_border),
                      );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Expanded(
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        fit: StackFit.expand,
                        children: [
                          image(restaurant),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: iconButton,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
