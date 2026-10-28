import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'catalog.dart';
import 'chrome_theme.dart';
import 'code_view.dart';

const String _setup = '''import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

void main() => runApp(const NeutralApp(
  color: Color(0xFFF4F7F3),
  theme: ThemeData(),
  home: Center(child: Text('Hello, NeutralUI')),
));''';

/// Installation guidance and entry points to every component family.
class GettingStartedPage extends StatelessWidget {
  /// Creates the introduction.
  const GettingStartedPage({super.key});

  Widget _block(String title, String source) => Container(
    margin: const EdgeInsets.only(bottom: 24),
    decoration: BoxDecoration(
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(12),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              _QuickCopy(source: source),
            ],
          ),
        ),
        CodeView(source: source),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: <Widget>[
      const Text(
        'Getting started',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
      ),
      const SizedBox(height: 12),
      const Text(
        'Build your interface, keep your visual language.',
        style: TextStyle(fontSize: 20, color: accent),
      ),
      const SizedBox(height: 12),
      const Text(
        'NeutralUI provides headless Flutter controls. Every example here includes its own styles and local state. Copy the complete file, then place its example widget in your app.',
        style: TextStyle(color: muted),
      ),
      const SizedBox(height: 28),
      _block('1. Add the package', 'flutter pub add neutral_ui'),
      _block('2. Start with NeutralApp', _setup),
      const Text(
        'Explore components',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 16),
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            for (final ComponentCategory category in componentCategories)
              SizedBox(
                width: constraints.maxWidth >= 600
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth,
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.of(context)
                          .pushReplacementNamed('/${category.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          category.title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${category.examples.length} examples',
                          style: const TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

class _QuickCopy extends StatefulWidget {
  const _QuickCopy({required this.source});
  final String source;
  @override
  State<_QuickCopy> createState() => _QuickCopyState();
}

class _QuickCopyState extends State<_QuickCopy> {
  bool _copied = false;
  String? _error;

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.source)).then(
      (_) async {
        if (!mounted) return;
        setState(() {
          _copied = true;
          _error = null;
        });
        await Future<void>.delayed(const Duration(seconds: 2));
        if (mounted) setState(() => _copied = false);
      },
      onError: (Object error, StackTrace stack) {
        if (mounted) {
          setState(() => _error = 'Copy failed, select the code instead');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: _copy,
    child: Text(_error ?? (_copied ? 'Copied' : 'Copy')),
  );
}
