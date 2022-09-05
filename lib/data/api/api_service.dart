import 'package:http/http.dart' as http;

import '../model/from_api/restaurant_list.dart';
import '../model/from_api/restaurant_detail.dart';
import '../model/from_api/search_restaurant.dart';

class ApiService {
  static const _baseUrl = 'https://restaurant-api.dicoding.dev';

  static Future<RestaurantList> getRestaurantList() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return restaurantListFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  static Future<RestaurantDetail> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return restaurantDetailFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  static Future<SearchRestaurant> getSearchRestaurant(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return searchRestaurantFromJson(response.body);
    } else {
      throw Exception('Failed to Get Restaurant Data');
    }
  }

  static String imageSmall(String pictureId) {
    return '$_baseUrl/images/small/$pictureId';
  }

  static String imageMedium(String pictureId) {
    return '$_baseUrl/images/medium/$pictureId';
  }

  static String imageLarge(String pictureId) {
    return '$_baseUrl/images/large/$pictureId';
  }
}
