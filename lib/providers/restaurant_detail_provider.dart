import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/from_api/restaurant_detail.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final String id;
  final ApiService apiService;

  RestaurantDetailProvider({required this.id,  required this.apiService}) {
    _fetchRestaurantDetail();
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  RestaurantDetail get result => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _fetchRestaurantDetail() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurantDetail = await apiService.getRestaurantDetail(id);
      if (restaurantDetail.error == true) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = restaurantDetail.message;
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _restaurantDetail = restaurantDetail;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
