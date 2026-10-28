import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// Project action menus open over or under their triggers and support checked and disabled rows.
class PopupMenuExample extends StatefulWidget {
  /// Creates the popup menus example.
  const PopupMenuExample({super.key});
  @override
  State<PopupMenuExample> createState() => _PopupMenuExampleState();
}

class _PopupMenuExampleState extends State<PopupMenuExample> {
  bool _pinned = true;
  String _status = 'Choose an action';
  List<PopupMenuEntry<String>> _items(
    BuildContext context,
  ) => <PopupMenuEntry<String>>[
    const PopupMenuItem<String>(
      value: 'duplicate',
      leading: EditGlyph(),
      child: Text('Duplicate project'),
    ),
    CheckedPopupMenuItem<String>(
      value: 'pin',
      checked: _pinned,
      child: const Text('Pin to sidebar'),
    ),
    const PopupMenuDivider(),
    const PopupMenuItem<String>(
      value: 'archive',
      enabled: false,
      child: Text('Archive project'),
    ),
    const PopupMenuItem<String>(value: 'delete', child: Text('Delete project')),
  ];
  void _select(String value) => setState(() {
    if (value == 'pin') _pinned = !_pinned;
    _status = 'Project action: $value';
  });
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
        Wrap(
          spacing: 20,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            PopupMenuButton<String>(
              style: _popupStyle(),
              tooltip: 'Project actions over',
              semanticLabel: 'Project actions',
              icon: const DotsGlyph(),
              position: PopupMenuPosition.over,
              itemBuilder: _items,
              onSelected: _select,
            ),
            PopupMenuButton<String>(
              style: _popupStyle(),
              semanticLabel: 'Project actions below',
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              itemBuilder: _items,
              onSelected: _select,
              child: const Text('Project actions below'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(_status),
      ],
    ),
  );
}

PopupMenuStyle _popupStyle() => PopupMenuStyle(
  buttonStyle: _button(),
  menuStyle: _menuPanel(matchAnchorWidth: false),
  itemStyle: _menuItem(),
  dividerDecoration: const BoxDecoration(color: _line),
  dividerHeight: 1,
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
