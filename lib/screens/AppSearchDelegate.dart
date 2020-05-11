import 'package:Navi/screens/ActivityListScreen.dart';
import 'package:flutter/material.dart';

class AppSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      textTheme: TextTheme(
        title: TextStyle(
          fontSize: 16.0,
          color: Colors.white
        )
      )
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.info_outline,
              size: 64.0,
            ),
            const SizedBox(
              height: 16.0,
            ),
            const Text(
              'Notice',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Text(
                'Search term must contain at least 3 characters.')
          ],
        ),
      );
    }

    return ActivityListScreen(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
