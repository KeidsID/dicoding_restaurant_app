import 'dart:convert';

import 'package:restaurant_app_project/data/model/from_api/restaurant.dart';

SearchRestaurant searchRestaurantFromJson(String str) =>
    SearchRestaurant.fromJson(json.decode(str));

String searchRestaurantToJson(SearchRestaurant data) =>
    json.encode(data.toJson());

class SearchRestaurant {
  SearchRestaurant({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  final bool error;
  final int founded;
  final List<Restaurant> restaurants;

  factory SearchRestaurant.fromJson(Map<String, dynamic> json) {
    return SearchRestaurant(
      error: json["error"],
      founded: json["founded"],
      restaurants: List<Restaurant>.from(
        json["restaurants"].map((x) => Restaurant.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "founded": founded,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}
