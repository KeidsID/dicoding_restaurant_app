import 'package:http/http.dart' as http;

import '../model/from_api/restaurant_list.dart';
import '../model/from_api/restaurant_detail.dart';
import '../model/from_api/search_restaurant.dart';

class ApiService {
  final http.Client client;
  static ApiService? instance;

  ApiService._internal(this.client) {
    instance = this;
  }

  factory ApiService({required http.Client client}) {
    return instance ?? ApiService._internal(client);
  }

  static const baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantList> getRestaurantList() async {
    final response = await client.get(Uri.parse('$baseUrl/list'));
    if (response.statusCode == 200) {
      return restaurantListFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await client.get(Uri.parse('$baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return restaurantDetailFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  Future<SearchRestaurant> getSearchRestaurant(String query) async {
    final response = await client.get(Uri.parse('$baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return searchRestaurantFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  String imageSmall(String pictureId) {
    return '$baseUrl/images/small/$pictureId';
  }

  String imageMedium(String pictureId) {
    return '$baseUrl/images/medium/$pictureId';
  }

  String imageLarge(String pictureId) {
    return '$baseUrl/images/large/$pictureId';
  }
}
