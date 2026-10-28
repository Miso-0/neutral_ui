import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// A choice dialog with explicit option and surface styles.
class SimpleDialogExample extends StatefulWidget {
  /// Creates this self-contained example.
  const SimpleDialogExample({super.key});

  @override
  State<SimpleDialogExample> createState() => _SimpleDialogExampleState();
}

class _SimpleDialogExampleState extends State<SimpleDialogExample> {
  String _workspace = 'No workspace selected';

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextButton(
          style: _button(),
          onPressed: () async {
            final String? workspace = await showDialog<String>(
              context: context,
              style: _dialog(),
              builder: (BuildContext context) => SimpleDialog(
                style: _dialog(),
                title: const Text('Choose a workspace'),
                children: <Widget>[
                  for (final String name in const <String>[
                    'Personal workspace',
                    'Team workspace',
                  ])
                    SimpleDialogOption(
                      style: _dialog(),
                      onPressed: () => Navigator.of(context).pop(name),
                      child: Text(name),
                    ),
                ],
              ),
            );
            if (mounted && workspace != null) {
              setState(() => _workspace = workspace);
            }
          },
          child: const Text('Simple dialog'),
        ),
        const SizedBox(height: 12),
        Text(_workspace),
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

DialogStyle _dialog() => DialogStyle(
  decoration: _surface(),
  padding: const EdgeInsets.all(24),
  insetPadding: const EdgeInsets.all(24),
  constraints: const BoxConstraints(maxWidth: 620),
  titleTextStyle: const TextStyle(
    color: _ink,
    fontSize: 22,
    fontWeight: FontWeight.w600,
  ),
  contentTextStyle: const TextStyle(color: _ink, fontSize: 14),
  contentPadding: const EdgeInsets.symmetric(vertical: 18),
  actionsPadding: const EdgeInsets.only(top: 16),
  optionStyle: _button(),
  barrierColor: const Color(0x55142C2A),
);
