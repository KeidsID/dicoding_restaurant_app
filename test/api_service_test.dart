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
  final client = MockClient();
  setUp(() => ApiService(client: client));
  group(
    'getRestaurantList test:',
    () {
      test('Return RestaurantList if the HTTP call completes', () async {
        when(
          client.get(Uri.parse('${ApiService.baseUrl}/list')),
        ).thenAnswer((_) async {
          return http.Response(getRestaurantListResponse1, 200);
        });

        expect(
          await ApiService.instance!.getRestaurantList(),
          isA<RestaurantList>(),
        );
      });

      test('Throw an error if the HTTP call fails', () {
        when(
          client.get(Uri.parse('${ApiService.baseUrl}/list')),
        ).thenAnswer((_) async {
          return http.Response('Not Found', 404);
        });

        expect(
          ApiService.instance!.getRestaurantList(),
          throwsException,
        );
      });

      test(
        'Return RestaurantList even if JSON Restaurant object contains null property value',
        () async {
          when(
            client.get(Uri.parse('${ApiService.baseUrl}/list')),
          ).thenAnswer((_) async {
            return http.Response(getRestaurantListResponse2, 200);
          });

          expect(
            await ApiService.instance!.getRestaurantList(),
            isA<RestaurantList>(),
          );
        },
      );
    },
  );

  group('getRestaurantDetail test:', () {
    const id = 'rqdv5juczeskfw1e867';

    test('Return RestaurantDetail if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')),
      ).thenAnswer((_) async {
        return http.Response(getRestaurantDetailResponse, 200);
      });

      expect(
        await ApiService.instance!.getRestaurantDetail(id),
        isA<RestaurantDetail>(),
      );
    });

    test('Throw an error if the HTTP call fails', () {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/detail/$id')),
      ).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      expect(
        ApiService.instance!.getRestaurantDetail(id),
        throwsException,
      );
    });
  });

  group('getSearchRestaurant test:', () {
    const String query = 'makan';

    test('Return SearchRestaurant if the HTTP call completes', () async {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/search?q=$query')),
      ).thenAnswer((_) async {
        return http.Response(getSearchRestaurantResponse1, 200);
      });

      expect(
        await ApiService.instance!.getSearchRestaurant(query),
        isA<SearchRestaurant>(),
      );
    });

    test('Throw an error if the HTTP call fails', () {
      when(
        client.get(Uri.parse('${ApiService.baseUrl}/search?q=$query')),
      ).thenAnswer((_) async {
        return http.Response('Not Found', 404);
      });

      expect(
        ApiService.instance!.getSearchRestaurant(query),
        throwsException,
      );
    });

    test(
      'Return SearchRestaurant even if JSON Restaurant object contains null property value',
      () async {
        when(
          client.get(Uri.parse('${ApiService.baseUrl}/search?q=$query')),
        ).thenAnswer((_) async {
          return http.Response(getSearchRestaurantResponse2, 200);
        });

        expect(
          await ApiService.instance!.getSearchRestaurant(query),
          isA<SearchRestaurant>(),
        );
      },
    );
  });
}
