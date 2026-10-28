import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

import 'catalog.dart';
import 'chrome_theme.dart';
import 'code_view.dart';

/// Caches the same source assets used for the executable examples.
class ExampleSource {
  ExampleSource._();

  static final Map<String, String> _cache = <String, String>{};
  static final Map<String, Future<String>> _loading =
      <String, Future<String>>{};

  /// Loads a source file once per application session.
  static Future<String> load(String path) {
    final String? cached = _cache[path];
    if (cached != null) return Future<String>.value(cached);
    return _loading.putIfAbsent(path, () async {
      try {
        final String source = await rootBundle.loadString(path);
        _cache[path] = source;
        return source;
      } finally {
        _loading.remove(path);
      }
    });
  }
}

/// A live, theme-isolated example and the exact file that implements it.
class ExampleCard extends StatefulWidget {
  /// Creates an example with copyable source.
  const ExampleCard({super.key, required this.entry});

  /// The catalog entry displayed by this card.
  final ExampleEntry entry;

  @override
  State<ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<ExampleCard> {
  String? _source;
  bool _loadFailed = false;
  bool _expanded = false;
  bool _copied = false;
  bool _copying = false;
  String? _copyError;
  Timer? _reset;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ExampleCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.sourcePath != widget.entry.sourcePath) {
      _reset?.cancel();
      _source = null;
      _copied = false;
      _copyError = null;
      _loadFailed = false;
      _load();
    }
  }

  Future<void> _load() async {
    final String path = widget.entry.sourcePath;
    // Resolved source is available immediately when scrolling back to a card.
    // Cache text rather than completed futures so it is independent of the
    // asynchronous context in which the first asset load was started.
    final String? cached = ExampleSource._cache[path];
    if (cached != null) {
      _source = cached;
      return;
    }
    try {
      final String source = await ExampleSource.load(path);
      if (mounted && widget.entry.sourcePath == path) {
        setState(() => _source = source);
      }
    } catch (_) {
      if (mounted && widget.entry.sourcePath == path) {
        setState(() => _loadFailed = true);
      }
    }
  }

  void _copy() {
    // Start the platform call directly in the gesture, before any await.
    final Future<void> copied = Clipboard.setData(
      ClipboardData(text: _source!),
    );
    setState(() => _copying = true);
    copied.then(
      (_) {
        if (!mounted) return;
        _reset?.cancel();
        setState(() {
          _copied = true;
          _copying = false;
          _copyError = null;
        });
        final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
          context,
        );
        messenger?.clearSnackBars();
        messenger?.showSnackBar(
          const SnackBar(
            content: Text('Copied example code'),
            style: copySnackBarStyle,
            duration: Duration(seconds: 2),
          ),
        );
        _reset = Timer(const Duration(seconds: 2), () {
          if (mounted) setState(() => _copied = false);
        });
      },
      onError: (Object error, StackTrace stack) {
        if (mounted) {
          setState(() {
            _copying = false;
            _copyError = 'Copy failed, select the code instead';
            _expanded = true;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.entry.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.entry.description,
                      style: const TextStyle(color: muted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _source == null || _copying ? null : _copy,
                child: Text(
                  _copied
                      ? 'Copied'
                      : _copying
                      ? 'Copying...'
                      : 'Copy',
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFFFAFCF9),
            border: Border.symmetric(horizontal: BorderSide(color: line)),
          ),
          child: NeutralTheme(
            data: const ThemeData(),
            child: Builder(builder: widget.entry.builder),
          ),
        ),
        if (_source != null) ...<Widget>[
          CodeView(source: _source!, maxLines: _expanded ? null : 14),
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(_expanded ? 'Collapse code' : 'Show full code'),
          ),
        ] else
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              _loadFailed ? 'Unable to load source' : 'Loading source...',
            ),
          ),
        if (_copyError != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Semantics(liveRegion: true, child: Text(_copyError!)),
          ),
      ],
    ),
  );
}
