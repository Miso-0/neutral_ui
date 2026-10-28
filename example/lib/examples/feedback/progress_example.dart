import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// Determinate and indeterminate progress with explicit paint tokens.
class ProgressExample extends StatefulWidget {
  /// Creates this self-contained example.
  const ProgressExample({super.key});

  @override
  State<ProgressExample> createState() => _ProgressExampleState();
}

class _ProgressExampleState extends State<ProgressExample> {
  bool _animate = false;
  static const ProgressIndicatorStyle _progressStyle = ProgressIndicatorStyle(
    color: StateProperty<Color?>.all(_accent),
    backgroundColor: StateProperty<Color?>.all(_line),
    strokeWidth: 4,
    minHeight: 5,
    size: Size(32, 32),
  );

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 24,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              value: _animate ? null : 0.65,
              style: _progressStyle,
            ),
            SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                value: _animate ? null : 0.42,
                style: _progressStyle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextButton(
          style: _button(),
          onPressed: () => setState(() => _animate = !_animate),
          child: Text(
            _animate ? 'Show determinate progress' : 'Animate progress',
          ),
        ),
      ],
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
