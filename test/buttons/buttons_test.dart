import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const Key _buttonKey = Key('button');
const Key _contentKey = Key('content');
const Widget _content = SizedBox(key: _contentKey, width: 20, height: 12);

typedef _CreateButton = Widget Function(_Options options);
typedef _WrapTheme = Widget Function(ButtonStyle style, Widget child);

class _Options {
  const _Options({
    this.onPressed,
    this.onLongPress,
    this.style,
    this.statesController,
    this.isLoading = false,
    this.loadingIndicator,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ButtonStyle? style;
  final WidgetStatesController? statesController;
  final bool isLoading;
  final Widget? loadingIndicator;
}

class _Variant {
  const _Variant(this.name, this.create, this.wrapTheme, this.globalTheme);

  final String name;
  final _CreateButton create;
  final _WrapTheme wrapTheme;
  final ThemeData Function(ButtonStyle style) globalTheme;
}

class _StatefulContent extends StatefulWidget {
  const _StatefulContent({required this.onMount});

  final VoidCallback onMount;

  @override
  State<_StatefulContent> createState() => _StatefulContentState();
}

class _StatefulContentState extends State<_StatefulContent> {
  @override
  void initState() {
    super.initState();
    widget.onMount();
  }

  @override
  Widget build(BuildContext context) => const Text('Save');
}

final List<_Variant> _variants = <_Variant>[
  _Variant(
    'ElevatedButton',
    (_Options options) => ElevatedButton(
      key: _buttonKey,
      onPressed: options.onPressed,
      onLongPress: options.onLongPress,
      style: options.style,
      statesController: options.statesController,
      isLoading: options.isLoading,
      loadingIndicator: options.loadingIndicator,
      child: _content,
    ),
    (ButtonStyle style, Widget child) =>
        ElevatedButtonTheme(data: style, child: child),
    (ButtonStyle style) => ThemeData(elevatedButtonStyle: style),
  ),
  _Variant(
    'OutlinedButton',
    (_Options options) => OutlinedButton(
      key: _buttonKey,
      onPressed: options.onPressed,
      onLongPress: options.onLongPress,
      style: options.style,
      statesController: options.statesController,
      isLoading: options.isLoading,
      loadingIndicator: options.loadingIndicator,
      child: _content,
    ),
    (ButtonStyle style, Widget child) =>
        OutlinedButtonTheme(data: style, child: child),
    (ButtonStyle style) => ThemeData(outlinedButtonStyle: style),
  ),
  _Variant(
    'TextButton',
    (_Options options) => TextButton(
      key: _buttonKey,
      onPressed: options.onPressed,
      onLongPress: options.onLongPress,
      style: options.style,
      statesController: options.statesController,
      isLoading: options.isLoading,
      loadingIndicator: options.loadingIndicator,
      child: _content,
    ),
    (ButtonStyle style, Widget child) =>
        TextButtonTheme(data: style, child: child),
    (ButtonStyle style) => ThemeData(textButtonStyle: style),
  ),
  _Variant(
    'IconButton',
    (_Options options) => IconButton(
      key: _buttonKey,
      onPressed: options.onPressed,
      onLongPress: options.onLongPress,
      style: options.style,
      statesController: options.statesController,
      isLoading: options.isLoading,
      loadingIndicator: options.loadingIndicator,
      icon: _content,
    ),
    (ButtonStyle style, Widget child) =>
        IconButtonTheme(data: style, child: child),
    (ButtonStyle style) => ThemeData(iconButtonStyle: style),
  ),
];

AnimatedSurface _container(WidgetTester tester) =>
    tester.widget<AnimatedSurface>(
      find.descendant(
        of: find.byKey(_buttonKey),
        matching: find.byType(AnimatedSurface),
      ),
    );

void main() {
  for (final _Variant variant in _variants) {
    group(variant.name, () {
      testWidgets('activates taps and long presses', (
        WidgetTester tester,
      ) async {
        int pressed = 0;
        int longPressed = 0;
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () => pressed++,
              onLongPress: () => longPressed++,
            ),
          ),
        );
        await tester.tap(find.byKey(_buttonKey));
        expect(pressed, 1);
        await tester.longPress(find.byKey(_buttonKey));
        expect(longPressed, 1);
        expect(pressed, 1);
        await tester.pumpAndSettle();
      });

      testWidgets('accepts a long press without an onPressed callback', (
        WidgetTester tester,
      ) async {
        int calls = 0;
        await pumpNeutral(
          tester,
          variant.create(_Options(onLongPress: () => calls++)),
        );
        await tester.longPress(find.byKey(_buttonKey));
        expect(calls, 1);
        expect(
          tester.widget<ButtonStyleButton>(find.byKey(_buttonKey)).enabled,
          isTrue,
        );
        await tester.pumpAndSettle();
      });

      testWidgets('disabled state reaches resolvers and semantics', (
        WidgetTester tester,
      ) async {
        final SemanticsHandle semantics = tester.ensureSemantics();
        InteractionState? current;
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              style: ButtonStyle(
                padding: StateProperty<EdgeInsetsGeometry?>.resolveWith((
                  InteractionState state,
                ) {
                  current = state;
                  return null;
                }),
              ),
            ),
          ),
        );
        expect(current!.isDisabled, isTrue);
        expect(
          tester.getSemantics(find.byKey(_buttonKey)),
          matchesSemantics(isButton: true, hasEnabledState: true),
        );
        semantics.dispose();
      });

      testWidgets('pressed and hovered states reach styles and controller', (
        WidgetTester tester,
      ) async {
        final WidgetStatesController controller = WidgetStatesController();
        addTearDown(controller.dispose);
        InteractionState? current;
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () {},
              statesController: controller,
              style: ButtonStyle(
                padding: StateProperty<EdgeInsetsGeometry?>.resolveWith((
                  InteractionState state,
                ) {
                  current = state;
                  return null;
                }),
              ),
            ),
          ),
        );
        final TestGesture mouse = await hover(tester, find.byKey(_buttonKey));
        expect(current!.isHovered, isTrue);
        expect(controller.value, contains(WidgetState.hovered));
        final TestGesture touch = await tester.startGesture(
          tester.getCenter(find.byKey(_buttonKey)),
        );
        await tester.pump(kPressTimeout);
        expect(current!.isPressed, isTrue);
        expect(controller.value, contains(WidgetState.pressed));
        await touch.up();
        await tester.pump();
        expect(current!.isPressed, isFalse);
        await mouse.removePointer();
        await tester.pumpAndSettle();
      });

      testWidgets('resolves inline, component and global styles per state', (
        WidgetTester tester,
      ) async {
        const BoxDecoration global = BoxDecoration(color: Color(0xFF001122));
        const BoxDecoration component = BoxDecoration(color: Color(0xFF223344));
        const BoxDecoration inline = BoxDecoration(color: Color(0xFF445566));
        const ButtonStyle globalStyle = ButtonStyle(
          decoration: StateProperty<Decoration?>.all(global),
          padding: StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(2)),
        );
        await pumpNeutral(
          tester,
          variant.create(_Options(onPressed: () {})),
          theme: variant.globalTheme(globalStyle),
        );
        expect(_container(tester).decoration, global);
        await pumpNeutral(
          tester,
          variant.wrapTheme(
            const ButtonStyle(
              decoration: StateProperty<Decoration?>.all(component),
            ),
            variant.create(_Options(onPressed: () {})),
          ),
          theme: variant.globalTheme(globalStyle),
        );
        expect(_container(tester).decoration, component);
        // A replacing component theme does not inherit the global padding.
        expect(_container(tester).padding, isNull);
        await pumpNeutral(
          tester,
          variant.wrapTheme(
            const ButtonStyle(
              decoration: StateProperty<Decoration?>.all(component),
              padding: StateProperty<EdgeInsetsGeometry?>.all(
                EdgeInsets.all(3),
              ),
            ),
            variant.create(
              _Options(
                onPressed: () {},
                style: ButtonStyle(
                  decoration: StateProperty<Decoration?>.resolveWith(
                    (InteractionState state) => state.isHovered ? inline : null,
                  ),
                  padding: const StateProperty<EdgeInsetsGeometry?>.all(
                    EdgeInsets.all(5),
                  ),
                ),
              ),
            ),
          ),
          theme: variant.globalTheme(globalStyle),
        );
        expect(_container(tester).decoration, component);
        expect(_container(tester).padding, const EdgeInsets.all(5));
        final TestGesture mouse = await hover(tester, find.byKey(_buttonKey));
        expect(_container(tester).decoration, inline);
        await mouse.removePointer();
        await tester.pumpAndSettle();
      });

      testWidgets('constrains finite fixed dimensions to minimum and maximum', (
        WidgetTester tester,
      ) async {
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () {},
              style: const ButtonStyle(
                minimumSize: StateProperty<Size?>.all(Size(30, 25)),
                maximumSize: StateProperty<Size?>.all(Size(60, 45)),
                fixedSize: StateProperty<Size?>.all(Size(100, 5)),
                tapTargetSize: Size.zero,
              ),
            ),
          ),
        );
        expect(tester.getSize(find.byKey(_buttonKey)), const Size(60, 25));
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () {},
              style: const ButtonStyle(
                minimumSize: StateProperty<Size?>.all(Size(30, 25)),
                fixedSize: StateProperty<Size?>.all(Size(double.infinity, 35)),
                tapTargetSize: Size.zero,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.getSize(find.byKey(_buttonKey)), const Size(30, 35));
      });

      testWidgets('loading preserves size and label and blocks interaction', (
        WidgetTester tester,
      ) async {
        int calls = 0;
        final SemanticsHandle semantics = tester.ensureSemantics();
        await pumpNeutral(
          tester,
          variant.create(
            _Options(onPressed: () => calls++, onLongPress: () => calls++),
          ),
        );
        final Size size = tester.getSize(find.byKey(_buttonKey));
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () => calls++,
              onLongPress: () => calls++,
              isLoading: true,
              loadingIndicator: const SizedBox(width: 100, height: 100),
            ),
          ),
        );
        expect(tester.getSize(find.byKey(_buttonKey)), size);
        await tester.tap(find.byKey(_buttonKey));
        await tester.longPress(find.byKey(_buttonKey));
        expect(calls, 0);
        expect(
          tester.getSemantics(find.byKey(_buttonKey)),
          matchesSemantics(isButton: true, hasEnabledState: true),
        );
        semantics.dispose();
        await tester.pumpAndSettle();
      });

      testWidgets(
        'loading indicator uses widget then stateful style precedence',
        (WidgetTester tester) async {
          const Key styleIndicator = Key('style indicator');
          const Key directIndicator = Key('direct indicator');
          final ButtonStyle style = ButtonStyle(
            loadingIndicator: StateProperty<Widget?>.resolveWith(
              (InteractionState state) =>
                  state.isDisabled ? const SizedBox(key: styleIndicator) : null,
            ),
          );
          await pumpNeutral(
            tester,
            variant.create(
              _Options(onPressed: () {}, style: style, isLoading: true),
            ),
          );
          expect(find.byKey(styleIndicator), findsOneWidget);
          await pumpNeutral(
            tester,
            variant.create(
              _Options(
                onPressed: () {},
                style: style,
                isLoading: true,
                loadingIndicator: const SizedBox(key: directIndicator),
              ),
            ),
          );
          expect(find.byKey(styleIndicator), findsNothing);
          expect(find.byKey(directIndicator), findsOneWidget);
        },
      );

      testWidgets('clipping without a decoration does not assert', (
        WidgetTester tester,
      ) async {
        await pumpNeutral(
          tester,
          variant.create(
            _Options(
              onPressed: () {},
              style: const ButtonStyle(clipBehavior: Clip.antiAlias),
            ),
          ),
        );
        expect(
          tester
              .widget<ClipPath>(
                find.descendant(
                  of: find.byType(AnimatedSurface),
                  matching: find.byType(ClipPath),
                ),
              )
              .clipBehavior,
          Clip.none,
        );
        expect(tester.takeException(), isNull);
      });
    });
  }

  testWidgets(
    'text buttons keep content size and compact icons get hit targets',
    (WidgetTester tester) async {
      for (final _Variant variant in _variants) {
        int calls = 0;
        await pumpNeutral(
          tester,
          variant.create(_Options(onPressed: () => calls++)),
        );
        expect(
          tester.getSize(find.byKey(_buttonKey)),
          variant.name == 'IconButton'
              ? const Size(48, 48)
              : const Size(20, 12),
        );
        if (variant.name == 'IconButton') {
          await tester.tapAt(
            tester.getTopLeft(find.byKey(_buttonKey)) + const Offset(1, 1),
          );
          expect(calls, 1);
        }
      }
    },
  );

  testWidgets('unrelated component themes do not affect a button', (
    WidgetTester tester,
  ) async {
    const ButtonStyle unrelated = ButtonStyle(
      padding: StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(20)),
    );
    for (final _Variant variant in _variants) {
      final Widget child = variant.create(_Options(onPressed: () {}));
      await pumpNeutral(
        tester,
        variant.name == 'ElevatedButton'
            ? TextButtonTheme(data: unrelated, child: child)
            : ElevatedButtonTheme(data: unrelated, child: child),
      );
      expect(_container(tester).padding, isNull);
    }
  });

  testWidgets('focus and Enter and Space activation reach the shared engine', (
    WidgetTester tester,
  ) async {
    useTraditionalFocus();
    final FocusNode node = FocusNode();
    addTearDown(node.dispose);
    InteractionState? current;
    int pressed = 0;
    await pumpNeutral(
      tester,
      ElevatedButton(
        key: _buttonKey,
        onPressed: () => pressed++,
        focusNode: node,
        style: ButtonStyle(
          padding: StateProperty<EdgeInsetsGeometry?>.resolveWith((
            InteractionState state,
          ) {
            current = state;
            return null;
          }),
        ),
        child: _content,
      ),
    );
    node.requestFocus();
    await tester.pump();
    await tester.pump();
    expect(current!.isFocused, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, 1);
    expect(current!.isPressed, isTrue);
    await tester.pump(const Duration(milliseconds: 101));
    expect(current!.isPressed, isFalse);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(pressed, 2);
    await tester.pumpAndSettle();
  });

  testWidgets('padding and alignment position content inside the styled box', (
    WidgetTester tester,
  ) async {
    await pumpNeutral(
      tester,
      ElevatedButton(
        key: _buttonKey,
        onPressed: () {},
        style: const ButtonStyle(
          fixedSize: StateProperty<Size?>.all(Size(100, 60)),
          padding: StateProperty<EdgeInsetsGeometry?>.all(
            EdgeInsetsDirectional.only(start: 10, top: 5, end: 20, bottom: 15),
          ),
          alignment: AlignmentDirectional.bottomEnd,
        ),
        child: _content,
      ),
    );
    expect(
      tester.getTopLeft(find.byKey(_contentKey)) -
          tester.getTopLeft(find.byKey(_buttonKey)),
      const Offset(60, 33),
    );
    expect(tester.getSize(find.byKey(_buttonKey)), const Size(100, 60));
  });

  testWidgets('leading, icon, child and trailing use logical slot order', (
    WidgetTester tester,
  ) async {
    const Key leading = Key('leading');
    const Key icon = Key('icon');
    const Key trailing = Key('trailing');
    for (final TextDirection direction in TextDirection.values) {
      for (final IconAlignment alignment in IconAlignment.values) {
        await pumpNeutral(
          tester,
          ElevatedButton.icon(
            key: _buttonKey,
            onPressed: () {},
            leading: const SizedBox(key: leading, width: 5, height: 10),
            icon: const SizedBox(key: icon, width: 6, height: 10),
            label: _content,
            trailing: const SizedBox(key: trailing, width: 7, height: 10),
            iconAlignment: alignment,
            style: const ButtonStyle(spacing: 3),
          ),
          textDirection: direction,
        );
        final List<Key> logicalOrder = <Key>[
          leading,
          if (alignment == IconAlignment.start) icon,
          _contentKey,
          if (alignment == IconAlignment.end) icon,
          trailing,
        ];
        final List<double> positions = logicalOrder
            .map((Key key) => tester.getCenter(find.byKey(key)).dx)
            .toList();
        expect(
          positions,
          direction == TextDirection.ltr
              ? orderedEquals(<double>[...positions]..sort())
              : orderedEquals(
                  <double>[...positions]
                    ..sort((double a, double b) => b.compareTo(a)),
                ),
        );
        expect(tester.getSize(find.byKey(_buttonKey)).width, 47);
      }
    }
  });

  testWidgets('all labeled icon constructors use their icon and label slots', (
    WidgetTester tester,
  ) async {
    final List<Widget> buttons = <Widget>[
      ElevatedButton.icon(
        onPressed: () {},
        icon: const Text('icon'),
        label: const Text('label'),
      ),
      OutlinedButton.icon(
        onPressed: () {},
        icon: const Text('icon'),
        label: const Text('label'),
      ),
      TextButton.icon(
        onPressed: () {},
        icon: const Text('icon'),
        label: const Text('label'),
      ),
    ];
    for (final Widget button in buttons) {
      await pumpNeutral(tester, button);
      expect(find.text('icon'), findsOneWidget);
      expect(find.text('label'), findsOneWidget);
    }
  });

  testWidgets('isSemanticButton controls the accessibility button flag', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    await pumpNeutral(
      tester,
      ElevatedButton(
        key: _buttonKey,
        onPressed: () {},
        isSemanticButton: false,
        child: const Text('Custom role'),
      ),
    );
    expect(
      tester.getSemantics(find.byKey(_buttonKey)),
      matchesSemantics(
        label: 'Custom role',
        textDirection: TextDirection.ltr,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    semantics.dispose();
  });

  testWidgets('loading retains content state and accessible name', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle semantics = tester.ensureSemantics();
    bool loading = false;
    int mounts = 0;
    late StateSetter rebuild;
    await pumpNeutral(
      tester,
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setter) {
          rebuild = setter;
          return ElevatedButton(
            key: _buttonKey,
            onPressed: () {},
            isLoading: loading,
            loadingIndicator: const Text('Loading'),
            child: _StatefulContent(onMount: () => mounts++),
          );
        },
      ),
    );
    expect(mounts, 1);
    final Size normalSize = tester.getSize(find.byKey(_buttonKey));
    rebuild(() => loading = true);
    await tester.pump();
    await tester.pump();
    expect(mounts, 1);
    expect(tester.getSize(find.byKey(_buttonKey)), normalSize);
    expect(
      tester.getSemantics(find.byKey(_buttonKey)),
      matchesSemantics(
        label: 'Save',
        textDirection: TextDirection.ltr,
        isButton: true,
        hasEnabledState: true,
      ),
    );
    rebuild(() => loading = false);
    await tester.pump();
    expect(mounts, 1);
    expect(tester.getSize(find.byKey(_buttonKey)), normalSize);
    semantics.dispose();
  });

  testWidgets(
    'IconButton uses selected content, styles and tooltip semantics',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      InteractionState? current;
      await pumpNeutral(
        tester,
        IconButton(
          key: _buttonKey,
          onPressed: () {},
          icon: const Text('off'),
          selectedIcon: const Text('on'),
          isSelected: true,
          tooltip: 'Favorite',
          style: ButtonStyle(
            padding: StateProperty<EdgeInsetsGeometry?>.resolveWith((
              InteractionState state,
            ) {
              current = state;
              return null;
            }),
          ),
        ),
      );
      expect(find.text('on'), findsOneWidget);
      expect(find.text('off'), findsNothing);
      expect(current!.isSelected, isTrue);
      expect(
        tester.getSemantics(find.byKey(_buttonKey)),
        matchesSemantics(
          label: 'on',
          tooltip: 'Favorite',
          textDirection: TextDirection.ltr,
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          hasSelectedState: true,
          isSelected: true,
          hasTapAction: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
      semantics.dispose();
    },
  );
}
