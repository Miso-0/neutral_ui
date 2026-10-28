import 'package:flutter/widgets.dart';

import 'catalog.dart';
import 'chrome_theme.dart';
import 'example_card.dart';

/// A category header followed by lazily built example cards.
class CategoryPage extends StatelessWidget {
  /// Creates a component category page.
  const CategoryPage({super.key, required this.category});

  /// The category to browse.
  final ComponentCategory category;

  @override
  Widget build(BuildContext context) => ListView.builder(
    key: PageStorageKey<String>(category.id),
    padding: const EdgeInsets.all(24),
    itemCount: category.examples.length + 1,
    itemBuilder: (BuildContext context, int index) {
      if (index == 0) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(category.summary, style: const TextStyle(color: muted)),
              const SizedBox(height: 8),
              Text(
                '${category.examples.length} self-contained examples',
                style: const TextStyle(color: accent, fontSize: 12),
              ),
            ],
          ),
        );
      }
      final ExampleEntry entry = category.examples[index - 1];
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: ExampleCard(key: ValueKey<String>(entry.id), entry: entry),
      );
    },
  );
}
