import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A draggable modal sheet with an explicit surface and close action.
class BottomSheetExample extends StatelessWidget {
  /// Creates this self-contained example.
  const BottomSheetExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: TextButton(
      style: _button(),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        style: BottomSheetStyle(
          decoration: _surface(),
          padding: const EdgeInsets.all(24),
          dragHandleColor: _muted,
          dragHandleSize: const Size(40, 4),
          constraints: const BoxConstraints(maxWidth: 680),
          barrierColor: const Color(0x55142C2A),
        ),
        showDragHandle: true,
        enableDrag: true,
        isScrollControlled: true,
        builder: (BuildContext context) => DefaultTextStyle(
          style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
          child: SizedBox(
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'A sheet that follows your drag',
                  style: TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 16),
                const Text('Drag down to dismiss, or use the close action.'),
                const Spacer(),
                TextButton(
                  style: _button(),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close sheet'),
                ),
              ],
            ),
          ),
        ),
      ),
      child: const Text('Open sheet'),
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
