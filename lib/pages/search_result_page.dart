import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_project/providers/search_result_provider.dart';

import 'home_page.dart';
import 'detail_page.dart';
import '../styles/style.dart';
import '../data/api/api_service.dart';
import '../data/model/from_api/search_restaurant.dart';
import '../widgets/fade_on_scroll.dart';
import '../widgets/restaurant_list_tile.dart';
import '../widgets/restaurant_grid_view_container.dart';

class SearchResultPage extends StatefulWidget {
  static String routeName = '/search_result_page';
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
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
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SearchResultProvider(widget.query),
        child: Consumer<SearchResultProvider>(
          builder: (context, searchResultProvider, _) {
            if (searchResultProvider.state == ResultState.loading) {
              // loading widget
              return const Center(child: CircularProgressIndicator());
            } else {
              if (searchResultProvider.state == ResultState.hasData) {
                // success widget
              } else if (searchResultProvider.state == ResultState.noData) {
                // no data
                return Center(
                  child: Text(
                    searchResultProvider.message,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (searchResultProvider.state == ResultState.error) {
                // error widget
                return Center(
                  child: Text(
                    searchResultProvider.message,
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
                    searchResultProvider.message,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: secondaryColor),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }

            final founded = searchResultProvider.result.founded;
            final restaurants = searchResultProvider.result.restaurants;

            return SafeArea(
              child: NestedScrollView(
                controller: scrollController,
                headerSliverBuilder: (context, isScrolled) {
                  return _sliverAppBar(context, founded);
                },
                body: _buildResultList(restaurants),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _sliverAppBar(BuildContext context, int resultCount) {
    Widget title() {
      return FadeOnScroll(
        scrollController: scrollController,
        fullOpacityOffset: 125,
        child: Text(
          appName,
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: primaryColor),
        ),
      );
    }

    Widget flexibleSpaceBackground() {
      return Center(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: primaryColorBrighter),
            ),
          ),
          child: Text(
            '$resultCount restaurants found',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                ?.copyWith(color: primaryColor),
          ),
        ),
      );
    }

    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 125,
        flexibleSpace: FlexibleSpaceBar(
          title: title(),
          background: flexibleSpaceBackground(),
          centerTitle: true,
        ),
      ),
    ];
  }

  LayoutBuilder _buildResultList(List<Restaurant> restaurants) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth <= 600) {
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
        style: Theme.of(context)
            .textTheme
            .headline6
            ?.copyWith(color: secondaryColor),
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
          Navigator.pushReplacementNamed(
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

    Row iconWithText(BuildContext context,
        {IconData? icon, required String text}) {
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
          ),
        ],
      );
    }

    return RestaurantGridViewContainer(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      color: backgroundColor,
      onTap: () {
        Navigator.pushReplacementNamed(
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
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  ?.copyWith(color: secondaryColor),
            ),

            // location and rating
            iconWithText(
              context,
              icon: Icons.location_on,
              text: restaurant.city,
            ),
            iconWithText(
              context,
              icon: Icons.star,
              text: '${restaurant.rating}',
            ),
          ],
        ),
      ),
    );
  }
}
