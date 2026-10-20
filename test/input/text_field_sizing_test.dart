import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart';
import 'package:neutral_ui/src/foundation/animated_surface.dart';

import '../helpers/pump.dart';

const TextFieldStyle _style = TextFieldStyle(
  decoration: StateProperty<Decoration?>.all(
    BoxDecoration(border: Border.fromBorderSide(BorderSide())),
  ),
  contentPadding: StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(12)),
  textStyle: StateProperty<TextStyle?>.all(
    TextStyle(fontSize: 14, height: 1.4),
  ),
  hintStyle: StateProperty<TextStyle?>.all(
    TextStyle(fontSize: 14, height: 1.4),
  ),
  labelStyle: StateProperty<TextStyle?>.all(
    TextStyle(fontSize: 12, height: 1.4),
  ),
  helperStyle: StateProperty<TextStyle?>.all(
    TextStyle(fontSize: 12, height: 1.4),
  ),
  iconTheme: StateProperty<IconThemeData?>.all(IconThemeData(size: 18)),
  spacing: 6,
);

Finder _surface() => find
    .descendant(
      of: find.byType(TextField),
      matching: find.byType(AnimatedSurface),
    )
    .first;

Rect _box(WidgetTester tester) => tester.getRect(_surface());

RenderEditable _editable(WidgetTester tester) =>
    tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;

Rect _paintedBounds(WidgetTester tester, Finder finder) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  return MatrixUtils.transformRect(
    box.getTransformTo(null),
    Offset.zero & box.size,
  );
}

void _expectNoLayoutError(WidgetTester tester) =>
    expect(tester.takeException(), isNull);

void main() {
  testWidgets(
    '30px input reduces padding before typography and keeps labels outside',
    (WidgetTester tester) async {
      final TextEditingController text = TextEditingController(text: 'secret');
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 280,
          height: 30,
          controller: text,
          obscureText: true,
          showClearButton: true,
          showObscureTextToggle: true,
          labelText: 'Password',
          helperText: 'Keep this private',
          counterText: '6 characters',
          style: _style,
        ),
      );
      _expectNoLayoutError(tester);
      final Rect box = _box(tester);
      expect(box.size, const Size(280, 30));
      expect(
        tester.getBottomLeft(find.text('Password')).dy,
        lessThanOrEqualTo(box.top),
      );
      expect(
        tester.getTopLeft(find.text('Keep this private')).dy,
        greaterThanOrEqualTo(box.bottom),
      );
      expect(
        tester.getTopLeft(find.text('6 characters')).dy,
        greaterThanOrEqualTo(box.bottom),
      );
      expect(tester.getSize(find.text('Password')).width, 280);
      expect(_editable(tester).preferredLineHeight, closeTo(19.6, 0.5));
      for (final Finder icon in <Finder>[
        find.byType(CloseGlyph),
        find.byType(EyeGlyph),
      ]) {
        final Rect bounds = _paintedBounds(tester, icon);
        expect(bounds.height, closeTo(18, 0.01));
        expect(bounds.top, greaterThanOrEqualTo(box.top - 0.01));
        expect(bounds.bottom, lessThanOrEqualTo(box.bottom + 0.01));
      }
      await tester.tap(find.byType(EyeGlyph));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      expect(_box(tester).size, const Size(280, 30));
      await tester.tap(find.byType(CloseGlyph));
      await tester.pumpAndSettle();
      expect(text.text, isEmpty);
      _expectNoLayoutError(tester);
    },
  );

  for (final double height in <double>[0, 12, 20]) {
    testWidgets('height $height bounds text cursor and both default actions', (
      WidgetTester tester,
    ) async {
      final TextEditingController text = TextEditingController(text: 'secret');
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 180,
          height: height,
          controller: text,
          obscureText: true,
          showClearButton: true,
          showObscureTextToggle: true,
          style: _style.copyWith(cursorHeight: 40),
        ),
      );
      _expectNoLayoutError(tester);
      final Rect box = _box(tester);
      expect(box.height, height);
      final RenderEditable editable = _editable(tester);
      expect(editable.preferredLineHeight, lessThanOrEqualTo(height + 0.5));
      expect(editable.cursorHeight, lessThanOrEqualTo(height + 0.01));
      expect(editable.localToGlobal(Offset.zero).isFinite, isTrue);
      if (height == 0) return;
      for (final Finder icon in <Finder>[
        find.byType(CloseGlyph),
        find.byType(EyeGlyph),
      ]) {
        final Rect bounds = _paintedBounds(tester, icon);
        expect(bounds.height, lessThanOrEqualTo(height + 0.01));
      }
    });
  }

  for (final TextDirection direction in TextDirection.values) {
    for (final double width in <double>[0, 30, 90]) {
      testWidgets(
        'narrow width $width fits large slots and actions in $direction',
        (WidgetTester tester) async {
          final TextEditingController text = TextEditingController(
            text: 'secret',
          );
          addTearDown(text.dispose);
          await pumpNeutralApp(
            tester,
            TextField(
              width: width,
              height: 30,
              controller: text,
              obscureText: true,
              showClearButton: true,
              showObscureTextToggle: true,
              prefixIcon: const SizedBox(
                width: 80,
                height: 70,
                child: SearchGlyph(),
              ),
              suffix: const SizedBox(
                width: 100,
                height: 60,
                child: Text('A long suffix'),
              ),
              style: _style,
            ),
            textDirection: direction,
          );
          _expectNoLayoutError(tester);
          final Rect box = _box(tester);
          expect(box.size, Size(width, 30));
          expect(_editable(tester).localToGlobal(Offset.zero).isFinite, isTrue);
          if (width == 0) return;
          for (final Finder icon in <Finder>[
            find.byType(SearchGlyph),
            find.byType(CloseGlyph),
            find.byType(EyeGlyph),
          ]) {
            final Rect bounds = _paintedBounds(tester, icon);
            expect(bounds.left, greaterThanOrEqualTo(box.left - 0.01));
            expect(bounds.right, lessThanOrEqualTo(box.right + 0.01));
            expect(bounds.top, greaterThanOrEqualTo(box.top - 0.01));
            expect(bounds.bottom, lessThanOrEqualTo(box.bottom + 0.01));
          }
        },
      );
    }
  }

  testWidgets(
    'RTL positions leading content and trailing actions directionally',
    (WidgetTester tester) async {
      final TextEditingController text = TextEditingController(text: 'query');
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 220,
          height: 30,
          controller: text,
          prefixIcon: const SearchGlyph(),
          showClearButton: true,
          style: _style,
        ),
        textDirection: TextDirection.rtl,
      );
      _expectNoLayoutError(tester);
      expect(
        _paintedBounds(tester, find.byType(SearchGlyph)).center.dx,
        greaterThan(_paintedBounds(tester, find.byType(CloseGlyph)).center.dx),
      );
      final RenderEditable editable = _editable(tester);
      final Rect bounds = MatrixUtils.transformRect(
        editable.getTransformTo(null),
        Offset.zero & editable.size,
      );
      expect(bounds.left, greaterThanOrEqualTo(_box(tester).left));
      expect(bounds.right, lessThanOrEqualTo(_box(tester).right));
    },
  );

  for (final TextDirection direction in TextDirection.values) {
    testWidgets('compact field caret geometry remains native in $direction', (
      WidgetTester tester,
    ) async {
      final TextEditingController text = TextEditingController(
        text: 'abcdefghij',
      );
      addTearDown(text.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 240,
          height: 20,
          controller: text,
          prefixIcon: const SearchGlyph(),
          style: _style,
        ),
        textDirection: direction,
      );
      final RenderEditable editable = _editable(tester);
      final Rect caret = editable.getLocalRectForCaret(
        const TextPosition(offset: 3),
      );
      await tester.tapAt(editable.localToGlobal(caret.center));
      await tester.pumpAndSettle();
      _expectNoLayoutError(tester);
      expect(text.selection.isValid, isTrue);
      expect(text.selection.isCollapsed, isTrue);
      expect(text.selection.baseOffset, inInclusiveRange(2, 4));
    });
  }

  for (final double height in <double>[30, 80]) {
    testWidgets(
      'text scale 2 fits height $height and remains full size when room permits',
      (WidgetTester tester) async {
        await pumpNeutralApp(
          tester,
          Builder(
            builder: (BuildContext context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: TextField(
                width: 240,
                height: height,
                hintText: 'Accessible hint',
                style: _style,
              ),
            ),
          ),
        );
        _expectNoLayoutError(tester);
        expect(_box(tester).height, height);
        final double line = _editable(tester).preferredLineHeight;
        expect(line, lessThanOrEqualTo(height - 2 + 0.5));
        if (height == 80) expect(line, closeTo(39.2, 0.5));
      },
    );
  }

  testWidgets(
    'long single line scrolls horizontally without shrinking its typography',
    (WidgetTester tester) async {
      final TextEditingController text = TextEditingController(text: 'Short');
      final FocusNode focus = FocusNode();
      final ScrollController scroll = ScrollController();
      addTearDown(text.dispose);
      addTearDown(focus.dispose);
      addTearDown(scroll.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 120,
          height: 40,
          controller: text,
          focusNode: focus,
          scrollController: scroll,
          style: _style,
        ),
      );
      final double line = _editable(tester).preferredLineHeight;
      focus.requestFocus();
      await tester.pump();
      text.value = TextEditingValue(
        text: 'A long value that should scroll inside the native editable viewport',
        selection: const TextSelection.collapsed(offset: 66),
      );
      await tester.pumpAndSettle();
      _expectNoLayoutError(tester);
      expect(_editable(tester).preferredLineHeight, closeTo(line, 0.01));
      expect(scroll.position.maxScrollExtent, greaterThan(0));
      expect(scroll.offset, greaterThan(0));
    },
  );

  testWidgets(
    'fixed multiline viewport scrolls while retaining its baseline size',
    (WidgetTester tester) async {
      final String value = List<String>.generate(
        12,
        (int i) => 'Line $i',
      ).join('\n');
      final TextEditingController text = TextEditingController(text: value);
      final ScrollController scroll = ScrollController();
      final FocusNode focus = FocusNode();
      addTearDown(text.dispose);
      addTearDown(scroll.dispose);
      addTearDown(focus.dispose);
      await pumpNeutralApp(
        tester,
        TextField(
          width: 200,
          height: 60,
          maxLines: null,
          controller: text,
          focusNode: focus,
          scrollController: scroll,
          style: _style,
        ),
      );
      focus.requestFocus();
      await tester.pump();
      text.selection = TextSelection.collapsed(offset: value.length);
      await tester.pumpAndSettle();
      _expectNoLayoutError(tester);
      expect(_box(tester).size, const Size(200, 60));
      expect(_editable(tester).preferredLineHeight, closeTo(19.6, 0.5));
      expect(scroll.position.maxScrollExtent, greaterThan(0));
      expect(scroll.offset, greaterThan(0));
    },
  );

  testWidgets(
    'size tokens clamp fixed dimensions and widget dimensions override them',
    (WidgetTester tester) async {
      const TextFieldStyle tokens = TextFieldStyle(
        minimumSize: StateProperty<Size?>.all(Size(100, 40)),
        fixedSize: StateProperty<Size?>.all(Size(200, 60)),
        maximumSize: StateProperty<Size?>.all(Size(180, 50)),
      );
      await pumpNeutralApp(tester, const TextField(style: tokens));
      expect(_box(tester).size, const Size(180, 50));
      await pumpNeutralApp(
        tester,
        const TextField(width: 150, height: 30, style: tokens),
      );
      expect(_box(tester).size, const Size(150, 30));
      _expectNoLayoutError(tester);
    },
  );

  testWidgets('parent bounds still constrain a requested larger input box', (
    WidgetTester tester,
  ) async {
    await pumpNeutralApp(
      tester,
      const SizedBox(
        width: 130,
        height: 24,
        child: TextField(width: 280, height: 60, style: _style),
      ),
    );
    _expectNoLayoutError(tester);
    expect(_box(tester).size, const Size(130, 24));
    expect(_editable(tester).preferredLineHeight, lessThanOrEqualTo(22.5));
  });

  testWidgets(
    'explicit width also bounds the label and supporting text under a wider parent',
    (WidgetTester tester) async {
      await pumpNeutralApp(
        tester,
        const SizedBox(
          width: 350,
          child: TextField(
            width: 150,
            height: 30,
            labelText: 'Label',
            helperText: 'Supporting text',
            style: _style,
          ),
        ),
      );
      _expectNoLayoutError(tester);
      final Rect box = _box(tester);
      expect(box.size, const Size(150, 30));
      for (final String label in <String>['Label', 'Supporting text']) {
        final Rect bounds = tester.getRect(find.text(label));
        expect(bounds.left, closeTo(box.left, 0.01));
        expect(bounds.right, lessThanOrEqualTo(box.right + 0.01));
      }
    },
  );

  testWidgets(
    'focused resize preserves native editable state value selection and semantics',
    (WidgetTester tester) async {
      final SemanticsHandle semantics = tester.ensureSemantics();
      try {
        final TextEditingController text = TextEditingController(
          text: 'Preserve this selection',
        );
        final FocusNode focus = FocusNode();
        addTearDown(text.dispose);
        addTearDown(focus.dispose);
        double height = 30;
        late StateSetter update;
        await pumpNeutralApp(
          tester,
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              update = setState;
              return TextField(
                width: 220,
                height: height,
                controller: text,
                focusNode: focus,
                labelText: 'Resizing field',
                style: _style,
              );
            },
          ),
        );
        focus.requestFocus();
        await tester.pump();
        text.selection = const TextSelection(baseOffset: 2, extentOffset: 8);
        await tester.pumpAndSettle();
        final EditableTextState before = tester.state<EditableTextState>(
          find.byType(EditableText),
        );
        update(() => height = 60);
        await tester.pumpAndSettle();
        _expectNoLayoutError(tester);
        expect(_box(tester).height, 60);
        expect(focus.hasFocus, isTrue);
        expect(text.text, 'Preserve this selection');
        expect(
          text.selection,
          const TextSelection(baseOffset: 2, extentOffset: 8),
        );
        expect(
          tester.state<EditableTextState>(find.byType(EditableText)),
          same(before),
        );
        expect(
          tester
              .getSemantics(find.byType(EditableText))
              .getSemanticsData()
              .flagsCollection
              .isTextField,
          isTrue,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'TextFormField forwards explicit size and vertical alignment to its input box',
    (WidgetTester tester) async {
      await pumpNeutralApp(
        tester,
        TextFormField(
          width: 180,
          height: 30,
          textAlignVertical: TextAlignVertical.bottom,
          labelText: 'Form field',
          style: _style,
        ),
      );
      _expectNoLayoutError(tester);
      expect(_box(tester).size, const Size(180, 30));
      expect(
        tester.widget<TextField>(find.byType(TextField)).textAlignVertical,
        TextAlignVertical.bottom,
      );
    },
  );
}
