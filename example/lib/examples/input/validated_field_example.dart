import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// An email field with form validation and save feedback.
class ValidatedFieldExample extends StatefulWidget {
  /// Creates this self-contained example.
  const ValidatedFieldExample({super.key});

  @override
  State<ValidatedFieldExample> createState() => _ValidatedFieldExampleState();
}

class _ValidatedFieldExampleState extends State<ValidatedFieldExample> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _saved = '';

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: _ink, fontSize: 14, height: 1.4),
    child: SizedBox(
      width: 300,
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              style: _field(),
              labelText: 'Email address',
              hintText: 'you@example.com',
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (String? value) => value != null && value.contains('@')
                  ? null
                  : 'Enter an email address',
              onSaved: (String? value) => setState(() => _saved = value ?? ''),
            ),
            const SizedBox(height: 12),
            TextButton(
              style: _button(),
              onPressed: () {
                if (_form.currentState!.validate()) _form.currentState!.save();
              },
              child: const Text('Save email'),
            ),
            if (_saved.isNotEmpty) Text('Saved: $_saved'),
          ],
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
