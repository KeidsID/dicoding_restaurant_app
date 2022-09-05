import 'package:flutter/material.dart';

import 'home_page.dart';

class SearchResultPage extends StatelessWidget {
  static String routeName = '/search_result_page';

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          },
          child: const Text('back')),
    );
  }
}
