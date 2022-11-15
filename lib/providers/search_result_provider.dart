import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/model/from_api/search_restaurant.dart';

enum ResultState { loading, noData, hasData, error }

class SearchResultProvider extends ChangeNotifier {
  final String query;

  SearchResultProvider({required this.query}) {
    fetchSearchResult();
  }

  late SearchRestaurant _searchRestaurant;
  late ResultState _state;
  String _message = '';

  SearchRestaurant get result => _searchRestaurant;
  ResultState get state => _state;
  String get message => _message;

  Future<void> fetchSearchResult() async {
    _state = ResultState.loading;
    notifyListeners();

    try {
      final searchRestaurant =
          await ApiService.instance!.getSearchRestaurant(query);

      if (searchRestaurant.error) {
        _state = ResultState.noData;
        _message = 'Error no Data';
        notifyListeners();
        return;
      }

      _state = ResultState.hasData;
      _message = 'Success';
      _searchRestaurant = searchRestaurant;
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
