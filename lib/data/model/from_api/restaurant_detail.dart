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
  final RestaurantDetailed restaurant;

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      error: json["error"],
      message: json["message"],
      restaurant: RestaurantDetailed.fromJson(json["restaurant"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error,
      "message": message,
      "restaurant": restaurant.toJson(),
    };
  }
}

class RestaurantDetailed {
  RestaurantDetailed({
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

  factory RestaurantDetailed.fromJson(Map<String, dynamic> json) {
    List<CustomerReview> customerReviews = List<CustomerReview>.from(
      json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
    );

    // sort to newest review
    customerReviews.sort((a, b) => b.date.compareTo(a.date));

    return RestaurantDetailed(
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
      customerReviews: customerReviews,
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
      "customerReviews": List<dynamic>.from(
        customerReviews.map((x) => x.toJson()),
      ),
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
    String formattedDateString = _dateStringFormatter(json['date']);

    return CustomerReview(
      name: json["name"],
      review: json["review"],
      date: DateTime.parse(formattedDateString),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "review": review,
      "date": _dateTimeFormatter(date),
    };
  }
}

/// Format the date string on the **CustomerReview** object in the JSON API,
/// so that strings can be parsed to DateTime.
///
/// ```dart
/// String formattedDateString = _dateStringFormatter("2 Mei 2002"); // "2002-05-02"
/// DateTime reviewDate = DateTime.parse(formattedDateString); // Possible to do
/// ```
String _dateStringFormatter(String dateString) {
  List<String> splittedDateString = dateString.split(' ');

  String date = splittedDateString[0].length == 1
      ? splittedDateString[0].padLeft(2, '0')
      : splittedDateString[0];

  late String month;
  switch (splittedDateString[1]) {
    case 'Januari':
      month = '01';
      break;
    case 'Februari':
      month = '02';
      break;
    case 'Maret':
      month = '03';
      break;
    case 'April':
      month = '04';
      break;
    case 'Mei':
      month = '05';
      break;
    case 'Juni':
      month = '06';
      break;
    case 'Juli':
      month = '07';
      break;
    case 'Agustus':
      month = '08';
      break;
    case 'September':
      month = '09';
      break;
    case 'Oktober':
      month = '10';
      break;
    case 'November':
      month = '11';
      break;
    case 'Desember':
      month = '12';
      break;
  }

  String year = splittedDateString[2];

  return '$year-$month-$date';
}

/// Format the DateTime on CustomerReview object to JSON API format
///
/// ```dart
/// String formattedDateTime = _dateTimeFormatter(DateTime("2002-05-02"));
/// print(formattedDateTime); // "2 Mei 2002"
/// ```
String _dateTimeFormatter(DateTime time) {
  final date = '${time.day}';
  final year = '${time.year}';
  late String month;
  switch (time.month) {
    case 1:
      month = 'Januari';
      break;
    case 2:
      month = 'Februari';
      break;
    case 3:
      month = 'Maret';
      break;
    case 4:
      month = 'April';
      break;
    case 5:
      month = 'Mei';
      break;
    case 6:
      month = 'Juni';
      break;
    case 7:
      month = 'Juli';
      break;
    case 8:
      month = 'Agustus';
      break;
    case 9:
      month = 'September';
      break;
    case 10:
      month = 'Oktober';
      break;
    case 11:
      month = 'November';
      break;
    case 12:
      month = 'Desember';
      break;
  }

  return '$date $month $year';
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
