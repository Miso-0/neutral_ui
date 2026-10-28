import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

/// Expandable content whose child state survives collapse.
class ExpansionTileExample extends StatelessWidget {
  /// Creates the example.
  const ExpansionTileExample({super.key});

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: const TextStyle(color: Color(0xFF142C2A), fontSize: 14),
    child: ExpansionTile(
      title: const Text('Project details'),
      maintainState: true,
      style: ExpansionTileStyle(
        childrenPadding: const EdgeInsets.all(16),
        tileStyle: ListTileStyle(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          titleTextStyle: const StateProperty<TextStyle?>.all(
            TextStyle(color: Color(0xFF142C2A), fontSize: 16),
          ),
          iconTheme: const StateProperty<IconThemeData?>.all(
            IconThemeData(color: Color(0xFF087F6D), size: 20),
          ),
          decoration: StateProperty<Decoration?>.resolveWith(
            (InteractionState state) => BoxDecoration(
              color: state.isHovered
                  ? const Color(0xFFE9F2EB)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCFDDD4)),
              boxShadow: state.isFocused
                  ? const <BoxShadow>[
                      BoxShadow(color: Color(0x66087F6D), spreadRadius: 3),
                    ]
                  : null,
            ),
          ),
        ),
      ),
      children: const <Widget>[
        Text(
          'This content stays mounted while collapsed.',
          style: TextStyle(color: Color(0xFF142C2A), fontSize: 14),
        ),
      ],
    ),
  );
}
