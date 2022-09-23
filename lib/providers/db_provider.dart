import 'package:flutter/material.dart';

import '../data/db/database_helper.dart';
import '../data/model/from_api/restaurant.dart';

enum DbState { loading, noData, hasData, error }

class DbProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DbProvider({required this.databaseHelper}) {
    _getWishlist();
  }

  late DbState _state;
  DbState get state => _state;

  String _message = '';
  String get message => _message;

  List<Restaurant> _bookmarks = [];
  List<Restaurant> get bookmarks => _bookmarks;

  void _getWishlist() async {
    _bookmarks = await databaseHelper.getWishlist();
    if (_bookmarks.isNotEmpty) {
      _state = DbState.hasData;
    } else {
      _state = DbState.noData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  Future<void> addWishlist(Restaurant restaurant) async {
    try {
      await databaseHelper.insertWishlist(restaurant);
      _getWishlist();
    } catch (e) {
      _state = DbState.error;
      _message = '$e';
      notifyListeners();
    }
  }

  Future<bool> isListed(String id) async {
    final article = await databaseHelper.getWishlistById(id);
    return article.isNotEmpty;
  }

  Future<void> removeWishlist(String id) async {
    try {
      await databaseHelper.deleteWishlist(id);
      _getWishlist();
    } catch (e) {
      _state = DbState.error;
      _message = '$e';
      notifyListeners();
    }
  }
}
