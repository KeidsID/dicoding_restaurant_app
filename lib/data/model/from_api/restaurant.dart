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
      id: json["id"] ?? 'null',
      name: json["name"] ?? 'null',
      description: json["description"] ?? 'null',
      pictureId: json["pictureId"] ?? 'null',
      city: json["city"] ?? 'null',
      rating: double.tryParse('${json["rating"]}') ?? 0.0,
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
