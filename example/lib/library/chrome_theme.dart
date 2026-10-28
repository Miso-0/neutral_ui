import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// The shell's primary text color.
const Color ink = Color(0xFF142C2A);

/// The shell's secondary text color.
const Color muted = Color(0xFF657B77);

/// The shell's accent color.
const Color accent = Color(0xFF087F6D);

/// The shell's page background.
const Color canvas = Color(0xFFF4F7F3);

/// The shell's border color.
const Color line = Color(0xFFCFDDD4);

/// Supplies the gallery chrome without styling the examples.
ThemeData chromeTheme() {
  final ButtonStyle button = ButtonStyle(
    padding: const StateProperty<EdgeInsetsGeometry?>.all(
      EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    ),
    decoration: StateProperty<Decoration?>.resolveWith(
      (InteractionState state) => BoxDecoration(
        color: state.isHovered || state.isPressed
            ? const Color(0xFFE4F1E7)
            : const Color(0xFFFFFFFF),
        border: Border.all(color: state.isFocused ? accent : line),
        borderRadius: BorderRadius.circular(9),
        boxShadow: state.isFocused
            ? const <BoxShadow>[
                BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
              ]
            : null,
      ),
    ),
    textStyle: const StateProperty<TextStyle?>.all(
      TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w600),
    ),
    iconTheme: const StateProperty<IconThemeData?>.all(
      IconThemeData(color: accent, size: 16),
    ),
    spacing: 8,
  );
  return ThemeData(
    elevatedButtonStyle: button,
    outlinedButtonStyle: button,
    textButtonStyle: button,
    iconButtonStyle: button,
    switchStyle: ToggleStyle(
      size: const StateProperty<Size?>.all(Size(36, 22)),
      thumbSize: const StateProperty<Size?>.all(Size(16, 16)),
      decoration: StateProperty<Decoration?>.resolveWith(
        (InteractionState state) => BoxDecoration(
          color: state.isSelected ? accent : line,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      thumbDecoration: const StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xFFFFFFFF), shape: BoxShape.circle),
      ),
      padding: const EdgeInsets.all(3),
    ),
    textFieldStyle: TextFieldStyle(
      decoration: const StateProperty<Decoration?>.all(
        BoxDecoration(
          color: Color(0xFFFFFFFF),
          border: Border.fromBorderSide(BorderSide(color: line)),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
      ),
      contentPadding: const StateProperty<EdgeInsetsGeometry?>.all(
        EdgeInsets.all(12),
      ),
      textStyle: const StateProperty<TextStyle?>.all(
        TextStyle(color: ink, fontSize: 14),
      ),
      hintStyle: const StateProperty<TextStyle?>.all(
        TextStyle(color: muted, fontSize: 13),
      ),
      iconTheme: const StateProperty<IconThemeData?>.all(
        IconThemeData(color: muted, size: 16),
      ),
      cursorColor: const StateProperty<Color?>.all(accent),
      selectionColor: const StateProperty<Color?>.all(Color(0x55087F6D)),
    ),
    listTileStyle: ListTileStyle(
      decoration: StateProperty<Decoration?>.resolveWith(
        (InteractionState state) => BoxDecoration(
          color: state.isSelected
              ? const Color(0xFFD5EAE0)
              : state.isHovered
              ? const Color(0xFFE9F2EB)
              : const Color(0x00000000),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      titleTextStyle: const StateProperty<TextStyle?>.all(
        TextStyle(color: ink, fontSize: 14),
      ),
      subtitleTextStyle: const StateProperty<TextStyle?>.all(
        TextStyle(color: muted, fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      minTileHeight: 40,
    ),
  );
}

/// Explicit notification styling for the messenger above the chrome theme.
const SnackBarStyle copySnackBarStyle = SnackBarStyle(
  decoration: BoxDecoration(
    color: ink,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  textStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(18),
  constraints: BoxConstraints(maxWidth: 560),
);
