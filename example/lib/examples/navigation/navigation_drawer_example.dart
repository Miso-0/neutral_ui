import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

/// A focus ring drawn outside the control, so showing it never moves content.
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

ButtonStyle _control({bool selected = false}) => ButtonStyle(
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
      // The ring stays visible on selected, accent-filled controls.
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

NavigationStyle _navigationStyle() => NavigationStyle(
  destinationStyle: _control(),
  spacing: 8,
  indicatorDecoration: const StateProperty<Decoration?>.all(
    BoxDecoration(
      color: Color(0xFFD5EAE0),
      borderRadius: BorderRadius.all(Radius.circular(9)),
    ),
  ),
);

/// A navigation drawer with explicit destination styling.
class NavigationDrawerExample extends StatefulWidget {
  /// Creates the example.
  const NavigationDrawerExample({super.key});

  @override
  State<NavigationDrawerExample> createState() =>
      _NavigationDrawerExampleState();
}

class _NavigationDrawerExampleState extends State<NavigationDrawerExample> {
  int _destination = 0;
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: Color(0xFF142C2A), fontSize: 14),
    child: NavigationDrawer(
      style: _navigationStyle(),
      selectedIndex: _destination,
      onDestinationSelected: (int index) =>
          setState(() => _destination = index),
      children: const <Widget>[
        NavigationDrawerDestination(
          icon: SearchGlyph(),
          label: Text('Explore'),
        ),
        NavigationDrawerDestination(
          icon: CalendarGlyph(),
          label: Text('Schedule'),
        ),
        NavigationDrawerDestination(icon: ClockGlyph(), label: Text('Recent')),
      ],
    ),
  );
}
