import 'package:flutter/material.dart';

import '../../data/api/api_service.dart';
import '../../data/model/from_api/restaurant_detail.dart';

enum ResultState { loading, noData, hasData, error }

class RestaurantDetailProvider extends ChangeNotifier {
  final String id;

  RestaurantDetailProvider({required this.id}) {
    fetchRestaurantDetail();
  }

  late RestaurantDetail _restaurantDetail;
  late ResultState _state;
  String _message = '';

  RestaurantDetail get result => _restaurantDetail;
  ResultState get state => _state;
  String get message => _message;

  Future<void> fetchRestaurantDetail() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final restaurantDetail =
          await ApiService.instance!.getRestaurantDetail(id);

      if (restaurantDetail.error) {
        _state = ResultState.noData;
        _message = restaurantDetail.message;
        notifyListeners();
        return;
      }

      _state = ResultState.hasData;
      _message = 'Fetch Data Success';
      _restaurantDetail = restaurantDetail;
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
