import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:restaurant_app_project/data/model/from_api/restaurant_detail.dart';
import 'package:restaurant_app_project/data/model/from_api/search_restaurant.dart';

import 'api_service_test.mocks.dart';
import 'package:restaurant_app_project/data/api/api_service.dart';
import 'package:restaurant_app_project/data/model/from_api/restaurant_list.dart';

void main() {
  group('getRestaurantList test:', () {
    final client = MockClient();

    test('Return RestaurantList if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/list')),
      ).thenAnswer((_) async {
        return http.Response(
          '''
        {
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": 4.2
            }
          ]
        }
        ''',
          200,
        );
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
        return http.Response(
          '''
        {
          "error": false,
          "message": "success",
          "count": 1,
          "restaurants": [
            {
              "id": "rqdv5juczeskfw1e867",
              "name": null,
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
              "pictureId": "14",
              "city": "Medan",
              "rating": null
            }
          ]
        }
        ''',
          200,
        );
      });

      final response = await client.get(
        Uri.parse('${ApiService.baseUrl}/list'),
      );
      dynamic result = (response.statusCode == 200)
          ? restaurantListFromJson(response.body)
          : Exception('Failed');
      expect(result, isA<RestaurantList>());
    });
  });

  group('getRestaurantDetail test:', () {
    final client = MockClient();
    const id = 'rqdv5juczeskfw1e867';

    test('Return RestaurantDetail if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')),
      ).thenAnswer((_) async {
        return http.Response(
          '''
{
    "error": false,
    "message": "success",
    "restaurant": {
        "id": "$id",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
        "city": "Medan",
        "address": "Jln. Pandeglang no 19",
        "pictureId": "14",
        "categories": [
            {
                "name": "Italia"
            },
            {
                "name": "Modern"
            }
        ],
        "menus": {
            "foods": [
                {
                    "name": "Paket rosemary"
                },
                {
                    "name": "Toastie salmon"
                }
            ],
            "drinks": [
                {
                    "name": "Es krim"
                },
                {
                    "name": "Sirup"
                }
            ]
        },
        "rating": 4.2,
        "customerReviews": [
            {
                "name": "Ahmad",
                "review": "Tidak rekomendasi untuk pelajar!",
                "date": "13 November 2019"
            }
        ]
    }
}
        ''',
          200,
        );
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

  test('getSearchRestaurant test', () async {
    const randomQuery = 'nucenoe1j';

    expect(
      await ApiService.getSearchRestaurant(randomQuery),
      isA<SearchRestaurant>(),
    );
  });
}
