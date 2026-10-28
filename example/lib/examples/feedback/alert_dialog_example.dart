import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// An alert dialog whose surface and action styles travel with the snippet.
class AlertDialogExample extends StatefulWidget {
  /// Creates this self-contained example.
  const AlertDialogExample({super.key});

  @override
  State<AlertDialogExample> createState() => _AlertDialogExampleState();
}

class _AlertDialogExampleState extends State<AlertDialogExample> {
  String _status = 'Create a new workspace';

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
            final bool? accepted = await showDialog<bool>(
              context: context,
              style: _dialog(),
              builder: (BuildContext context) => AlertDialog(
                style: _dialog(),
                title: const Text('Create a workspace?'),
                content: const Text(
                  'Dialog content, actions and motion are styled in this file.',
                ),
                actions: <Widget>[
                  TextButton(
                    style: _button(),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    style: _button(selected: true),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Create workspace'),
                  ),
                ],
              ),
            );
            if (mounted) {
              setState(
                () => _status = accepted == true
                    ? 'Workspace created'
                    : 'Dialog dismissed',
              );
            }
          },
          child: const Text('Open dialog'),
        ),
        const SizedBox(height: 12),
        Text(_status),
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
