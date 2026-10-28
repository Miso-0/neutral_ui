import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// Typing highlights matching languages while keeping all options visible.
class SearchDropdownExample extends StatefulWidget {
  /// Creates the highlight search dropdown example.
  const SearchDropdownExample({super.key});
  @override
  State<SearchDropdownExample> createState() => _SearchDropdownExampleState();
}

class _SearchDropdownExampleState extends State<SearchDropdownExample> {
  String? _selected;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DropdownMenu<String>(
          style: _dropdown(),
          semanticLabel: 'Search languages',
          hintText: 'Find a language',
          requestFocusOnTap: true,
          dropdownMenuEntries: const <DropdownMenuEntry<String>>[
            DropdownMenuEntry<String>(value: 'Dart', label: 'Dart'),
            DropdownMenuEntry<String>(value: 'Flutter', label: 'Flutter'),
            DropdownMenuEntry<String>(value: 'Swift', label: 'Swift'),
            DropdownMenuEntry<String>(value: 'Kotlin', label: 'Kotlin'),
          ],
          onSelected: (String? value) => setState(() => _selected = value),
        ),
        const SizedBox(height: 12),
        Text('Language: ${_selected ?? 'none'}'),
      ],
    ),
  );
}

DropdownStyle _dropdown() => DropdownStyle(
  buttonStyle: _button().copyWith(
    alignment: AlignmentDirectional.centerStart,
    decoration: StateProperty<Decoration?>.resolveWith(_dropdownSurface),
    iconTheme: const StateProperty<IconThemeData?>.all(
      IconThemeData(color: _muted, size: 14),
    ),
  ),
  menuStyle: _menuPanel(),
  itemStyle: _menuItem(),
  textStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _ink, fontSize: 14),
  ),
  hintStyle: const StateProperty<TextStyle?>.all(
    TextStyle(color: _muted, fontSize: 14),
  ),
  cursorColor: _accent,
  selectionColor: const Color(0x40087F6D),
  cursorWidth: 2,
);

ButtonStyle _button({bool solid = false}) => ButtonStyle(
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => _surface(state, solid: solid),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 18, vertical: 13),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  ),
  spacing: 9,
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      color: state.isDisabled
          ? _muted
          : solid
          ? const Color(0xFFFFFFFF)
          : _ink,
      size: 16,
    ),
  ),
);

MenuStyle _menuPanel({bool matchAnchorWidth = true}) => MenuStyle(
  decoration: BoxDecoration(
    color: const Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: _line),
    boxShadow: const <BoxShadow>[
      BoxShadow(color: Color(0x18142C2A), blurRadius: 24, offset: Offset(0, 8)),
    ],
  ),
  padding: const EdgeInsets.all(6),
  minimumSize: const Size(180, 0),
  maximumSize: const Size(360, 280),
  matchAnchorWidth: matchAnchorWidth,
  edgePadding: const EdgeInsets.all(12),
  offset: const Offset(0, 6),
  clipBehavior: Clip.antiAlias,
);

ButtonStyle _menuItem() => _button().copyWith(
  iconTheme: const StateProperty<IconThemeData?>.all(
    IconThemeData(color: _accent, size: 16),
  ),
  decoration: StateProperty<Decoration?>.resolveWith(
    (InteractionState state) => BoxDecoration(
      color: state.isFocused || state.isPressed
          ? const Color(0xFFD5EAE0)
          : state.isSelected
          ? const Color(0xFFE4F1E7)
          : state.isHovered
          ? const Color(0xFFF0F5F0)
          : const Color(0x00000000),
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  padding: const StateProperty<EdgeInsetsGeometry?>.all(
    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
  alignment: AlignmentDirectional.centerStart,
);

Decoration _dropdownSurface(InteractionState state) {
  final bool active = state.isFocused || state.isSelected;
  return BoxDecoration(
    color: state.isDisabled
        ? const Color(0xFFE3EAE4)
        : state.isPressed
        ? const Color(0xFFD5EAE0)
        : active
        ? const Color(0xFFE4F1E7)
        : state.isHovered
        ? const Color(0xFFF0F5F0)
        : const Color(0xFFFFFFFF),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: state.isDisabled
          ? _line
          : active
          ? _accent
          : state.isHovered
          ? _muted
          : _line,
      width: 2,
    ),
  );
}

Decoration _surface(InteractionState state, {bool solid = false}) =>
    BoxDecoration(
      color: state.isDisabled
          ? const Color(0xFFE3EAE4)
          : solid
          ? (state.isPressed
                ? const Color(0xFF065F53)
                : state.isHovered
                ? const Color(0xFF0A927E)
                : _accent)
          : (state.isPressed
                ? const Color(0xFFD5EAE0)
                : state.isHovered
                ? const Color(0xFFE9F2EB)
                : const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(12),
      // A constant border width keeps content still; focus adds a ring.
      border: Border.all(
        color: state.isFocused
            ? _accent
            : solid
            ? const Color(0x00000000)
            : _line,
      ),
      boxShadow: state.isFocused ? _focusRing : null,
    );
