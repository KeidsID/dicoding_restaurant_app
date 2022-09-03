import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../common/styles/style.dart';
import '../data/model/from_assets/restaurant.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.

    await Future.delayed(const Duration(seconds: 1));

    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        centerTitle: true,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder<String>(
      future:
          DefaultAssetBundle.of(context).loadString('assets/restaurants.json'),
      builder: (context, snapshot) {
        /// future error handler
        if (snapshot.connectionState != ConnectionState.done) {
          // loading widget
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            // success widget
          } else if (snapshot.hasError) {
            // error widget
            return Center(
              child: Text(
                '${snapshot.error}',
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: secondaryColor),
              ),
            );
          } else {
            // loading widget
            return const Center(child: CircularProgressIndicator());
          }
        }

        final List<Restaurant> restaurants = restaurantsFromJson(snapshot.data);

        return LayoutBuilder(builder: (_, constraints) {
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
        });
      },
    );
  }
}

class _RestaurantsListView extends StatelessWidget {
  final List<Restaurant> restaurants;

  const _RestaurantsListView(this.restaurants, {super.key});

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
          restaurant.pictureId,
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
      child: ListTile(
        leading: leading(restaurant),
        title: title(restaurant, context),
        subtitle: subtitle(restaurant),
        isThreeLine: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPage.routeName,
            arguments: restaurant,
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
    super.key,
    required this.gridCount,
    required this.restaurants,
  });

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
          restaurant.pictureId,
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

    return Material(
      // decoration
      color: backgroundColor,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            DetailPage.routeName,
            arguments: restaurant,
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
      ),
    );
  }
}
