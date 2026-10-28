import 'package:flutter/widgets.dart';

import 'catalog.dart';
import 'chrome_theme.dart';
import 'example_card.dart';

/// Matches titles, descriptions and category names across the catalog.
List<ExampleEntry> searchExamples(String query) {
  final List<String> words = query.toLowerCase().trim().split(RegExp(r'\s+'));
  return <ExampleEntry>[
    for (final ComponentCategory category in componentCategories)
      for (final ExampleEntry entry in category.examples)
        if (words.every(
          (String word) =>
              '${category.title} ${category.id} ${entry.title} ${entry.description}'
                  .toLowerCase()
                  .contains(word),
        ))
          entry,
  ];
}

/// Live search results with the same previews and copy controls as categories.
class SearchResults extends StatelessWidget {
  /// Creates catalog results for a query.
  const SearchResults({super.key, required this.query});

  /// The search query.
  final String query;

  @override
  Widget build(BuildContext context) {
    final List<ExampleEntry> results = searchExamples(query);
    return ListView.builder(
      key: ValueKey<String>('search:$query'),
      padding: const EdgeInsets.all(24),
      itemCount: results.length + 1,
      itemBuilder: (BuildContext context, int index) => index == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Search results',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    results.isEmpty
                        ? 'No examples found for "$query"'
                        : '${results.length} examples for "$query"',
                    style: const TextStyle(color: muted),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: ExampleCard(
                key: ValueKey<String>(results[index - 1].id),
                entry: results[index - 1],
              ),
            ),
    );
  }
}
