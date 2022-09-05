import 'package:flutter/material.dart';

import '../pages/search_result_page.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;

  const SearchTextField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        if (value != '') {
          Navigator.pushNamed(
            context,
            SearchResultPage.routeName,
            arguments: value,
          );
        }
      },
    );
  }
}
