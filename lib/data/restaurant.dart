import 'dart:convert';

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

  Restaurant.fromJson(
    Map<String, dynamic> restaurant,
  ) {
    id = restaurant['id']; // restaurant['keyJSON']
    name = restaurant['name'];
    description = restaurant['description'];
    pictureId = restaurant['pictureId'];
    city = restaurant['city'];
    rating = double.parse(restaurant['rating'].toString());

    Map<String, dynamic> menusJson = restaurant['menus'];
    List<dynamic> foods = menusJson['foods'];
    List<dynamic> drinks = menusJson['drinks'];

    menus = Menus(
      foods: foods.map((e) => '${e['name']}').toList(),
      drinks: drinks.map((e) => '${e['name']}').toList(),
    );
  }
}

class Menus {
  late List<String> foods;
  late List<String> drinks;

  Menus({required this.foods, required this.drinks});
}

List<Restaurant> parseRestaurants(String? json) {
  if (json == null) {
    return [];
  }

  final Map<String, dynamic> parsed = jsonDecode(json);
  List<dynamic> restaurants = parsed['restaurants'];

  return restaurants.map((json) => Restaurant.fromJson(json)).toList();
}
