import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';
import 'package:restaurant_app_project/data/api/api_service.dart';
import 'package:restaurant_app_project/data/model/from_api/restaurant_list.dart';
import 'package:restaurant_app_project/data/model/from_api/restaurant_detail.dart';
import 'package:restaurant_app_project/data/model/from_api/search_restaurant.dart';

import 'mock_client_responses.dart';

void main() {
  group('getRestaurantList test:', () {
    final client = MockClient();

    test('Return RestaurantList if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/list')),
      ).thenAnswer((_) async {
        return http.Response(getRestaurantListResponse1, 200);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/list'),
      );
      dynamic result = (response.statusCode == 200)
          ? restaurantListFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<RestaurantList>());
    });

    test('Throw an error if the HTTP call fails', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/list')),
      ).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/list'),
      );
      dynamic result = (response.statusCode == 200)
          ? restaurantListFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<Exception>());
    });

    test(
      'Return RestaurantList even if JSON Restaurant object contains null property value',
      () async {
        when(
          client.get(Uri.parse('${ApiService.baseUrl}/list')),
        ).thenAnswer((_) async {
          return http.Response(getRestaurantListResponse2, 200);
        });

        final response = await client.get(
          Uri.parse('${ApiService.baseUrl}/list'),
        );
        dynamic result = (response.statusCode == 200)
            ? restaurantListFromJson(response.body)
            : Exception('Failed');
        expect(result, isA<RestaurantList>());
      },
    );
  });

  group('getRestaurantDetail test:', () {
    final client = MockClient();
    const id = 'rqdv5juczeskfw1e867';

    test('Return RestaurantDetail if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')),
      ).thenAnswer((_) async {
        return http.Response(getRestaurantDetailResponse, 200);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/detail/$id'),
      );
      dynamic result = (response.statusCode == 200)
          ? restaurantDetailFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<RestaurantDetail>());
    });

    test('Throw an error if the HTTP call fails', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')),
      ).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/detail/$id'),
      );
      dynamic result = (response.statusCode == 200)
          ? restaurantListFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<Exception>());
    });
  });

  group('getSearchRestaurant test:', () {
    final client = MockClient();

    test('Return SearchRestaurant if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/search?q=makan')),
      ).thenAnswer((_) async {
        return http.Response(getSearchRestaurantResponse1, 200);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/search?q=makan'),
      );
      dynamic result = (response.statusCode == 200)
          ? searchRestaurantFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<SearchRestaurant>());
    });

    test('Throw an error if the HTTP call fails', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/search?q=makan')),
      ).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/search?q=makan'),
      );
      dynamic result = (response.statusCode == 200)
          ? searchRestaurantFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<Exception>());
    });

    test(
        'Return SearchRestaurant even if JSON Restaurant object contains null property value',
        () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/search?q=makan')),
      ).thenAnswer((_) async {
        return http.Response(getSearchRestaurantResponse2, 200);
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/search?q=makan'),
      );
      dynamic result = (response.statusCode == 200)
          ? searchRestaurantFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<SearchRestaurant>());
    });
  });
}
