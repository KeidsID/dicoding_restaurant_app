import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/from_api/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class SearchResultProvider extends ChangeNotifier {
  final String _query;

  SearchResultProvider(this._query) {
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
      final searchRestaurant = await ApiService.getSearchRestaurant(_query);
      if (searchRestaurant.error == true) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'No Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _searchRestaurant = searchRestaurant;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'No Internet Connection';
    }
  }
}
