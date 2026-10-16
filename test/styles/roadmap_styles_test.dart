import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

Widget _firstTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => child;
Widget _secondTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => FadeTransition(opacity: animation, child: child);
void main() {
  test(
    'TextFieldStyle.decoration participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<Decoration?> firstToken =
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          );
      final StateProperty<Decoration?> secondToken =
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF445566)),
          );
      final TextFieldStyle first = TextFieldStyle(decoration: firstToken);
      final TextFieldStyle second = TextFieldStyle(decoration: secondToken);
      expect(empty.decoration, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(decoration: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(decoration: firstToken));
      expect(first.hashCode, TextFieldStyle(decoration: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('decoration:'));
    },
  );
  test('TextFieldStyle.foregroundDecoration participates in the complete token contract', () {
    const TextFieldStyle empty = TextFieldStyle();
    final StateProperty<Decoration?> firstToken =
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        );
    final StateProperty<Decoration?> secondToken =
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        );
    final TextFieldStyle first = TextFieldStyle(
      foregroundDecoration: firstToken,
    );
    final TextFieldStyle second = TextFieldStyle(
      foregroundDecoration: secondToken,
    );
    expect(empty.foregroundDecoration, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(foregroundDecoration: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, TextFieldStyle(foregroundDecoration: firstToken));
    expect(
      first.hashCode,
      TextFieldStyle(foregroundDecoration: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('foregroundDecoration:'));
  });
  test(
    'TextFieldStyle.textStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(textStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(textStyle: secondToken);
      expect(empty.textStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(textStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(textStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(textStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('textStyle:'));
    },
  );
  test(
    'TextFieldStyle.hintStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(hintStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(hintStyle: secondToken);
      expect(empty.hintStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(hintStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(hintStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(hintStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('hintStyle:'));
    },
  );
  test(
    'TextFieldStyle.labelStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(labelStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(labelStyle: secondToken);
      expect(empty.labelStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(labelStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(labelStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(labelStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('labelStyle:'));
    },
  );
  test(
    'TextFieldStyle.helperStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(helperStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(helperStyle: secondToken);
      expect(empty.helperStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(helperStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(helperStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(helperStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('helperStyle:'));
    },
  );
  test(
    'TextFieldStyle.errorStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(errorStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(errorStyle: secondToken);
      expect(empty.errorStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(errorStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(errorStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(errorStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('errorStyle:'));
    },
  );
  test(
    'TextFieldStyle.counterStyle participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<TextStyle?> firstToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 12));
      final StateProperty<TextStyle?> secondToken =
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 18));
      final TextFieldStyle first = TextFieldStyle(counterStyle: firstToken);
      final TextFieldStyle second = TextFieldStyle(counterStyle: secondToken);
      expect(empty.counterStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(counterStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(counterStyle: firstToken));
      expect(first.hashCode, TextFieldStyle(counterStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('counterStyle:'));
    },
  );
  test(
    'TextFieldStyle.contentPadding participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<EdgeInsetsGeometry?> firstToken =
          const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(2));
      final StateProperty<EdgeInsetsGeometry?> secondToken =
          const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(4));
      final TextFieldStyle first = TextFieldStyle(contentPadding: firstToken);
      final TextFieldStyle second = TextFieldStyle(contentPadding: secondToken);
      expect(empty.contentPadding, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(contentPadding: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(contentPadding: firstToken));
      expect(
        first.hashCode,
        TextFieldStyle(contentPadding: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('contentPadding:'));
    },
  );
  test(
    'TextFieldStyle.cursorColor participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<Color?> firstToken = const StateProperty<Color?>.all(
        Color(0xFF112233),
      );
      final StateProperty<Color?> secondToken = const StateProperty<Color?>.all(
        Color(0xFF445566),
      );
      final TextFieldStyle first = TextFieldStyle(cursorColor: firstToken);
      final TextFieldStyle second = TextFieldStyle(cursorColor: secondToken);
      expect(empty.cursorColor, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(cursorColor: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(cursorColor: firstToken));
      expect(first.hashCode, TextFieldStyle(cursorColor: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('cursorColor:'));
    },
  );
  test(
    'TextFieldStyle.selectionColor participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<Color?> firstToken = const StateProperty<Color?>.all(
        Color(0xFF112233),
      );
      final StateProperty<Color?> secondToken = const StateProperty<Color?>.all(
        Color(0xFF445566),
      );
      final TextFieldStyle first = TextFieldStyle(selectionColor: firstToken);
      final TextFieldStyle second = TextFieldStyle(selectionColor: secondToken);
      expect(empty.selectionColor, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(selectionColor: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(selectionColor: firstToken));
      expect(
        first.hashCode,
        TextFieldStyle(selectionColor: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('selectionColor:'));
    },
  );
  test(
    'TextFieldStyle.mouseCursor participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<MouseCursor?> firstToken =
          const StateProperty<MouseCursor?>.all(SystemMouseCursors.click);
      final StateProperty<MouseCursor?> secondToken =
          const StateProperty<MouseCursor?>.all(SystemMouseCursors.basic);
      final TextFieldStyle first = TextFieldStyle(mouseCursor: firstToken);
      final TextFieldStyle second = TextFieldStyle(mouseCursor: secondToken);
      expect(empty.mouseCursor, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(mouseCursor: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(mouseCursor: firstToken));
      expect(first.hashCode, TextFieldStyle(mouseCursor: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('mouseCursor:'));
    },
  );
  test(
    'TextFieldStyle.iconTheme participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final StateProperty<IconThemeData?> firstToken =
          const StateProperty<IconThemeData?>.all(IconThemeData(size: 12));
      final StateProperty<IconThemeData?> secondToken =
          const StateProperty<IconThemeData?>.all(IconThemeData(size: 18));
      final TextFieldStyle first = TextFieldStyle(iconTheme: firstToken);
      final TextFieldStyle second = TextFieldStyle(iconTheme: secondToken);
      expect(empty.iconTheme, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(iconTheme: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(iconTheme: firstToken));
      expect(first.hashCode, TextFieldStyle(iconTheme: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('iconTheme:'));
    },
  );
  test(
    'TextFieldStyle.labelBehavior participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final TextFieldLabelBehavior firstToken = TextFieldLabelBehavior.above;
      final TextFieldLabelBehavior secondToken =
          TextFieldLabelBehavior.floating;
      final TextFieldStyle first = TextFieldStyle(labelBehavior: firstToken);
      final TextFieldStyle second = TextFieldStyle(labelBehavior: secondToken);
      expect(empty.labelBehavior, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(labelBehavior: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(labelBehavior: firstToken));
      expect(
        first.hashCode,
        TextFieldStyle(labelBehavior: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('labelBehavior:'));
    },
  );
  test(
    'TextFieldStyle.labelScale participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final double firstToken = 2.0;
      final double secondToken = 4.0;
      final TextFieldStyle first = TextFieldStyle(labelScale: firstToken);
      final TextFieldStyle second = TextFieldStyle(labelScale: secondToken);
      expect(empty.labelScale, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(labelScale: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(labelScale: firstToken));
      expect(first.hashCode, TextFieldStyle(labelScale: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('labelScale:'));
    },
  );
  test(
    'TextFieldStyle.spacing participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final double firstToken = 2.0;
      final double secondToken = 4.0;
      final TextFieldStyle first = TextFieldStyle(spacing: firstToken);
      final TextFieldStyle second = TextFieldStyle(spacing: secondToken);
      expect(empty.spacing, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(spacing: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(spacing: firstToken));
      expect(first.hashCode, TextFieldStyle(spacing: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('spacing:'));
    },
  );
  test(
    'TextFieldStyle.cursorWidth participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final double firstToken = 2.0;
      final double secondToken = 4.0;
      final TextFieldStyle first = TextFieldStyle(cursorWidth: firstToken);
      final TextFieldStyle second = TextFieldStyle(cursorWidth: secondToken);
      expect(empty.cursorWidth, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(cursorWidth: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(cursorWidth: firstToken));
      expect(first.hashCode, TextFieldStyle(cursorWidth: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('cursorWidth:'));
    },
  );
  test(
    'TextFieldStyle.cursorHeight participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final double firstToken = 2.0;
      final double secondToken = 4.0;
      final TextFieldStyle first = TextFieldStyle(cursorHeight: firstToken);
      final TextFieldStyle second = TextFieldStyle(cursorHeight: secondToken);
      expect(empty.cursorHeight, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(cursorHeight: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(cursorHeight: firstToken));
      expect(first.hashCode, TextFieldStyle(cursorHeight: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('cursorHeight:'));
    },
  );
  test(
    'TextFieldStyle.cursorRadius participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final Radius firstToken = const Radius.circular(2);
      final Radius secondToken = const Radius.circular(4);
      final TextFieldStyle first = TextFieldStyle(cursorRadius: firstToken);
      final TextFieldStyle second = TextFieldStyle(cursorRadius: secondToken);
      expect(empty.cursorRadius, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(cursorRadius: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(cursorRadius: firstToken));
      expect(first.hashCode, TextFieldStyle(cursorRadius: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('cursorRadius:'));
    },
  );
  test(
    'TextFieldStyle.clipBehavior participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final Clip firstToken = Clip.hardEdge;
      final Clip secondToken = Clip.antiAlias;
      final TextFieldStyle first = TextFieldStyle(clipBehavior: firstToken);
      final TextFieldStyle second = TextFieldStyle(clipBehavior: secondToken);
      expect(empty.clipBehavior, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(clipBehavior: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(clipBehavior: firstToken));
      expect(first.hashCode, TextFieldStyle(clipBehavior: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('clipBehavior:'));
    },
  );
  test(
    'TextFieldStyle.scrollPadding participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final EdgeInsets firstToken = const EdgeInsets.all(2);
      final EdgeInsets secondToken = const EdgeInsets.all(4);
      final TextFieldStyle first = TextFieldStyle(scrollPadding: firstToken);
      final TextFieldStyle second = TextFieldStyle(scrollPadding: secondToken);
      expect(empty.scrollPadding, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(scrollPadding: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(scrollPadding: firstToken));
      expect(
        first.hashCode,
        TextFieldStyle(scrollPadding: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('scrollPadding:'));
    },
  );
  test('TextFieldStyle.animationDuration participates in the complete token contract', () {
    const TextFieldStyle empty = TextFieldStyle();
    final Duration firstToken = const Duration(milliseconds: 100);
    final Duration secondToken = const Duration(milliseconds: 200);
    final TextFieldStyle first = TextFieldStyle(animationDuration: firstToken);
    final TextFieldStyle second = TextFieldStyle(
      animationDuration: secondToken,
    );
    expect(empty.animationDuration, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(animationDuration: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, TextFieldStyle(animationDuration: firstToken));
    expect(
      first.hashCode,
      TextFieldStyle(animationDuration: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('animationDuration:'));
  });
  test(
    'TextFieldStyle.animationCurve participates in the complete token contract',
    () {
      const TextFieldStyle empty = TextFieldStyle();
      final Curve firstToken = Curves.linear;
      final Curve secondToken = Curves.easeInOut;
      final TextFieldStyle first = TextFieldStyle(animationCurve: firstToken);
      final TextFieldStyle second = TextFieldStyle(animationCurve: secondToken);
      expect(empty.animationCurve, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(animationCurve: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, TextFieldStyle(animationCurve: firstToken));
      expect(
        first.hashCode,
        TextFieldStyle(animationCurve: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('animationCurve:'));
    },
  );
  test(
    'AutocompleteStyle.fieldStyle participates in the complete token contract',
    () {
      const AutocompleteStyle empty = AutocompleteStyle();
      final TextFieldStyle firstToken = const TextFieldStyle(spacing: 2);
      final TextFieldStyle secondToken = const TextFieldStyle(spacing: 4);
      final AutocompleteStyle first = AutocompleteStyle(fieldStyle: firstToken);
      final AutocompleteStyle second = AutocompleteStyle(
        fieldStyle: secondToken,
      );
      expect(empty.fieldStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(fieldStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, AutocompleteStyle(fieldStyle: firstToken));
      expect(
        first.hashCode,
        AutocompleteStyle(fieldStyle: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('fieldStyle:'));
    },
  );
  test(
    'AutocompleteStyle.menuStyle participates in the complete token contract',
    () {
      const AutocompleteStyle empty = AutocompleteStyle();
      final MenuStyle firstToken = const MenuStyle(offset: Offset(1, 2));
      final MenuStyle secondToken = const MenuStyle(offset: Offset(3, 4));
      final AutocompleteStyle first = AutocompleteStyle(menuStyle: firstToken);
      final AutocompleteStyle second = AutocompleteStyle(
        menuStyle: secondToken,
      );
      expect(empty.menuStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(menuStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, AutocompleteStyle(menuStyle: firstToken));
      expect(first.hashCode, AutocompleteStyle(menuStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('menuStyle:'));
    },
  );
  test(
    'AutocompleteStyle.itemStyle participates in the complete token contract',
    () {
      const AutocompleteStyle empty = AutocompleteStyle();
      final ButtonStyle firstToken = const ButtonStyle(spacing: 2);
      final ButtonStyle secondToken = const ButtonStyle(spacing: 4);
      final AutocompleteStyle first = AutocompleteStyle(itemStyle: firstToken);
      final AutocompleteStyle second = AutocompleteStyle(
        itemStyle: secondToken,
      );
      expect(empty.itemStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(itemStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, AutocompleteStyle(itemStyle: firstToken));
      expect(first.hashCode, AutocompleteStyle(itemStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('itemStyle:'));
    },
  );
  test('AutocompleteStyle.optionsMaxHeight participates in the complete token contract', () {
    const AutocompleteStyle empty = AutocompleteStyle();
    final double firstToken = 2.0;
    final double secondToken = 4.0;
    final AutocompleteStyle first = AutocompleteStyle(
      optionsMaxHeight: firstToken,
    );
    final AutocompleteStyle second = AutocompleteStyle(
      optionsMaxHeight: secondToken,
    );
    expect(empty.optionsMaxHeight, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(optionsMaxHeight: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, AutocompleteStyle(optionsMaxHeight: firstToken));
    expect(
      first.hashCode,
      AutocompleteStyle(optionsMaxHeight: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('optionsMaxHeight:'));
  });
  test('AutocompleteStyle.optionsViewOpenDirection participates in the complete token contract', () {
    const AutocompleteStyle empty = AutocompleteStyle();
    final OptionsViewOpenDirection firstToken = OptionsViewOpenDirection.up;
    final OptionsViewOpenDirection secondToken = OptionsViewOpenDirection.down;
    final AutocompleteStyle first = AutocompleteStyle(
      optionsViewOpenDirection: firstToken,
    );
    final AutocompleteStyle second = AutocompleteStyle(
      optionsViewOpenDirection: secondToken,
    );
    expect(empty.optionsViewOpenDirection, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(optionsViewOpenDirection: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, AutocompleteStyle(optionsViewOpenDirection: firstToken));
    expect(
      first.hashCode,
      AutocompleteStyle(optionsViewOpenDirection: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('optionsViewOpenDirection:'));
  });
  test(
    'SearchStyle.fieldStyle participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final TextFieldStyle firstToken = const TextFieldStyle(spacing: 2);
      final TextFieldStyle secondToken = const TextFieldStyle(spacing: 4);
      final SearchStyle first = SearchStyle(fieldStyle: firstToken);
      final SearchStyle second = SearchStyle(fieldStyle: secondToken);
      expect(empty.fieldStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(fieldStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(fieldStyle: firstToken));
      expect(first.hashCode, SearchStyle(fieldStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('fieldStyle:'));
    },
  );
  test(
    'SearchStyle.viewDecoration participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final Decoration firstToken = const BoxDecoration(
        color: Color(0xFF112233),
      );
      final Decoration secondToken = const BoxDecoration(
        color: Color(0xFF445566),
      );
      final SearchStyle first = SearchStyle(viewDecoration: firstToken);
      final SearchStyle second = SearchStyle(viewDecoration: secondToken);
      expect(empty.viewDecoration, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(viewDecoration: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(viewDecoration: firstToken));
      expect(first.hashCode, SearchStyle(viewDecoration: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('viewDecoration:'));
    },
  );
  test(
    'SearchStyle.viewPadding participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final EdgeInsetsGeometry firstToken = const EdgeInsets.all(2);
      final EdgeInsetsGeometry secondToken = const EdgeInsets.all(4);
      final SearchStyle first = SearchStyle(viewPadding: firstToken);
      final SearchStyle second = SearchStyle(viewPadding: secondToken);
      expect(empty.viewPadding, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(viewPadding: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(viewPadding: firstToken));
      expect(first.hashCode, SearchStyle(viewPadding: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('viewPadding:'));
    },
  );
  test(
    'SearchStyle.suggestionStyle participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final ButtonStyle firstToken = const ButtonStyle(spacing: 2);
      final ButtonStyle secondToken = const ButtonStyle(spacing: 4);
      final SearchStyle first = SearchStyle(suggestionStyle: firstToken);
      final SearchStyle second = SearchStyle(suggestionStyle: secondToken);
      expect(empty.suggestionStyle, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(suggestionStyle: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(suggestionStyle: firstToken));
      expect(first.hashCode, SearchStyle(suggestionStyle: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('suggestionStyle:'));
    },
  );
  test('SearchStyle.menuStyle participates in the complete token contract', () {
    const SearchStyle empty = SearchStyle();
    final MenuStyle firstToken = const MenuStyle(offset: Offset(1, 2));
    final MenuStyle secondToken = const MenuStyle(offset: Offset(3, 4));
    final SearchStyle first = SearchStyle(menuStyle: firstToken);
    final SearchStyle second = SearchStyle(menuStyle: secondToken);
    expect(empty.menuStyle, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(menuStyle: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, SearchStyle(menuStyle: firstToken));
    expect(first.hashCode, SearchStyle(menuStyle: firstToken).hashCode);
    expect(first, isNot(second));
    expect(first.toString(), contains('menuStyle:'));
  });
  test(
    'SearchStyle.constraints participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final BoxConstraints firstToken = const BoxConstraints(maxWidth: 100);
      final BoxConstraints secondToken = const BoxConstraints(maxWidth: 200);
      final SearchStyle first = SearchStyle(constraints: firstToken);
      final SearchStyle second = SearchStyle(constraints: secondToken);
      expect(empty.constraints, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(constraints: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(constraints: firstToken));
      expect(first.hashCode, SearchStyle(constraints: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('constraints:'));
    },
  );
  test('SearchStyle.transitionDuration participates in the complete token contract', () {
    const SearchStyle empty = SearchStyle();
    final Duration firstToken = const Duration(milliseconds: 100);
    final Duration secondToken = const Duration(milliseconds: 200);
    final SearchStyle first = SearchStyle(transitionDuration: firstToken);
    final SearchStyle second = SearchStyle(transitionDuration: secondToken);
    expect(empty.transitionDuration, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(transitionDuration: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, SearchStyle(transitionDuration: firstToken));
    expect(
      first.hashCode,
      SearchStyle(transitionDuration: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('transitionDuration:'));
  });
  test('SearchStyle.reverseTransitionDuration participates in the complete token contract', () {
    const SearchStyle empty = SearchStyle();
    final Duration firstToken = const Duration(milliseconds: 100);
    final Duration secondToken = const Duration(milliseconds: 200);
    final SearchStyle first = SearchStyle(
      reverseTransitionDuration: firstToken,
    );
    final SearchStyle second = SearchStyle(
      reverseTransitionDuration: secondToken,
    );
    expect(empty.reverseTransitionDuration, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(reverseTransitionDuration: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, SearchStyle(reverseTransitionDuration: firstToken));
    expect(
      first.hashCode,
      SearchStyle(reverseTransitionDuration: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('reverseTransitionDuration:'));
  });
  test(
    'SearchStyle.transitionCurve participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final Curve firstToken = Curves.linear;
      final Curve secondToken = Curves.easeInOut;
      final SearchStyle first = SearchStyle(transitionCurve: firstToken);
      final SearchStyle second = SearchStyle(transitionCurve: secondToken);
      expect(empty.transitionCurve, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(transitionCurve: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(transitionCurve: firstToken));
      expect(first.hashCode, SearchStyle(transitionCurve: firstToken).hashCode);
      expect(first, isNot(second));
      expect(first.toString(), contains('transitionCurve:'));
    },
  );
  test('SearchStyle.reverseTransitionCurve participates in the complete token contract', () {
    const SearchStyle empty = SearchStyle();
    final Curve firstToken = Curves.linear;
    final Curve secondToken = Curves.easeInOut;
    final SearchStyle first = SearchStyle(reverseTransitionCurve: firstToken);
    final SearchStyle second = SearchStyle(reverseTransitionCurve: secondToken);
    expect(empty.reverseTransitionCurve, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(reverseTransitionCurve: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, SearchStyle(reverseTransitionCurve: firstToken));
    expect(
      first.hashCode,
      SearchStyle(reverseTransitionCurve: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('reverseTransitionCurve:'));
  });
  test(
    'SearchStyle.transitionBuilder participates in the complete token contract',
    () {
      const SearchStyle empty = SearchStyle();
      final OverlayTransitionBuilder firstToken = _firstTransition;
      final OverlayTransitionBuilder secondToken = _secondTransition;
      final SearchStyle first = SearchStyle(transitionBuilder: firstToken);
      final SearchStyle second = SearchStyle(transitionBuilder: secondToken);
      expect(empty.transitionBuilder, isNull);
      expect(first.copyWith(), first);
      expect(first.copyWith(transitionBuilder: secondToken), second);
      expect(first.merge(null), same(first));
      expect(empty.merge(first), first);
      expect(first.merge(second), first);
      expect(first, SearchStyle(transitionBuilder: firstToken));
      expect(
        first.hashCode,
        SearchStyle(transitionBuilder: firstToken).hashCode,
      );
      expect(first, isNot(second));
      expect(first.toString(), contains('transitionBuilder:'));
    },
  );
  test('SearchStyle.outsideTapBehavior participates in the complete token contract', () {
    const SearchStyle empty = SearchStyle();
    final OutsideTapBehavior firstToken = OutsideTapBehavior.passThrough;
    final OutsideTapBehavior secondToken = OutsideTapBehavior.consume;
    final SearchStyle first = SearchStyle(outsideTapBehavior: firstToken);
    final SearchStyle second = SearchStyle(outsideTapBehavior: secondToken);
    expect(empty.outsideTapBehavior, isNull);
    expect(first.copyWith(), first);
    expect(first.copyWith(outsideTapBehavior: secondToken), second);
    expect(first.merge(null), same(first));
    expect(empty.merge(first), first);
    expect(first.merge(second), first);
    expect(first, SearchStyle(outsideTapBehavior: firstToken));
    expect(
      first.hashCode,
      SearchStyle(outsideTapBehavior: firstToken).hashCode,
    );
    expect(first, isNot(second));
    expect(first.toString(), contains('outsideTapBehavior:'));
  });
}
