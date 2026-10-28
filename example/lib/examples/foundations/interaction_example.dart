import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _line = Color(0xFFCFDDD4);

/// A custom interactive surface exposes live pointer and keyboard focus state.
class InteractionExample extends StatefulWidget {
  /// Creates the interactiondetector example.
  const InteractionExample({super.key});
  @override
  State<InteractionExample> createState() => _InteractionExampleState();
}

class _InteractionExampleState extends State<InteractionExample> {
  int _taps = 0;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: InteractionDetector(
      onTap: () => setState(() => _taps++),
      builder: (BuildContext context, InteractionState state) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: state.isPressed
              ? const Color(0xFFD5EAE0)
              : const Color(0xFFE8EFE8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: state.isFocused ? _accent : _line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'LIVE INTERACTION STATE',
              style: TextStyle(
                color: _accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'pressed ${state.isPressed} / hovered ${state.isHovered} / focused ${state.isFocused}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            Text(
              'Activated $_taps times',
              style: const TextStyle(color: _muted, fontSize: 12),
            ),
          ],
        ),
      ),
    ),
  );
}
