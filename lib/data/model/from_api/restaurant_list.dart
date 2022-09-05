// To parse this JSON data, do
//
//     final restaurantList = restaurantListFromJson(jsonString);

import 'dart:convert';

RestaurantList restaurantListFromJson(String str) {
  return RestaurantList.fromJson(json.decode(str));
}

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

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      pictureId: json["pictureId"],
      city: json["city"],
      rating: json["rating"].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "pictureId": pictureId,
      "city": city,
      "rating": rating,
    };
  }
}
