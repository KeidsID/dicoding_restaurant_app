import 'dart:convert';

List<Restaurant> restaurantsFromJson(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);
  List<dynamic> restaurants = parsed['restaurants'];

  return restaurants.map((json) => Restaurant.fromJson(json)).toList();
}

class Restaurant {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late double rating;
  late Menus menus;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.menus,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: double.parse(json['rating'].toString()),
      menus: Menus.fromJson(json['menus']),
    );
  }
}

class Menus {
  late List<String> foods;
  late List<String> drinks;

  Menus({required this.foods, required this.drinks});

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: List<String>.from(json['foods'].map((e) => '${e['name']}')),
      drinks: List<String>.from(json['drinks'].map((e) => '${e['name']}')),
    );
  }
}
