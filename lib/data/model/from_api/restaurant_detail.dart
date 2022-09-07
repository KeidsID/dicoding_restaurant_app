// To parse this JSON data, do
//
//     final restaurantDetail = restaurantDetailFromJson(jsonString);

import 'dart:convert';

RestaurantDetail restaurantDetailFromJson(String str) =>
    RestaurantDetail.fromJson(json.decode(str));

String restaurantDetailToJson(RestaurantDetail data) =>
    json.encode(data.toJson());

class RestaurantDetail {
  RestaurantDetail({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  final bool error;
  final String message;
  final DetailedRestaurant restaurant;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) =>
      RestaurantDetail(
        error: json["error"],
        message: json["message"],
        restaurant: DetailedRestaurant.fromJson(json["restaurant"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "restaurant": restaurant.toJson(),
      };
}

class DetailedRestaurant {
  DetailedRestaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.categories,
    required this.menus,
    required this.customerReviews,
  });

  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<Category> categories;
  final Menus menus;
  final List<CustomerReview> customerReviews;

  factory DetailedRestaurant.fromJson(Map<String, dynamic> json) {
    return DetailedRestaurant(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      city: json["city"],
      address: json["address"],
      pictureId: json["pictureId"],
      rating: json["rating"].toDouble(),
      categories: List<Category>.from(
        json["categories"].map((x) => Category.fromJson(x)),
      ),
      menus: Menus.fromJson(json["menus"]),
      customerReviews: List<CustomerReview>.from(
        json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "city": city,
      "address": address,
      "pictureId": pictureId,
      "rating": rating,
      "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
      "menus": menus.toJson(),
      "customerReviews":
          List<dynamic>.from(customerReviews.map((x) => x.toJson())),
    };
  }
}

class Category {
  Category({required this.name});

  final String name;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"name": name};
}

class CustomerReview {
  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  final String name;
  final String review;
  final DateTime date;

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    String dateString = json['date'];
    List<String> splittedDateString = dateString.split(' ');

    String getDate = splittedDateString[0].length == 1
        ? splittedDateString[0].padLeft(2, '0')
        : splittedDateString[0];
    late String getMonth;
    switch (splittedDateString[1]) {
      case 'Januari':
        getMonth = '01';
        break;
      case 'Febuari':
        getMonth = '02';
        break;
      case 'Maret':
        getMonth = '3';
        break;
      case 'April':
        getMonth = '04';
        break;
      case 'Mei':
        getMonth = '05';
        break;
      case 'Juni':
        getMonth = '06';
        break;
      case 'Juli':
        getMonth = '07';
        break;
      case 'Agustus':
        getMonth = '08';
        break;
      case 'September':
        getMonth = '09';
        break;

      case 'Oktober':
        getMonth = '10';
        break;
      case 'November':
        getMonth = '11';
        break;
      case 'Desember':
        getMonth = '12';
        break;
      default:
        getMonth = '12';
    }
    String getYear = splittedDateString[2];

    String formattedString = '$getYear-$getMonth-$getDate';

    return CustomerReview(
      name: json["name"],
      review: json["review"],
      date: DateTime.parse(formattedString),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "review": review,
      "date": date,
    };
  }
}

class Menus {
  Menus({
    required this.foods,
    required this.drinks,
  });

  final List<Category> foods;
  final List<Category> drinks;

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: List<Category>.from(
        json["foods"].map((x) => Category.fromJson(x)),
      ),
      drinks: List<Category>.from(
        json["drinks"].map((x) => Category.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
      "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
    };
  }
}