import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/from_api/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class SearchResultProvider extends ChangeNotifier {
  final String query;
  final ApiService apiService;

  SearchResultProvider({required this.query, required this.apiService}) {
    _fetchAllRestaurants();
  }

  late SearchRestaurant _searchRestaurant;
  late ResultState _state;
  String _message = '';

  SearchRestaurant get result => _searchRestaurant;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> _fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final searchRestaurant = await apiService.getSearchRestaurant(query);
      if (searchRestaurant.error == true) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Error: No restaurant data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = searchRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = '$e';
    }
  }
}
