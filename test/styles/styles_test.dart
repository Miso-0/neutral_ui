import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

Widget _firstIndicator(
  BuildContext context,
  InteractionState state,
  double value,
  String? label,
) => _firstWidget;
Widget _secondIndicator(
  BuildContext context,
  InteractionState state,
  double value,
  String? label,
) => _secondWidget;

const Widget _firstWidget = SizedBox(width: 1);
const Widget _secondWidget = SizedBox(width: 2);

void main() {
  group('ButtonStyle', () {
    test('decoration copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ButtonStyle changed = first.copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().decoration, first.decoration);
      expect(
        first
            .merge(
              ButtonStyle(
                decoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ButtonStyle().merge(first).decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('foregroundDecoration copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ButtonStyle changed = first.copyWith(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().foregroundDecoration, first.foregroundDecoration);
      expect(
        first
            .merge(
              ButtonStyle(
                foregroundDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ButtonStyle().merge(first).foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('padding copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.all(5),
        ),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.all(5),
        ),
      );
      final ButtonStyle changed = first.copyWith(
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.all(9),
        ),
      );
      expect(
        same.padding,
        const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(5)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.padding,
        const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(9)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().padding, first.padding);
      expect(
        first
            .merge(
              ButtonStyle(
                padding: const StateProperty<EdgeInsetsGeometry?>.all(
                  EdgeInsets.all(9),
                ),
              ),
            )
            .padding,
        const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(5)),
      );
      expect(
        const ButtonStyle().merge(first).padding,
        const StateProperty<EdgeInsetsGeometry?>.all(EdgeInsets.all(5)),
      );
    });
    test('minimumSize copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        minimumSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        minimumSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle changed = first.copyWith(
        minimumSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.minimumSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.minimumSize, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().minimumSize, first.minimumSize);
      expect(
        first
            .merge(
              ButtonStyle(
                minimumSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .minimumSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const ButtonStyle().merge(first).minimumSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('fixedSize copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        fixedSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        fixedSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle changed = first.copyWith(
        fixedSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.fixedSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.fixedSize, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().fixedSize, first.fixedSize);
      expect(
        first
            .merge(
              ButtonStyle(
                fixedSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .fixedSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const ButtonStyle().merge(first).fixedSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('maximumSize copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        maximumSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        maximumSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ButtonStyle changed = first.copyWith(
        maximumSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.maximumSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.maximumSize, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().maximumSize, first.maximumSize);
      expect(
        first
            .merge(
              ButtonStyle(
                maximumSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .maximumSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const ButtonStyle().merge(first).maximumSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('textStyle copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      final ButtonStyle changed = first.copyWith(
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 20)),
      );
      expect(
        same.textStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.textStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 20)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().textStyle, first.textStyle);
      expect(
        first
            .merge(
              ButtonStyle(
                textStyle: const StateProperty<TextStyle?>.all(
                  TextStyle(fontSize: 20),
                ),
              ),
            )
            .textStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(
        const ButtonStyle().merge(first).textStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
    });
    test('iconTheme copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
      );
      final ButtonStyle changed = first.copyWith(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 20),
        ),
      );
      expect(
        same.iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 20)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().iconTheme, first.iconTheme);
      expect(
        first
            .merge(
              ButtonStyle(
                iconTheme: const StateProperty<IconThemeData?>.all(
                  IconThemeData(size: 20),
                ),
              ),
            )
            .iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
      expect(
        const ButtonStyle().merge(first).iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
    });
    test('mouseCursor copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ButtonStyle changed = first.copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.basic,
        ),
      );
      expect(
        same.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.basic),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().mouseCursor, first.mouseCursor);
      expect(
        first
            .merge(
              ButtonStyle(
                mouseCursor: const StateProperty<MouseCursor?>.all(
                  SystemMouseCursors.basic,
                ),
              ),
            )
            .mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(
        const ButtonStyle().merge(first).mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
    });
    test('loadingIndicator copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        loadingIndicator: const StateProperty<Widget?>.all(_firstWidget),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        loadingIndicator: const StateProperty<Widget?>.all(_firstWidget),
      );
      final ButtonStyle changed = first.copyWith(
        loadingIndicator: const StateProperty<Widget?>.all(_secondWidget),
      );
      expect(
        same.loadingIndicator,
        const StateProperty<Widget?>.all(_firstWidget),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.loadingIndicator,
        const StateProperty<Widget?>.all(_secondWidget),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().loadingIndicator, first.loadingIndicator);
      expect(
        first
            .merge(
              ButtonStyle(
                loadingIndicator: const StateProperty<Widget?>.all(
                  _secondWidget,
                ),
              ),
            )
            .loadingIndicator,
        const StateProperty<Widget?>.all(_firstWidget),
      );
      expect(
        const ButtonStyle().merge(first).loadingIndicator,
        const StateProperty<Widget?>.all(_firstWidget),
      );
    });
    test('alignment copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(alignment: Alignment.topLeft);
      final ButtonStyle same = const ButtonStyle().copyWith(
        alignment: Alignment.topLeft,
      );
      final ButtonStyle changed = first.copyWith(
        alignment: Alignment.bottomRight,
      );
      expect(same.alignment, Alignment.topLeft);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.alignment, Alignment.bottomRight);
      expect(changed, isNot(first));
      expect(first.copyWith().alignment, first.alignment);
      expect(
        first.merge(ButtonStyle(alignment: Alignment.bottomRight)).alignment,
        Alignment.topLeft,
      );
      expect(const ButtonStyle().merge(first).alignment, Alignment.topLeft);
    });
    test('spacing copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(spacing: 5.0);
      final ButtonStyle same = const ButtonStyle().copyWith(spacing: 5.0);
      final ButtonStyle changed = first.copyWith(spacing: 9.0);
      expect(same.spacing, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.spacing, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().spacing, first.spacing);
      expect(first.merge(ButtonStyle(spacing: 9.0)).spacing, 5.0);
      expect(const ButtonStyle().merge(first).spacing, 5.0);
    });
    test('iconAlignment copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(iconAlignment: IconAlignment.start);
      final ButtonStyle same = const ButtonStyle().copyWith(
        iconAlignment: IconAlignment.start,
      );
      final ButtonStyle changed = first.copyWith(
        iconAlignment: IconAlignment.end,
      );
      expect(same.iconAlignment, IconAlignment.start);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.iconAlignment, IconAlignment.end);
      expect(changed, isNot(first));
      expect(first.copyWith().iconAlignment, first.iconAlignment);
      expect(
        first
            .merge(ButtonStyle(iconAlignment: IconAlignment.end))
            .iconAlignment,
        IconAlignment.start,
      );
      expect(
        const ButtonStyle().merge(first).iconAlignment,
        IconAlignment.start,
      );
    });
    test('tapTargetSize copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(tapTargetSize: const Size(10, 20));
      final ButtonStyle same = const ButtonStyle().copyWith(
        tapTargetSize: const Size(10, 20),
      );
      final ButtonStyle changed = first.copyWith(
        tapTargetSize: const Size(30, 40),
      );
      expect(same.tapTargetSize, const Size(10, 20));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.tapTargetSize, const Size(30, 40));
      expect(changed, isNot(first));
      expect(first.copyWith().tapTargetSize, first.tapTargetSize);
      expect(
        first
            .merge(ButtonStyle(tapTargetSize: const Size(30, 40)))
            .tapTargetSize,
        const Size(10, 20),
      );
      expect(
        const ButtonStyle().merge(first).tapTargetSize,
        const Size(10, 20),
      );
    });
    test('clipBehavior copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(clipBehavior: Clip.hardEdge);
      final ButtonStyle same = const ButtonStyle().copyWith(
        clipBehavior: Clip.hardEdge,
      );
      final ButtonStyle changed = first.copyWith(clipBehavior: Clip.antiAlias);
      expect(same.clipBehavior, Clip.hardEdge);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.clipBehavior, Clip.antiAlias);
      expect(changed, isNot(first));
      expect(first.copyWith().clipBehavior, first.clipBehavior);
      expect(
        first.merge(ButtonStyle(clipBehavior: Clip.antiAlias)).clipBehavior,
        Clip.hardEdge,
      );
      expect(const ButtonStyle().merge(first).clipBehavior, Clip.hardEdge);
    });
    test('animationDuration copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ButtonStyle same = const ButtonStyle().copyWith(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ButtonStyle changed = first.copyWith(
        animationDuration: const Duration(milliseconds: 300),
      );
      expect(same.animationDuration, const Duration(milliseconds: 100));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationDuration, const Duration(milliseconds: 300));
      expect(changed, isNot(first));
      expect(first.copyWith().animationDuration, first.animationDuration);
      expect(
        first
            .merge(
              ButtonStyle(animationDuration: const Duration(milliseconds: 300)),
            )
            .animationDuration,
        const Duration(milliseconds: 100),
      );
      expect(
        const ButtonStyle().merge(first).animationDuration,
        const Duration(milliseconds: 100),
      );
    });
    test('animationCurve copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(animationCurve: Curves.linear);
      final ButtonStyle same = const ButtonStyle().copyWith(
        animationCurve: Curves.linear,
      );
      final ButtonStyle changed = first.copyWith(
        animationCurve: Curves.easeInOut,
      );
      expect(same.animationCurve, Curves.linear);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationCurve, Curves.easeInOut);
      expect(changed, isNot(first));
      expect(first.copyWith().animationCurve, first.animationCurve);
      expect(
        first
            .merge(ButtonStyle(animationCurve: Curves.easeInOut))
            .animationCurve,
        Curves.linear,
      );
      expect(const ButtonStyle().merge(first).animationCurve, Curves.linear);
    });
    test('enableFeedback copies and participates in value equality', () {
      final ButtonStyle first = ButtonStyle(enableFeedback: false);
      final ButtonStyle same = const ButtonStyle().copyWith(
        enableFeedback: false,
      );
      final ButtonStyle changed = first.copyWith(enableFeedback: true);
      expect(same.enableFeedback, false);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.enableFeedback, true);
      expect(changed, isNot(first));
      expect(first.copyWith().enableFeedback, first.enableFeedback);
      expect(
        first.merge(ButtonStyle(enableFeedback: true)).enableFeedback,
        false,
      );
      expect(const ButtonStyle().merge(first).enableFeedback, false);
    });
    test('all tokens copy and merge together', () {
      final ButtonStyle full = ButtonStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        padding: const StateProperty<EdgeInsetsGeometry?>.all(
          EdgeInsets.all(5),
        ),
        minimumSize: const StateProperty<Size?>.all(Size(10, 20)),
        fixedSize: const StateProperty<Size?>.all(Size(10, 20)),
        maximumSize: const StateProperty<Size?>.all(Size(10, 20)),
        textStyle: const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
        loadingIndicator: const StateProperty<Widget?>.all(_firstWidget),
        alignment: Alignment.topLeft,
        spacing: 5.0,
        iconAlignment: IconAlignment.start,
        tapTargetSize: const Size(10, 20),
        clipBehavior: Clip.hardEdge,
        animationDuration: const Duration(milliseconds: 100),
        animationCurve: Curves.linear,
        enableFeedback: false,
      );
      expect(
        const ButtonStyle().copyWith(
          decoration: full.decoration,
          foregroundDecoration: full.foregroundDecoration,
          padding: full.padding,
          minimumSize: full.minimumSize,
          fixedSize: full.fixedSize,
          maximumSize: full.maximumSize,
          textStyle: full.textStyle,
          iconTheme: full.iconTheme,
          mouseCursor: full.mouseCursor,
          loadingIndicator: full.loadingIndicator,
          alignment: full.alignment,
          spacing: full.spacing,
          iconAlignment: full.iconAlignment,
          tapTargetSize: full.tapTargetSize,
          clipBehavior: full.clipBehavior,
          animationDuration: full.animationDuration,
          animationCurve: full.animationCurve,
          enableFeedback: full.enableFeedback,
        ),
        full,
      );
      expect(const ButtonStyle().merge(full), full);
      expect(full.merge(const ButtonStyle()), full);
      expect(identical(full.merge(null), full), isTrue);
      expect(full.toString(), contains('ButtonStyle('));
    });
  });
  group('ToggleStyle', () {
    test('size copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        size: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        size: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ToggleStyle changed = first.copyWith(
        size: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.size, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.size, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().size, first.size);
      expect(
        first
            .merge(
              ToggleStyle(size: const StateProperty<Size?>.all(Size(30, 40))),
            )
            .size,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const ToggleStyle().merge(first).size,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('decoration copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ToggleStyle changed = first.copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().decoration, first.decoration);
      expect(
        first
            .merge(
              ToggleStyle(
                decoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ToggleStyle().merge(first).decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('thumbSize copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final ToggleStyle changed = first.copyWith(
        thumbSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.thumbSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.thumbSize, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().thumbSize, first.thumbSize);
      expect(
        first
            .merge(
              ToggleStyle(
                thumbSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .thumbSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const ToggleStyle().merge(first).thumbSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('thumbDecoration copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ToggleStyle changed = first.copyWith(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().thumbDecoration, first.thumbDecoration);
      expect(
        first
            .merge(
              ToggleStyle(
                thumbDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ToggleStyle().merge(first).thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('indicator copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        indicator: const StateProperty<Widget?>.all(_firstWidget),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        indicator: const StateProperty<Widget?>.all(_firstWidget),
      );
      final ToggleStyle changed = first.copyWith(
        indicator: const StateProperty<Widget?>.all(_secondWidget),
      );
      expect(same.indicator, const StateProperty<Widget?>.all(_firstWidget));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.indicator,
        const StateProperty<Widget?>.all(_secondWidget),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().indicator, first.indicator);
      expect(
        first
            .merge(
              ToggleStyle(
                indicator: const StateProperty<Widget?>.all(_secondWidget),
              ),
            )
            .indicator,
        const StateProperty<Widget?>.all(_firstWidget),
      );
      expect(
        const ToggleStyle().merge(first).indicator,
        const StateProperty<Widget?>.all(_firstWidget),
      );
    });
    test(
      'indeterminateIndicator copies and participates in value equality',
      () {
        final ToggleStyle first = ToggleStyle(
          indeterminateIndicator: const StateProperty<Widget?>.all(
            _firstWidget,
          ),
        );
        final ToggleStyle same = const ToggleStyle().copyWith(
          indeterminateIndicator: const StateProperty<Widget?>.all(
            _firstWidget,
          ),
        );
        final ToggleStyle changed = first.copyWith(
          indeterminateIndicator: const StateProperty<Widget?>.all(
            _secondWidget,
          ),
        );
        expect(
          same.indeterminateIndicator,
          const StateProperty<Widget?>.all(_firstWidget),
        );
        expect(same, first);
        expect(same.hashCode, first.hashCode);
        expect(
          changed.indeterminateIndicator,
          const StateProperty<Widget?>.all(_secondWidget),
        );
        expect(changed, isNot(first));
        expect(
          first.copyWith().indeterminateIndicator,
          first.indeterminateIndicator,
        );
        expect(
          first
              .merge(
                ToggleStyle(
                  indeterminateIndicator: const StateProperty<Widget?>.all(
                    _secondWidget,
                  ),
                ),
              )
              .indeterminateIndicator,
          const StateProperty<Widget?>.all(_firstWidget),
        );
        expect(
          const ToggleStyle().merge(first).indeterminateIndicator,
          const StateProperty<Widget?>.all(_firstWidget),
        );
      },
    );
    test('padding copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(padding: const EdgeInsets.all(5));
      final ToggleStyle same = const ToggleStyle().copyWith(
        padding: const EdgeInsets.all(5),
      );
      final ToggleStyle changed = first.copyWith(
        padding: const EdgeInsets.all(9),
      );
      expect(same.padding, const EdgeInsets.all(5));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.padding, const EdgeInsets.all(9));
      expect(changed, isNot(first));
      expect(first.copyWith().padding, first.padding);
      expect(
        first.merge(ToggleStyle(padding: const EdgeInsets.all(9))).padding,
        const EdgeInsets.all(5),
      );
      expect(const ToggleStyle().merge(first).padding, const EdgeInsets.all(5));
    });
    test('tapTargetSize copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(tapTargetSize: const Size(10, 20));
      final ToggleStyle same = const ToggleStyle().copyWith(
        tapTargetSize: const Size(10, 20),
      );
      final ToggleStyle changed = first.copyWith(
        tapTargetSize: const Size(30, 40),
      );
      expect(same.tapTargetSize, const Size(10, 20));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.tapTargetSize, const Size(30, 40));
      expect(changed, isNot(first));
      expect(first.copyWith().tapTargetSize, first.tapTargetSize);
      expect(
        first
            .merge(ToggleStyle(tapTargetSize: const Size(30, 40)))
            .tapTargetSize,
        const Size(10, 20),
      );
      expect(
        const ToggleStyle().merge(first).tapTargetSize,
        const Size(10, 20),
      );
    });
    test('mouseCursor copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ToggleStyle changed = first.copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.basic,
        ),
      );
      expect(
        same.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.basic),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().mouseCursor, first.mouseCursor);
      expect(
        first
            .merge(
              ToggleStyle(
                mouseCursor: const StateProperty<MouseCursor?>.all(
                  SystemMouseCursors.basic,
                ),
              ),
            )
            .mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(
        const ToggleStyle().merge(first).mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
    });
    test('animationDuration copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ToggleStyle same = const ToggleStyle().copyWith(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ToggleStyle changed = first.copyWith(
        animationDuration: const Duration(milliseconds: 300),
      );
      expect(same.animationDuration, const Duration(milliseconds: 100));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationDuration, const Duration(milliseconds: 300));
      expect(changed, isNot(first));
      expect(first.copyWith().animationDuration, first.animationDuration);
      expect(
        first
            .merge(
              ToggleStyle(animationDuration: const Duration(milliseconds: 300)),
            )
            .animationDuration,
        const Duration(milliseconds: 100),
      );
      expect(
        const ToggleStyle().merge(first).animationDuration,
        const Duration(milliseconds: 100),
      );
    });
    test('animationCurve copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(animationCurve: Curves.linear);
      final ToggleStyle same = const ToggleStyle().copyWith(
        animationCurve: Curves.linear,
      );
      final ToggleStyle changed = first.copyWith(
        animationCurve: Curves.easeInOut,
      );
      expect(same.animationCurve, Curves.linear);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationCurve, Curves.easeInOut);
      expect(changed, isNot(first));
      expect(first.copyWith().animationCurve, first.animationCurve);
      expect(
        first
            .merge(ToggleStyle(animationCurve: Curves.easeInOut))
            .animationCurve,
        Curves.linear,
      );
      expect(const ToggleStyle().merge(first).animationCurve, Curves.linear);
    });
    test('enableFeedback copies and participates in value equality', () {
      final ToggleStyle first = ToggleStyle(enableFeedback: false);
      final ToggleStyle same = const ToggleStyle().copyWith(
        enableFeedback: false,
      );
      final ToggleStyle changed = first.copyWith(enableFeedback: true);
      expect(same.enableFeedback, false);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.enableFeedback, true);
      expect(changed, isNot(first));
      expect(first.copyWith().enableFeedback, first.enableFeedback);
      expect(
        first.merge(ToggleStyle(enableFeedback: true)).enableFeedback,
        false,
      );
      expect(const ToggleStyle().merge(first).enableFeedback, false);
    });
    test('all tokens copy and merge together', () {
      final ToggleStyle full = ToggleStyle(
        size: const StateProperty<Size?>.all(Size(10, 20)),
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        indicator: const StateProperty<Widget?>.all(_firstWidget),
        indeterminateIndicator: const StateProperty<Widget?>.all(_firstWidget),
        padding: const EdgeInsets.all(5),
        tapTargetSize: const Size(10, 20),
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
        animationDuration: const Duration(milliseconds: 100),
        animationCurve: Curves.linear,
        enableFeedback: false,
      );
      expect(
        const ToggleStyle().copyWith(
          size: full.size,
          decoration: full.decoration,
          thumbSize: full.thumbSize,
          thumbDecoration: full.thumbDecoration,
          indicator: full.indicator,
          indeterminateIndicator: full.indeterminateIndicator,
          padding: full.padding,
          tapTargetSize: full.tapTargetSize,
          mouseCursor: full.mouseCursor,
          animationDuration: full.animationDuration,
          animationCurve: full.animationCurve,
          enableFeedback: full.enableFeedback,
        ),
        full,
      );
      expect(const ToggleStyle().merge(full), full);
      expect(full.merge(const ToggleStyle()), full);
      expect(identical(full.merge(null), full), isTrue);
      expect(full.toString(), contains('ToggleStyle('));
    });
  });
  group('ListTileStyle', () {
    test('decoration copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ListTileStyle changed = first.copyWith(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().decoration, first.decoration);
      expect(
        first
            .merge(
              ListTileStyle(
                decoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ListTileStyle().merge(first).decoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('foregroundDecoration copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final ListTileStyle changed = first.copyWith(
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().foregroundDecoration, first.foregroundDecoration);
      expect(
        first
            .merge(
              ListTileStyle(
                foregroundDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const ListTileStyle().merge(first).foregroundDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('titleTextStyle copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        titleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        titleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
      );
      final ListTileStyle changed = first.copyWith(
        titleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 20),
        ),
      );
      expect(
        same.titleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.titleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 20)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().titleTextStyle, first.titleTextStyle);
      expect(
        first
            .merge(
              ListTileStyle(
                titleTextStyle: const StateProperty<TextStyle?>.all(
                  TextStyle(fontSize: 20),
                ),
              ),
            )
            .titleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(
        const ListTileStyle().merge(first).titleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
    });
    test('subtitleTextStyle copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        subtitleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        subtitleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
      );
      final ListTileStyle changed = first.copyWith(
        subtitleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 20),
        ),
      );
      expect(
        same.subtitleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.subtitleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 20)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().subtitleTextStyle, first.subtitleTextStyle);
      expect(
        first
            .merge(
              ListTileStyle(
                subtitleTextStyle: const StateProperty<TextStyle?>.all(
                  TextStyle(fontSize: 20),
                ),
              ),
            )
            .subtitleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
      expect(
        const ListTileStyle().merge(first).subtitleTextStyle,
        const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
      );
    });
    test(
      'leadingAndTrailingTextStyle copies and participates in value equality',
      () {
        final ListTileStyle first = ListTileStyle(
          leadingAndTrailingTextStyle: const StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 10),
          ),
        );
        final ListTileStyle same = const ListTileStyle().copyWith(
          leadingAndTrailingTextStyle: const StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 10),
          ),
        );
        final ListTileStyle changed = first.copyWith(
          leadingAndTrailingTextStyle: const StateProperty<TextStyle?>.all(
            TextStyle(fontSize: 20),
          ),
        );
        expect(
          same.leadingAndTrailingTextStyle,
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
        );
        expect(same, first);
        expect(same.hashCode, first.hashCode);
        expect(
          changed.leadingAndTrailingTextStyle,
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 20)),
        );
        expect(changed, isNot(first));
        expect(
          first.copyWith().leadingAndTrailingTextStyle,
          first.leadingAndTrailingTextStyle,
        );
        expect(
          first
              .merge(
                ListTileStyle(
                  leadingAndTrailingTextStyle:
                      const StateProperty<TextStyle?>.all(
                        TextStyle(fontSize: 20),
                      ),
                ),
              )
              .leadingAndTrailingTextStyle,
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
        );
        expect(
          const ListTileStyle().merge(first).leadingAndTrailingTextStyle,
          const StateProperty<TextStyle?>.all(TextStyle(fontSize: 10)),
        );
      },
    );
    test('iconTheme copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
      );
      final ListTileStyle changed = first.copyWith(
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 20),
        ),
      );
      expect(
        same.iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 20)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().iconTheme, first.iconTheme);
      expect(
        first
            .merge(
              ListTileStyle(
                iconTheme: const StateProperty<IconThemeData?>.all(
                  IconThemeData(size: 20),
                ),
              ),
            )
            .iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
      expect(
        const ListTileStyle().merge(first).iconTheme,
        const StateProperty<IconThemeData?>.all(IconThemeData(size: 10)),
      );
    });
    test('mouseCursor copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final ListTileStyle changed = first.copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.basic,
        ),
      );
      expect(
        same.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.basic),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().mouseCursor, first.mouseCursor);
      expect(
        first
            .merge(
              ListTileStyle(
                mouseCursor: const StateProperty<MouseCursor?>.all(
                  SystemMouseCursors.basic,
                ),
              ),
            )
            .mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(
        const ListTileStyle().merge(first).mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
    });
    test('contentPadding copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        contentPadding: const EdgeInsets.all(5),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        contentPadding: const EdgeInsets.all(5),
      );
      final ListTileStyle changed = first.copyWith(
        contentPadding: const EdgeInsets.all(9),
      );
      expect(same.contentPadding, const EdgeInsets.all(5));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.contentPadding, const EdgeInsets.all(9));
      expect(changed, isNot(first));
      expect(first.copyWith().contentPadding, first.contentPadding);
      expect(
        first
            .merge(ListTileStyle(contentPadding: const EdgeInsets.all(9)))
            .contentPadding,
        const EdgeInsets.all(5),
      );
      expect(
        const ListTileStyle().merge(first).contentPadding,
        const EdgeInsets.all(5),
      );
    });
    test('minVerticalPadding copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(minVerticalPadding: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        minVerticalPadding: 5.0,
      );
      final ListTileStyle changed = first.copyWith(minVerticalPadding: 9.0);
      expect(same.minVerticalPadding, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.minVerticalPadding, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().minVerticalPadding, first.minVerticalPadding);
      expect(
        first.merge(ListTileStyle(minVerticalPadding: 9.0)).minVerticalPadding,
        5.0,
      );
      expect(const ListTileStyle().merge(first).minVerticalPadding, 5.0);
    });
    test('horizontalTitleGap copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(horizontalTitleGap: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        horizontalTitleGap: 5.0,
      );
      final ListTileStyle changed = first.copyWith(horizontalTitleGap: 9.0);
      expect(same.horizontalTitleGap, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.horizontalTitleGap, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().horizontalTitleGap, first.horizontalTitleGap);
      expect(
        first.merge(ListTileStyle(horizontalTitleGap: 9.0)).horizontalTitleGap,
        5.0,
      );
      expect(const ListTileStyle().merge(first).horizontalTitleGap, 5.0);
    });
    test('minLeadingWidth copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(minLeadingWidth: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        minLeadingWidth: 5.0,
      );
      final ListTileStyle changed = first.copyWith(minLeadingWidth: 9.0);
      expect(same.minLeadingWidth, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.minLeadingWidth, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().minLeadingWidth, first.minLeadingWidth);
      expect(
        first.merge(ListTileStyle(minLeadingWidth: 9.0)).minLeadingWidth,
        5.0,
      );
      expect(const ListTileStyle().merge(first).minLeadingWidth, 5.0);
    });
    test('subtitleSpacing copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(subtitleSpacing: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        subtitleSpacing: 5.0,
      );
      final ListTileStyle changed = first.copyWith(subtitleSpacing: 9.0);
      expect(same.subtitleSpacing, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.subtitleSpacing, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().subtitleSpacing, first.subtitleSpacing);
      expect(
        first.merge(ListTileStyle(subtitleSpacing: 9.0)).subtitleSpacing,
        5.0,
      );
      expect(const ListTileStyle().merge(first).subtitleSpacing, 5.0);
    });
    test('minTileHeight copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(minTileHeight: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        minTileHeight: 5.0,
      );
      final ListTileStyle changed = first.copyWith(minTileHeight: 9.0);
      expect(same.minTileHeight, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.minTileHeight, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().minTileHeight, first.minTileHeight);
      expect(first.merge(ListTileStyle(minTileHeight: 9.0)).minTileHeight, 5.0);
      expect(const ListTileStyle().merge(first).minTileHeight, 5.0);
    });
    test('minTwoLineTileHeight copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(minTwoLineTileHeight: 5.0);
      final ListTileStyle same = const ListTileStyle().copyWith(
        minTwoLineTileHeight: 5.0,
      );
      final ListTileStyle changed = first.copyWith(minTwoLineTileHeight: 9.0);
      expect(same.minTwoLineTileHeight, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.minTwoLineTileHeight, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().minTwoLineTileHeight, first.minTwoLineTileHeight);
      expect(
        first
            .merge(ListTileStyle(minTwoLineTileHeight: 9.0))
            .minTwoLineTileHeight,
        5.0,
      );
      expect(const ListTileStyle().merge(first).minTwoLineTileHeight, 5.0);
    });
    test(
      'minThreeLineTileHeight copies and participates in value equality',
      () {
        final ListTileStyle first = ListTileStyle(minThreeLineTileHeight: 5.0);
        final ListTileStyle same = const ListTileStyle().copyWith(
          minThreeLineTileHeight: 5.0,
        );
        final ListTileStyle changed = first.copyWith(
          minThreeLineTileHeight: 9.0,
        );
        expect(same.minThreeLineTileHeight, 5.0);
        expect(same, first);
        expect(same.hashCode, first.hashCode);
        expect(changed.minThreeLineTileHeight, 9.0);
        expect(changed, isNot(first));
        expect(
          first.copyWith().minThreeLineTileHeight,
          first.minThreeLineTileHeight,
        );
        expect(
          first
              .merge(ListTileStyle(minThreeLineTileHeight: 9.0))
              .minThreeLineTileHeight,
          5.0,
        );
        expect(const ListTileStyle().merge(first).minThreeLineTileHeight, 5.0);
      },
    );
    test('titleAlignment copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        titleAlignment: ListTileTitleAlignment.top,
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        titleAlignment: ListTileTitleAlignment.top,
      );
      final ListTileStyle changed = first.copyWith(
        titleAlignment: ListTileTitleAlignment.bottom,
      );
      expect(same.titleAlignment, ListTileTitleAlignment.top);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.titleAlignment, ListTileTitleAlignment.bottom);
      expect(changed, isNot(first));
      expect(first.copyWith().titleAlignment, first.titleAlignment);
      expect(
        first
            .merge(ListTileStyle(titleAlignment: ListTileTitleAlignment.bottom))
            .titleAlignment,
        ListTileTitleAlignment.top,
      );
      expect(
        const ListTileStyle().merge(first).titleAlignment,
        ListTileTitleAlignment.top,
      );
    });
    test('animationDuration copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ListTileStyle same = const ListTileStyle().copyWith(
        animationDuration: const Duration(milliseconds: 100),
      );
      final ListTileStyle changed = first.copyWith(
        animationDuration: const Duration(milliseconds: 300),
      );
      expect(same.animationDuration, const Duration(milliseconds: 100));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationDuration, const Duration(milliseconds: 300));
      expect(changed, isNot(first));
      expect(first.copyWith().animationDuration, first.animationDuration);
      expect(
        first
            .merge(
              ListTileStyle(
                animationDuration: const Duration(milliseconds: 300),
              ),
            )
            .animationDuration,
        const Duration(milliseconds: 100),
      );
      expect(
        const ListTileStyle().merge(first).animationDuration,
        const Duration(milliseconds: 100),
      );
    });
    test('animationCurve copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(animationCurve: Curves.linear);
      final ListTileStyle same = const ListTileStyle().copyWith(
        animationCurve: Curves.linear,
      );
      final ListTileStyle changed = first.copyWith(
        animationCurve: Curves.easeInOut,
      );
      expect(same.animationCurve, Curves.linear);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationCurve, Curves.easeInOut);
      expect(changed, isNot(first));
      expect(first.copyWith().animationCurve, first.animationCurve);
      expect(
        first
            .merge(ListTileStyle(animationCurve: Curves.easeInOut))
            .animationCurve,
        Curves.linear,
      );
      expect(const ListTileStyle().merge(first).animationCurve, Curves.linear);
    });
    test('enableFeedback copies and participates in value equality', () {
      final ListTileStyle first = ListTileStyle(enableFeedback: false);
      final ListTileStyle same = const ListTileStyle().copyWith(
        enableFeedback: false,
      );
      final ListTileStyle changed = first.copyWith(enableFeedback: true);
      expect(same.enableFeedback, false);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.enableFeedback, true);
      expect(changed, isNot(first));
      expect(first.copyWith().enableFeedback, first.enableFeedback);
      expect(
        first.merge(ListTileStyle(enableFeedback: true)).enableFeedback,
        false,
      );
      expect(const ListTileStyle().merge(first).enableFeedback, false);
    });
    test('all tokens copy and merge together', () {
      final ListTileStyle full = ListTileStyle(
        decoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        foregroundDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        titleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
        subtitleTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
        leadingAndTrailingTextStyle: const StateProperty<TextStyle?>.all(
          TextStyle(fontSize: 10),
        ),
        iconTheme: const StateProperty<IconThemeData?>.all(
          IconThemeData(size: 10),
        ),
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
        contentPadding: const EdgeInsets.all(5),
        minVerticalPadding: 5.0,
        horizontalTitleGap: 5.0,
        minLeadingWidth: 5.0,
        subtitleSpacing: 5.0,
        minTileHeight: 5.0,
        minTwoLineTileHeight: 5.0,
        minThreeLineTileHeight: 5.0,
        titleAlignment: ListTileTitleAlignment.top,
        animationDuration: const Duration(milliseconds: 100),
        animationCurve: Curves.linear,
        enableFeedback: false,
      );
      expect(
        const ListTileStyle().copyWith(
          decoration: full.decoration,
          foregroundDecoration: full.foregroundDecoration,
          titleTextStyle: full.titleTextStyle,
          subtitleTextStyle: full.subtitleTextStyle,
          leadingAndTrailingTextStyle: full.leadingAndTrailingTextStyle,
          iconTheme: full.iconTheme,
          mouseCursor: full.mouseCursor,
          contentPadding: full.contentPadding,
          minVerticalPadding: full.minVerticalPadding,
          horizontalTitleGap: full.horizontalTitleGap,
          minLeadingWidth: full.minLeadingWidth,
          subtitleSpacing: full.subtitleSpacing,
          minTileHeight: full.minTileHeight,
          minTwoLineTileHeight: full.minTwoLineTileHeight,
          minThreeLineTileHeight: full.minThreeLineTileHeight,
          titleAlignment: full.titleAlignment,
          animationDuration: full.animationDuration,
          animationCurve: full.animationCurve,
          enableFeedback: full.enableFeedback,
        ),
        full,
      );
      expect(const ListTileStyle().merge(full), full);
      expect(full.merge(const ListTileStyle()), full);
      expect(identical(full.merge(null), full), isTrue);
      expect(full.toString(), contains('ListTileStyle('));
    });
  });
  group('SliderStyle', () {
    test('trackHeight copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        trackHeight: const StateProperty<double?>.all(5),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        trackHeight: const StateProperty<double?>.all(5),
      );
      final SliderStyle changed = first.copyWith(
        trackHeight: const StateProperty<double?>.all(9),
      );
      expect(same.trackHeight, const StateProperty<double?>.all(5));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.trackHeight, const StateProperty<double?>.all(9));
      expect(changed, isNot(first));
      expect(first.copyWith().trackHeight, first.trackHeight);
      expect(
        first
            .merge(
              SliderStyle(trackHeight: const StateProperty<double?>.all(9)),
            )
            .trackHeight,
        const StateProperty<double?>.all(5),
      );
      expect(
        const SliderStyle().merge(first).trackHeight,
        const StateProperty<double?>.all(5),
      );
    });
    test('trackDecoration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        trackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        trackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle changed = first.copyWith(
        trackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.trackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.trackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().trackDecoration, first.trackDecoration);
      expect(
        first
            .merge(
              SliderStyle(
                trackDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .trackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const SliderStyle().merge(first).trackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('activeTrackDecoration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        activeTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        activeTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle changed = first.copyWith(
        activeTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.activeTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.activeTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(
        first.copyWith().activeTrackDecoration,
        first.activeTrackDecoration,
      );
      expect(
        first
            .merge(
              SliderStyle(
                activeTrackDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .activeTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const SliderStyle().merge(first).activeTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('secondaryActiveTrackDecoration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        secondaryActiveTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        secondaryActiveTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle changed = first.copyWith(
        secondaryActiveTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.secondaryActiveTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.secondaryActiveTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(
        first.copyWith().secondaryActiveTrackDecoration,
        first.secondaryActiveTrackDecoration,
      );
      expect(
        first
            .merge(
              SliderStyle(
                secondaryActiveTrackDecoration:
                    const StateProperty<Decoration?>.all(
                      BoxDecoration(color: Color(0xFF445566)),
                    ),
              ),
            )
            .secondaryActiveTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const SliderStyle().merge(first).secondaryActiveTrackDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('thumbSize copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final SliderStyle changed = first.copyWith(
        thumbSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.thumbSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.thumbSize, const StateProperty<Size?>.all(Size(30, 40)));
      expect(changed, isNot(first));
      expect(first.copyWith().thumbSize, first.thumbSize);
      expect(
        first
            .merge(
              SliderStyle(
                thumbSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .thumbSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const SliderStyle().merge(first).thumbSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('thumbDecoration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle changed = first.copyWith(
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().thumbDecoration, first.thumbDecoration);
      expect(
        first
            .merge(
              SliderStyle(
                thumbDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const SliderStyle().merge(first).thumbDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test('tickMarkSize copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        tickMarkSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        tickMarkSize: const StateProperty<Size?>.all(Size(10, 20)),
      );
      final SliderStyle changed = first.copyWith(
        tickMarkSize: const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(same.tickMarkSize, const StateProperty<Size?>.all(Size(10, 20)));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.tickMarkSize,
        const StateProperty<Size?>.all(Size(30, 40)),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().tickMarkSize, first.tickMarkSize);
      expect(
        first
            .merge(
              SliderStyle(
                tickMarkSize: const StateProperty<Size?>.all(Size(30, 40)),
              ),
            )
            .tickMarkSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
      expect(
        const SliderStyle().merge(first).tickMarkSize,
        const StateProperty<Size?>.all(Size(10, 20)),
      );
    });
    test('tickMarkDecoration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        tickMarkDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        tickMarkDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      final SliderStyle changed = first.copyWith(
        tickMarkDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(
        same.tickMarkDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.tickMarkDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF445566)),
        ),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().tickMarkDecoration, first.tickMarkDecoration);
      expect(
        first
            .merge(
              SliderStyle(
                tickMarkDecoration: const StateProperty<Decoration?>.all(
                  BoxDecoration(color: Color(0xFF445566)),
                ),
              ),
            )
            .tickMarkDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
      expect(
        const SliderStyle().merge(first).tickMarkDecoration,
        const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
      );
    });
    test(
      'activeTickMarkDecoration copies and participates in value equality',
      () {
        final SliderStyle first = SliderStyle(
          activeTickMarkDecoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        );
        final SliderStyle same = const SliderStyle().copyWith(
          activeTickMarkDecoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        );
        final SliderStyle changed = first.copyWith(
          activeTickMarkDecoration: const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF445566)),
          ),
        );
        expect(
          same.activeTickMarkDecoration,
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        );
        expect(same, first);
        expect(same.hashCode, first.hashCode);
        expect(
          changed.activeTickMarkDecoration,
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF445566)),
          ),
        );
        expect(changed, isNot(first));
        expect(
          first.copyWith().activeTickMarkDecoration,
          first.activeTickMarkDecoration,
        );
        expect(
          first
              .merge(
                SliderStyle(
                  activeTickMarkDecoration:
                      const StateProperty<Decoration?>.all(
                        BoxDecoration(color: Color(0xFF445566)),
                      ),
                ),
              )
              .activeTickMarkDecoration,
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        );
        expect(
          const SliderStyle().merge(first).activeTickMarkDecoration,
          const StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xFF112233)),
          ),
        );
      },
    );
    test('mouseCursor copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
      );
      final SliderStyle changed = first.copyWith(
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.basic,
        ),
      );
      expect(
        same.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(
        changed.mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.basic),
      );
      expect(changed, isNot(first));
      expect(first.copyWith().mouseCursor, first.mouseCursor);
      expect(
        first
            .merge(
              SliderStyle(
                mouseCursor: const StateProperty<MouseCursor?>.all(
                  SystemMouseCursors.basic,
                ),
              ),
            )
            .mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
      expect(
        const SliderStyle().merge(first).mouseCursor,
        const StateProperty<MouseCursor?>.all(SystemMouseCursors.click),
      );
    });
    test('valueIndicatorBuilder copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        valueIndicatorBuilder: _firstIndicator,
      );
      final SliderStyle same = const SliderStyle().copyWith(
        valueIndicatorBuilder: _firstIndicator,
      );
      final SliderStyle changed = first.copyWith(
        valueIndicatorBuilder: _secondIndicator,
      );
      expect(same.valueIndicatorBuilder, _firstIndicator);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.valueIndicatorBuilder, _secondIndicator);
      expect(changed, isNot(first));
      expect(
        first.copyWith().valueIndicatorBuilder,
        first.valueIndicatorBuilder,
      );
      expect(
        first
            .merge(SliderStyle(valueIndicatorBuilder: _secondIndicator))
            .valueIndicatorBuilder,
        _firstIndicator,
      );
      expect(
        const SliderStyle().merge(first).valueIndicatorBuilder,
        _firstIndicator,
      );
    });
    test('padding copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(padding: const EdgeInsets.all(5));
      final SliderStyle same = const SliderStyle().copyWith(
        padding: const EdgeInsets.all(5),
      );
      final SliderStyle changed = first.copyWith(
        padding: const EdgeInsets.all(9),
      );
      expect(same.padding, const EdgeInsets.all(5));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.padding, const EdgeInsets.all(9));
      expect(changed, isNot(first));
      expect(first.copyWith().padding, first.padding);
      expect(
        first.merge(SliderStyle(padding: const EdgeInsets.all(9))).padding,
        const EdgeInsets.all(5),
      );
      expect(const SliderStyle().merge(first).padding, const EdgeInsets.all(5));
    });
    test('tapTargetSize copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(tapTargetSize: const Size(10, 20));
      final SliderStyle same = const SliderStyle().copyWith(
        tapTargetSize: const Size(10, 20),
      );
      final SliderStyle changed = first.copyWith(
        tapTargetSize: const Size(30, 40),
      );
      expect(same.tapTargetSize, const Size(10, 20));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.tapTargetSize, const Size(30, 40));
      expect(changed, isNot(first));
      expect(first.copyWith().tapTargetSize, first.tapTargetSize);
      expect(
        first
            .merge(SliderStyle(tapTargetSize: const Size(30, 40)))
            .tapTargetSize,
        const Size(10, 20),
      );
      expect(
        const SliderStyle().merge(first).tapTargetSize,
        const Size(10, 20),
      );
    });
    test('preferredWidth copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(preferredWidth: 5.0);
      final SliderStyle same = const SliderStyle().copyWith(
        preferredWidth: 5.0,
      );
      final SliderStyle changed = first.copyWith(preferredWidth: 9.0);
      expect(same.preferredWidth, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.preferredWidth, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().preferredWidth, first.preferredWidth);
      expect(first.merge(SliderStyle(preferredWidth: 9.0)).preferredWidth, 5.0);
      expect(const SliderStyle().merge(first).preferredWidth, 5.0);
    });
    test('keyboardStep copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(keyboardStep: 5.0);
      final SliderStyle same = const SliderStyle().copyWith(keyboardStep: 5.0);
      final SliderStyle changed = first.copyWith(keyboardStep: 9.0);
      expect(same.keyboardStep, 5.0);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.keyboardStep, 9.0);
      expect(changed, isNot(first));
      expect(first.copyWith().keyboardStep, first.keyboardStep);
      expect(first.merge(SliderStyle(keyboardStep: 9.0)).keyboardStep, 5.0);
      expect(const SliderStyle().merge(first).keyboardStep, 5.0);
    });
    test('allowedInteraction copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        allowedInteraction: SliderInteraction.tapOnly,
      );
      final SliderStyle same = const SliderStyle().copyWith(
        allowedInteraction: SliderInteraction.tapOnly,
      );
      final SliderStyle changed = first.copyWith(
        allowedInteraction: SliderInteraction.slideOnly,
      );
      expect(same.allowedInteraction, SliderInteraction.tapOnly);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.allowedInteraction, SliderInteraction.slideOnly);
      expect(changed, isNot(first));
      expect(first.copyWith().allowedInteraction, first.allowedInteraction);
      expect(
        first
            .merge(SliderStyle(allowedInteraction: SliderInteraction.slideOnly))
            .allowedInteraction,
        SliderInteraction.tapOnly,
      );
      expect(
        const SliderStyle().merge(first).allowedInteraction,
        SliderInteraction.tapOnly,
      );
    });
    test('animationDuration copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(
        animationDuration: const Duration(milliseconds: 100),
      );
      final SliderStyle same = const SliderStyle().copyWith(
        animationDuration: const Duration(milliseconds: 100),
      );
      final SliderStyle changed = first.copyWith(
        animationDuration: const Duration(milliseconds: 300),
      );
      expect(same.animationDuration, const Duration(milliseconds: 100));
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationDuration, const Duration(milliseconds: 300));
      expect(changed, isNot(first));
      expect(first.copyWith().animationDuration, first.animationDuration);
      expect(
        first
            .merge(
              SliderStyle(animationDuration: const Duration(milliseconds: 300)),
            )
            .animationDuration,
        const Duration(milliseconds: 100),
      );
      expect(
        const SliderStyle().merge(first).animationDuration,
        const Duration(milliseconds: 100),
      );
    });
    test('animationCurve copies and participates in value equality', () {
      final SliderStyle first = SliderStyle(animationCurve: Curves.linear);
      final SliderStyle same = const SliderStyle().copyWith(
        animationCurve: Curves.linear,
      );
      final SliderStyle changed = first.copyWith(
        animationCurve: Curves.easeInOut,
      );
      expect(same.animationCurve, Curves.linear);
      expect(same, first);
      expect(same.hashCode, first.hashCode);
      expect(changed.animationCurve, Curves.easeInOut);
      expect(changed, isNot(first));
      expect(first.copyWith().animationCurve, first.animationCurve);
      expect(
        first
            .merge(SliderStyle(animationCurve: Curves.easeInOut))
            .animationCurve,
        Curves.linear,
      );
      expect(const SliderStyle().merge(first).animationCurve, Curves.linear);
    });
    test('all tokens copy and merge together', () {
      final SliderStyle full = SliderStyle(
        trackHeight: const StateProperty<double?>.all(5),
        trackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        activeTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        secondaryActiveTrackDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        thumbSize: const StateProperty<Size?>.all(Size(10, 20)),
        thumbDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        tickMarkSize: const StateProperty<Size?>.all(Size(10, 20)),
        tickMarkDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        activeTickMarkDecoration: const StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xFF112233)),
        ),
        mouseCursor: const StateProperty<MouseCursor?>.all(
          SystemMouseCursors.click,
        ),
        valueIndicatorBuilder: _firstIndicator,
        padding: const EdgeInsets.all(5),
        tapTargetSize: const Size(10, 20),
        preferredWidth: 5.0,
        keyboardStep: 5.0,
        allowedInteraction: SliderInteraction.tapOnly,
        animationDuration: const Duration(milliseconds: 100),
        animationCurve: Curves.linear,
      );
      expect(
        const SliderStyle().copyWith(
          trackHeight: full.trackHeight,
          trackDecoration: full.trackDecoration,
          activeTrackDecoration: full.activeTrackDecoration,
          secondaryActiveTrackDecoration: full.secondaryActiveTrackDecoration,
          thumbSize: full.thumbSize,
          thumbDecoration: full.thumbDecoration,
          tickMarkSize: full.tickMarkSize,
          tickMarkDecoration: full.tickMarkDecoration,
          activeTickMarkDecoration: full.activeTickMarkDecoration,
          mouseCursor: full.mouseCursor,
          valueIndicatorBuilder: full.valueIndicatorBuilder,
          padding: full.padding,
          tapTargetSize: full.tapTargetSize,
          preferredWidth: full.preferredWidth,
          keyboardStep: full.keyboardStep,
          allowedInteraction: full.allowedInteraction,
          animationDuration: full.animationDuration,
          animationCurve: full.animationCurve,
        ),
        full,
      );
      expect(const SliderStyle().merge(full), full);
      expect(full.merge(const SliderStyle()), full);
      expect(identical(full.merge(null), full), isTrue);
      expect(full.toString(), contains('SliderStyle('));
    });
  });
}
