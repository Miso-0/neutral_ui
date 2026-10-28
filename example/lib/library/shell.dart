import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'catalog.dart';
import 'category_page.dart';
import 'chrome_theme.dart';
import 'getting_started_page.dart';
import 'search.dart';

/// Application preferences inherited by routes and modal overlays.
class LibraryPreferences extends InheritedWidget {
  /// Creates the current library preferences.
  const LibraryPreferences({
    super.key,
    required this.rtl,
    required this.reducedMotion,
    required this.onRtlChanged,
    required this.onReducedMotionChanged,
    required super.child,
  });

  /// Whether to display right-to-left content.
  final bool rtl;

  /// Whether to disable animations.
  final bool reducedMotion;

  /// Updates the reading direction.
  final ValueChanged<bool> onRtlChanged;

  /// Updates the motion preference.
  final ValueChanged<bool> onReducedMotionChanged;

  /// Reads the current preferences.
  static LibraryPreferences of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<LibraryPreferences>()!;

  @override
  bool updateShouldNotify(LibraryPreferences oldWidget) =>
      rtl != oldWidget.rtl || reducedMotion != oldWidget.reducedMotion;
}

/// Responsive navigation, search and preferences around the component pages.
class LibraryShell extends StatefulWidget {
  /// Creates the shell for a category or the getting-started page.
  const LibraryShell({super.key, this.category});

  /// The current category, or null for the introduction.
  final ComponentCategory? category;

  @override
  State<LibraryShell> createState() => _LibraryShellState();
}

class _LibraryShellState extends State<LibraryShell> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchFocus.dispose();
    _search.dispose();
    super.dispose();
  }

  void _navigate(String path) {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pushReplacementNamed(path);
  }

  Widget _navigation({BuildContext? sheetContext}) => ListView(
    padding: const EdgeInsets.all(12),
    children: <Widget>[
      ListTile(
        selected: widget.category == null,
        title: const Text('Getting started'),
        onTap: () {
          if (sheetContext != null) Navigator.of(sheetContext).pop();
          _navigate('/');
        },
      ),
      const SizedBox(height: 12),
      for (final ComponentCategory category in componentCategories)
        ListTile(
          selected: category.id == widget.category?.id,
          title: Text(category.title),
          trailing: Text(
            '${category.examples.length}',
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          onTap: () {
            if (sheetContext != null) Navigator.of(sheetContext).pop();
            _navigate('/${category.id}');
          },
        ),
    ],
  );

  void _categories() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      style: const BottomSheetStyle(
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(top: 12),
        dragHandleColor: muted,
        dragHandleSize: Size(40, 4),
        barrierColor: Color(0x55142C2A),
      ),
      builder: (BuildContext context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .75,
        child: _navigation(sheetContext: context),
      ),
    );
  }

  Widget _searchField() => TextField(
    controller: _search,
    focusNode: _searchFocus,
    hintText: 'Search components',
    prefixIcon: const SearchGlyph(),
    showClearButton: true,
    onChanged: (String value) => setState(() => _query = value.trim()),
  );

  Widget _preferences(LibraryPreferences preferences) => Wrap(
    spacing: 16,
    runSpacing: 8,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('RTL', style: TextStyle(fontSize: 12, color: muted)),
          const SizedBox(width: 7),
          Switch(
            value: preferences.rtl,
            onChanged: preferences.onRtlChanged,
            semanticLabel: 'RTL',
          ),
        ],
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Reduced motion',
            style: TextStyle(fontSize: 12, color: muted),
          ),
          const SizedBox(width: 7),
          Switch(
            value: preferences.reducedMotion,
            onChanged: preferences.onReducedMotionChanged,
            semanticLabel: 'Reduced motion',
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final LibraryPreferences preferences = LibraryPreferences.of(context);
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.slash):
            _searchFocus.requestFocus,
        const SingleActivator(LogicalKeyboardKey.keyK, control: true):
            _searchFocus.requestFocus,
        const SingleActivator(LogicalKeyboardKey.keyK, meta: true):
            _searchFocus.requestFocus,
      },
      child: Focus(
        autofocus: true,
        child: ColoredBox(
          color: canvas,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool wide = constraints.maxWidth >= 900;
                return Row(
                  children: <Widget>[
                    if (wide)
                      Container(
                        width: 248,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF9FBF7),
                          border: BorderDirectional(
                            end: BorderSide(color: line),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.fromLTRB(24, 28, 24, 8),
                              child: Text(
                                'neutralui',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'COMPONENT LIBRARY',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: _searchField(),
                            ),
                            Expanded(child: _navigation()),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: line)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 16,
                                  runSpacing: 12,
                                  children: <Widget>[
                                    if (wide)
                                      const Text(
                                        'Widgets with their styles included',
                                        style: TextStyle(
                                          color: muted,
                                          fontSize: 12,
                                        ),
                                      )
                                    else
                                      OutlinedButton(
                                        onPressed: _categories,
                                        child: const Text('Categories'),
                                      ),
                                    _preferences(preferences),
                                  ],
                                ),
                                if (!wide)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: _searchField(),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: _query.isNotEmpty
                                ? SearchResults(query: _query)
                                : widget.category == null
                                ? const GettingStartedPage()
                                : CategoryPage(category: widget.category!),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
