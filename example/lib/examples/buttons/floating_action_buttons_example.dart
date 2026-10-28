import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);
const List<BoxShadow> _focusRing = <BoxShadow>[
  BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
];

/// Small, large and extended floating actions.
class FloatingActionButtonsExample extends StatelessWidget {
  /// Creates the floating action buttons example.
  const FloatingActionButtonsExample({super.key});
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        FloatingActionButton.small(
          heroTag: null,
          style: _control(selected: true),
          onPressed: () {},
          child: const SearchGlyph(),
        ),
        FloatingActionButton.large(
          heroTag: null,
          style: _control(selected: true),
          onPressed: () {},
          child: const CalendarGlyph(),
        ),
        FloatingActionButton.extended(
          heroTag: null,
          style: _control(selected: true),
          onPressed: () {},
          icon: const EditGlyph(),
          label: const Text('Extended action'),
        ),
      ],
    ),
  );
}

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
          : const Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: state.isFocused ? _accent : _line),
      // The ring stays visible on selected, accent-filled controls.
      boxShadow: state.isFocused ? _focusRing : null,
    ),
  ),
  textStyle: StateProperty<TextStyle?>.resolveWith(
    (InteractionState state) => TextStyle(
      color: state.isSelected || selected
          ? const Color(0xFFFFFFFF)
          : state.isDisabled
          ? _muted
          : _ink,
      fontSize: 14,
    ),
  ),
  iconTheme: StateProperty<IconThemeData?>.resolveWith(
    (InteractionState state) => IconThemeData(
      size: 18,
      color: state.isSelected || selected ? const Color(0xFFFFFFFF) : _accent,
    ),
  ),
);
