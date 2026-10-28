import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A tooltip available on hover, long press and keyboard focus.
class TooltipExample extends StatelessWidget {
  /// Creates this self-contained example.
  const TooltipExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: Tooltip(
      message: 'Tooltips also open on keyboard focus',
      style: TooltipStyle(
        decoration: BoxDecoration(
          color: _ink,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.all(9),
        textStyle: const TextStyle(color: _white, fontSize: 12),
      ),
      child: TextButton(
        style: _button(),
        onPressed: () {},
        child: const Text('Hover or focus'),
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
