import 'dart:convert';

import 'restaurant.dart';

RestaurantList restaurantListFromJson(String str) =>
    RestaurantList.fromJson(json.decode(str));

String restaurantListToJson(RestaurantList data) => json.encode(data.toJson());

class RestaurantList {
  RestaurantList({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  factory RestaurantList.fromJson(Map<String, dynamic> json) {
    return RestaurantList(
      error: json["error"],
      message: json["message"],
      count: json["count"],
      restaurants: List<Restaurant>.from(
        json["restaurants"].map((x) => Restaurant.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "count": count,
      "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
    };
  }
}

