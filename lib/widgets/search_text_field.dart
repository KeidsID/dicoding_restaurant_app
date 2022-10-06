import 'package:flutter/material.dart';

import '../common/common.dart';
import '../pages/home/search_result_page.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;

  const SearchTextField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: primaryColorBrightest.withOpacity(0.25),
        hintText: AppLocalizations.of(context)!.searchTxtFieldHint,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: secondaryColor,
            width: 2,
          ),
        ),
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
