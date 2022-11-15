import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/common.dart';
import '../../data/model/from_api/restaurant.dart';

import '../../providers/search_result_provider.dart';
import '../../widgets/fade_on_scroll.dart';
import '../../widgets/list_pages/restaurant_grid_view.dart';
import '../../widgets/list_pages/restaurant_list_view.dart';

class SearchResultPage extends StatefulWidget {
  static const routeName = '/search_result_page';
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SearchResultProvider(
          query: widget.query,
        ),
        child: Consumer<SearchResultProvider>(
          builder: (context, searchProv, _) {
            if (searchProv.state == ResultState.loading) {
              return Container(
                width: screenSize(context).width,
                height: screenSize(context).height,
                color: backgroundColor,
                child: const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: primaryColorBrightest,
                    color: primaryColor,
                  ),
                ),
              );
            }

            if (searchProv.state == ResultState.noData) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noApiData,
                      style: txtThemeH4?.copyWith(color: secondaryColor),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        searchProv.fetchSearchResult();
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            if (searchProv.state == ResultState.error) {
              return SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.noInternetAccess,
                      style: txtThemeH4?.copyWith(color: secondaryColor),
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        searchProv.fetchSearchResult();
                      },
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            final founded = searchProv.result.founded;
            final restaurants = searchProv.result.restaurants;

            return NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, isScrolled) {
                return _sliverAppBar(context, founded);
              },
              body: _buildResultList(restaurants),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _sliverAppBar(BuildContext context, int resultCount) {
    Widget title = FadeOnScroll(
      scrollController: scrollController,
      fullOpacityOffset: 125,
      child: Text(
        appName,
        style: txtThemeH6?.copyWith(color: primaryColor),
      ),
    );

    Widget flexibleSpaceBackground = Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: secondaryColor),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.searchResultFounded(resultCount),
          style: txtThemeSub1?.copyWith(color: primaryColor),
        ),
      ),
    );

    return [
      SliverAppBar(
        pinned: true,
        expandedHeight: 125,
        flexibleSpace: FlexibleSpaceBar(
          title: title,
          background: flexibleSpaceBackground,
          centerTitle: true,
        ),
      ),
    ];
  }

  LayoutBuilder _buildResultList(List<Restaurant> restaurants) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth <= 750) {
          return RestaurantsListView(
            listItem: restaurants,
            isPushReplacement: true,
          );
        } else if (constraints.maxWidth <= 900) {
          return RestaurantsGridView(
            gridCount: 2,
            listItem: restaurants,
            isPushReplacement: true,
          );
        } else if (constraints.maxWidth <= 1200) {
          return RestaurantsGridView(
            gridCount: 3,
            listItem: restaurants,
            isPushReplacement: true,
          );
        } else {
          return RestaurantsGridView(
            gridCount: 4,
            listItem: restaurants,
            isPushReplacement: true,
          );
        }
      },
    );
  }
}
