import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// Search suggestions in a full-screen route.
class FullScreenSearchExample extends StatefulWidget {
  /// Creates this self-contained example.
  const FullScreenSearchExample({super.key});

  @override
  State<FullScreenSearchExample> createState() =>
      _FullScreenSearchExampleState();
}

class _FullScreenSearchExampleState extends State<FullScreenSearchExample> {
  final SearchController _controller = SearchController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> _suggestions() => <Widget>[
    for (final String item
        in const <String>['Design systems', 'Research', 'Engineering'].where(
          (String item) =>
              item.toLowerCase().contains(_controller.text.toLowerCase()),
        ))
      TextButton(
        style: _button(),
        onPressed: () => _controller.closeView(item),
        child: Text(item),
      ),
  ];

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: SizedBox(
      width: 320,
      child: SearchAnchor.bar(
        searchController: _controller,
        style: _search(),
        isFullScreen: true,
        barHintText: 'Open full-screen search',
        viewLeading: IconButton(
          style: _button(),
          tooltip: 'Back',
          onPressed: () => _controller.closeView(null),
          icon: const ArrowGlyph(direction: GlyphDirection.start),
        ),
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) => _suggestions(),
        // Rebuild the custom route content directly as the query changes.
        viewBuilder: (Iterable<Widget> suggestions) =>
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder:
                  (
                    BuildContext context,
                    TextEditingValue value,
                    Widget? child,
                  ) => ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: _suggestions(),
                  ),
            ),
      ),
    ),
  );
}

const Color _ink = Color(0xFF142C2A);

const Color _muted = Color(0xFF657B77);

const Color _accent = Color(0xFF087F6D);

const Color _line = Color(0xFFCFDDD4);

const Color _white = Color(0xFFFFFFFF);

const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

BoxDecoration _surface() => BoxDecoration(
  color: _white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(color: _line),
);

ButtonStyle _button({bool selected = false}) => ButtonStyle(
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 9),
  ),
  spacing: 8,
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : state.isSelected || selected
          ? _accent
          : state.isHovered
          ? const Color(0xFFE4F1E7)
          : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: state.isFocused ? _accent : _line),
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isSelected || selected
          ? _white
          : state.isDisabled
          ? _muted
          : _ink,
      fontSize: 14,
    ),
  ),
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      size: 18,
      color: state.isSelected || selected ? _white : _accent,
    ),
  ),
);

TextFieldStyle _field() => TextFieldStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isDisabled ? const Color(0xFFE3EAE4) : _white,
      borderRadius: BorderRadius.circular(9),
      border: Border.all(
        color: state.isError
            ? const Color(0xFFB13B3B)
            : state.isFocused
            ? _accent
            : _line,
      ),
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  contentPadding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  ),
  textStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _ink, fontSize: 14),
  ),
  hintStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 14),
  ),
  labelStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 12),
  ),
  errorStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: Color(0xFFB13B3B), fontSize: 12),
  ),
  iconTheme: const StateProperty<IconThemeData?>.all(
    IconThemeData(color: _accent, size: 18),
  ),
  cursorColor: const StateProperty<Color?>.all(_accent),
  selectionColor: const StateProperty<Color?>.all(Color(0x55087F6D)),
  spacing: 6,
);

MenuStyle _menu() => MenuStyle(
  decoration: _surface(),
  padding: const EdgeInsets.all(6),
  maximumSize: const Size(480, 300),
);

SearchStyle _search() => SearchStyle(
  fieldStyle: _field(),
  viewDecoration: _surface(),
  viewPadding: const EdgeInsets.all(12),
  menuStyle: _menu(),
  suggestionStyle: _button(),
);
