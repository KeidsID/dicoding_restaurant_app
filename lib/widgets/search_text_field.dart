import 'package:flutter/material.dart';

import '../common/common.dart';
import '../pages/home/search_result_page.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;

  const SearchTextField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: inputDeco(
        hintText: AppLocalizations.of(context)!.searchTxtFieldHint,
        suffixIcon: IconButton(
          onPressed: () {
            if (controller.text != '') {
              Navigator.pushNamed(
                context,
                SearchResultPage.routeName,
                arguments: controller.text,
              );
            }
          },
          icon: const Icon(Icons.search),
        ),
      ),
      style: textTheme.bodyText1?.copyWith(color: primaryColor),
      onSubmitted: (value) {
        if (value != '') {
          Navigator.pushNamed(
            context,
            SearchResultPage.routeName,
            arguments: value,
          );
        }
      },
      cursorColor: secondaryColor,
    );
  }
}
