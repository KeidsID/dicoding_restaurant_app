import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_list.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantListProvider extends ChangeNotifier {
  RestaurantListProvider() {
    fetchAllRestaurants();
  }

  late RestaurantList _restaurantList;
  late ResultState _state;
  String _message = '';

  RestaurantList get result => _restaurantList;
  ResultState get state => _state;
  String get message => _message;

  /// Fetching [RestaurantList] data from API and stored on provider
  /// as [result]
  Future<void> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurants = await ApiService.instance!.getRestaurantList();

      if (restaurants.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = restaurants.message;
        notifyListeners();
        return;
      }

      _state = ResultState.hasData;
      _message = 'Fetch data success';
      _restaurantList = restaurants;
      notifyListeners();
      return;
    } catch (e) {
      _state = ResultState.error;
      _message = '$e';
      notifyListeners();
      return;
    }
  }
}
