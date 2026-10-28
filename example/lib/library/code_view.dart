import 'package:flutter/widgets.dart';

import 'dart_highlighter.dart';

/// Selectable Dart code with line numbers and a bundled monospace face.
class CodeView extends StatefulWidget {
  /// Creates a source panel, optionally limited to its first lines.
  const CodeView({super.key, required this.source, this.maxLines});

  /// The exact source text to display.
  final String source;

  /// The number of visible lines, or null to show the whole file.
  final int? maxLines;

  @override
  State<CodeView> createState() => _CodeViewState();
}

class _CodeViewState extends State<CodeView> {
  final FocusNode _selectionFocus = FocusNode();

  @override
  void dispose() {
    _selectionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> lines = widget.source.split('\n');
    final int count = widget.maxLines == null || widget.maxLines! > lines.length
        ? lines.length
        : widget.maxLines!;
    final String visible = lines.take(count).join('\n');
    const TextStyle style = TextStyle(
      fontFamily: 'JetBrainsMono',
      fontSize: 12,
      height: 1.65,
      color: Color(0xFF243C36),
    );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: const Color(0xFFF7F9F5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ExcludeSemantics(
                child: Text(
                  List<String>.generate(
                    count,
                    (int i) => '${i + 1}',
                  ).join('\n'),
                  textAlign: TextAlign.right,
                  style: style.copyWith(color: const Color(0xFF8A9A90)),
                ),
              ),
              const SizedBox(width: 20),
              SelectableRegion(
                focusNode: _selectionFocus,
                selectionControls: emptyTextSelectionControls,
                child: Text.rich(highlightDart(visible), style: style),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
