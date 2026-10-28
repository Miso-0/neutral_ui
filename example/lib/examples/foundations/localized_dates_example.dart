import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);

/// NeutralLocalizations formats full and compact dates without additional dependencies.
class LocalizedDatesExample extends StatelessWidget {
  /// Creates the localized dates example.
  const LocalizedDatesExample({super.key});
  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(
      color: _ink,
      fontSize: 14,
      height: 1.4,
      fontFamily: 'Arial',
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          NeutralLocalizations.of(context)
              .formatFullDate(DateTime(2026, 10, 16)),
        ),
        const SizedBox(height: 8),
        Text(
          NeutralLocalizations.of(context)
              .formatCompactDate(DateTime(2026, 10, 16)),
          style: const TextStyle(color: _muted),
        ),
      ],
    ),
  );
}
