import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

void main() => runApp(const MySearchApp());

class MySearchApp extends StatelessWidget {
  const MySearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const historyLength = 5;

  List<String> searchHistory = [
    "hello there",
    "sorry I cant",
    "no proplem with this",
    "hell yeaah",
    "dad",
    "dd",
    "d",
    "lol"
  ];
  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  List<String>? filteredSearchHistory;
  FloatingSearchBarController? controller;
  String? selectedTerm;

// filter the terms that start with the "filter" string
  List<String> filterSearchTerms({@required String? filter}) {
    if (filter != null && filter.isNotEmpty) {
      // if filters contain more than letter then return the terms that started with thoses letters
      return searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      // else return the the whole search history
      return searchHistory.reversed.toList();
    }
  }

// implement the least recently used algorithm
  void addSearchTerm(String term) {
    if (searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    searchHistory.add(term);
    if (searchHistory.length > historyLength) {
      searchHistory.removeRange(0, searchHistory.length - historyLength);
    }
    // we change the
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    searchHistory.removeWhere((t) => t == term);
    // update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  @override
  void initState() {
    // reversed search history
    controller = FloatingSearchBarController();

    filteredSearchHistory = filterSearchTerms(filter: null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      controller: controller,
      body: SearchResultsListView(
        searchTerm: selectedTerm,
      ),
      builder: (BuildContext context, Animation<double> transition) {
        return Container();
      },
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String? searchTerm;

  const SearchResultsListView({
    Key? key,
    @required this.searchTerm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    return ListView(
      children: List.generate(
        50,
        (index) => ListTile(
          title: Text('$searchTerm search result'),
          subtitle: Text(index.toString()),
        ),
      ),
    );
  }
}

// there is a query inside the SearchDelegate u can handle it
class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    "hello there",
    "sorry I cant",
    "no proplem with this",
    "hell yeaah",
    "dad",
    "dd",
    "d",
    "lol"
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          // to clear the Query
          query = '';
        },
        icon: const Icon(
          Icons.delete,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        // to leave and close the search bar
        close(context, null);
      },
      icon: const Icon(
        Icons.close,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length > 5 ? 5 : matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }
}
