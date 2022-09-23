const String getRestaurantListResponse1 = '''
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
''';

const String getRestaurantListResponse2 = '''
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
''';

const String getRestaurantDetailResponse = '''
{
  "error": false,
  "message": "success",
  "restaurant": {
    "id": "rqdv5juczeskfw1e867",
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
''';

const String getSearchRestaurantResponse1 = '''
{
  "error": false,
  "founded": 1,
  "restaurants": [
    {
      "id": "fnfn8mytkpmkfw1e867",
      "name": "Makan mudah",
      "description": "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, ...",
      "pictureId": "22",
      "city": "Medan",
      "rating": 3.7
    }
  ]
}
''';

const String getSearchRestaurantResponse2 = '''
{
  "error": false,
  "founded": 1,
  "restaurants": [
    {
      "id": "fnfn8mytkpmkfw1e867",
      "name": "Makan Mudah",
      "description": null,
      "pictureId": "14",
      "city": "Medan",
      "rating": null
    }
  ]
}
''';
