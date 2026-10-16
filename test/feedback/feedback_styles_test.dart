import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/feedback/feedback_transition.dart';
import 'package:pure_ui/src/foundation/motion.dart';
import 'package:pure_ui/src/overlay/overlay_behavior.dart';
import 'package:pure_ui/src/overlay/overlay_placement.dart';
import 'package:pure_ui/src/styles/button_style.dart';
import 'package:pure_ui/src/styles/tooltip_style.dart';
import 'package:pure_ui/src/styles/dialog_style.dart';
import 'package:pure_ui/src/styles/bottom_sheet_style.dart';
import 'package:pure_ui/src/styles/snack_bar_style.dart';

void main() {
  Widget transition(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) => child;
  test('TooltipStyle.decoration follows the complete token contract', () {
    final Decoration value = const BoxDecoration(color: Color(0xff123456));
    final TooltipStyle style = TooltipStyle(decoration: value);
    expect(const TooltipStyle().decoration, isNull);
    expect(const TooltipStyle().copyWith(decoration: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.padding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final TooltipStyle style = TooltipStyle(padding: value);
    expect(const TooltipStyle().padding, isNull);
    expect(const TooltipStyle().copyWith(padding: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.margin follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final TooltipStyle style = TooltipStyle(margin: value);
    expect(const TooltipStyle().margin, isNull);
    expect(const TooltipStyle().copyWith(margin: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(margin: value).hashCode);
    expect(style.toString(), contains('margin: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.constraints follows the complete token contract', () {
    final BoxConstraints value = const BoxConstraints(maxWidth: 310);
    final TooltipStyle style = TooltipStyle(constraints: value);
    expect(const TooltipStyle().constraints, isNull);
    expect(const TooltipStyle().copyWith(constraints: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(constraints: value).hashCode);
    expect(style.toString(), contains('constraints: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.textStyle follows the complete token contract', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final TooltipStyle style = TooltipStyle(textStyle: value);
    expect(const TooltipStyle().textStyle, isNull);
    expect(const TooltipStyle().copyWith(textStyle: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(textStyle: value).hashCode);
    expect(style.toString(), contains('textStyle: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.textAlign follows the complete token contract', () {
    final TextAlign value = TextAlign.end;
    final TooltipStyle style = TooltipStyle(textAlign: value);
    expect(const TooltipStyle().textAlign, isNull);
    expect(const TooltipStyle().copyWith(textAlign: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(textAlign: value).hashCode);
    expect(style.toString(), contains('textAlign: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.placement follows the complete token contract', () {
    final OverlayPlacement value = const OverlayPlacement(
      preferredSide: AxisDirection.up,
      gap: 11,
    );
    final TooltipStyle style = TooltipStyle(placement: value);
    expect(const TooltipStyle().placement, isNull);
    expect(const TooltipStyle().copyWith(placement: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(placement: value).hashCode);
    expect(style.toString(), contains('placement: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.overlayLocation follows the complete token contract', () {
    final OverlayLocation value = OverlayLocation.nearest;
    final TooltipStyle style = TooltipStyle(overlayLocation: value);
    expect(const TooltipStyle().overlayLocation, isNull);
    expect(const TooltipStyle().copyWith(overlayLocation: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(overlayLocation: value).hashCode);
    expect(style.toString(), contains('overlayLocation: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.verticalOffset follows the complete token contract', () {
    final double value = 7;
    final TooltipStyle style = TooltipStyle(verticalOffset: value);
    expect(const TooltipStyle().verticalOffset, isNull);
    expect(const TooltipStyle().copyWith(verticalOffset: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(verticalOffset: value).hashCode);
    expect(style.toString(), contains('verticalOffset: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.preferBelow follows the complete token contract', () {
    final bool value = false;
    final TooltipStyle style = TooltipStyle(preferBelow: value);
    expect(const TooltipStyle().preferBelow, isNull);
    expect(const TooltipStyle().copyWith(preferBelow: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(preferBelow: value).hashCode);
    expect(style.toString(), contains('preferBelow: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test(
    'TooltipStyle.transitionDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final TooltipStyle style = TooltipStyle(transitionDuration: value);
      expect(const TooltipStyle().transitionDuration, isNull);
      expect(const TooltipStyle().copyWith(transitionDuration: value), style);
      expect(const TooltipStyle().merge(style), style);
      expect(style.merge(const TooltipStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, TooltipStyle(transitionDuration: value).hashCode);
      expect(style.toString(), contains('transitionDuration: $value'));
      expect(style, isNot(const TooltipStyle()));
    },
  );
  test('TooltipStyle.reverseTransitionDuration follows the complete token contract', () {
    final Duration value = const Duration(milliseconds: 73);
    final TooltipStyle style = TooltipStyle(reverseTransitionDuration: value);
    expect(const TooltipStyle().reverseTransitionDuration, isNull);
    expect(
      const TooltipStyle().copyWith(reverseTransitionDuration: value),
      style,
    );
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      TooltipStyle(reverseTransitionDuration: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionDuration: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test('TooltipStyle.transitionCurve follows the complete token contract', () {
    final Curve value = Curves.easeInOutCubic;
    final TooltipStyle style = TooltipStyle(transitionCurve: value);
    expect(const TooltipStyle().transitionCurve, isNull);
    expect(const TooltipStyle().copyWith(transitionCurve: value), style);
    expect(const TooltipStyle().merge(style), style);
    expect(style.merge(const TooltipStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, TooltipStyle(transitionCurve: value).hashCode);
    expect(style.toString(), contains('transitionCurve: $value'));
    expect(style, isNot(const TooltipStyle()));
  });
  test(
    'TooltipStyle.reverseTransitionCurve follows the complete token contract',
    () {
      final Curve value = Curves.easeInOutCubic;
      final TooltipStyle style = TooltipStyle(reverseTransitionCurve: value);
      expect(const TooltipStyle().reverseTransitionCurve, isNull);
      expect(
        const TooltipStyle().copyWith(reverseTransitionCurve: value),
        style,
      );
      expect(const TooltipStyle().merge(style), style);
      expect(style.merge(const TooltipStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        TooltipStyle(reverseTransitionCurve: value).hashCode,
      );
      expect(style.toString(), contains('reverseTransitionCurve: $value'));
      expect(style, isNot(const TooltipStyle()));
    },
  );
  test(
    'TooltipStyle.transitionBuilder follows the complete token contract',
    () {
      final FeedbackTransitionBuilder value = transition;
      final TooltipStyle style = TooltipStyle(transitionBuilder: value);
      expect(const TooltipStyle().transitionBuilder, isNull);
      expect(const TooltipStyle().copyWith(transitionBuilder: value), style);
      expect(const TooltipStyle().merge(style), style);
      expect(style.merge(const TooltipStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, TooltipStyle(transitionBuilder: value).hashCode);
      expect(style.toString(), contains('transitionBuilder: $value'));
      expect(style, isNot(const TooltipStyle()));
    },
  );
  test('DialogStyle.decoration follows the complete token contract', () {
    final Decoration value = const BoxDecoration(color: Color(0xff123456));
    final DialogStyle style = DialogStyle(decoration: value);
    expect(const DialogStyle().decoration, isNull);
    expect(const DialogStyle().copyWith(decoration: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.padding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(padding: value);
    expect(const DialogStyle().padding, isNull);
    expect(const DialogStyle().copyWith(padding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.insetPadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(insetPadding: value);
    expect(const DialogStyle().insetPadding, isNull);
    expect(const DialogStyle().copyWith(insetPadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(insetPadding: value).hashCode);
    expect(style.toString(), contains('insetPadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.constraints follows the complete token contract', () {
    final BoxConstraints value = const BoxConstraints(maxWidth: 310);
    final DialogStyle style = DialogStyle(constraints: value);
    expect(const DialogStyle().constraints, isNull);
    expect(const DialogStyle().copyWith(constraints: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(constraints: value).hashCode);
    expect(style.toString(), contains('constraints: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.alignment follows the complete token contract', () {
    final AlignmentGeometry value = AlignmentDirectional.centerEnd;
    final DialogStyle style = DialogStyle(alignment: value);
    expect(const DialogStyle().alignment, isNull);
    expect(const DialogStyle().copyWith(alignment: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(alignment: value).hashCode);
    expect(style.toString(), contains('alignment: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.barrierColor follows the complete token contract', () {
    final Color value = const Color(0xff123456);
    final DialogStyle style = DialogStyle(barrierColor: value);
    expect(const DialogStyle().barrierColor, isNull);
    expect(const DialogStyle().copyWith(barrierColor: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(barrierColor: value).hashCode);
    expect(style.toString(), contains('barrierColor: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.barrierBlur follows the complete token contract', () {
    final ImageFilterConfig value = ImageFilterConfig.blur(
      sigmaX: 3,
      sigmaY: 4,
    );
    final DialogStyle style = DialogStyle(barrierBlur: value);
    expect(const DialogStyle().barrierBlur, isNull);
    expect(const DialogStyle().copyWith(barrierBlur: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(barrierBlur: value).hashCode);
    expect(style.toString(), contains('barrierBlur: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.clipBehavior follows the complete token contract', () {
    final Clip value = Clip.antiAlias;
    final DialogStyle style = DialogStyle(clipBehavior: value);
    expect(const DialogStyle().clipBehavior, isNull);
    expect(const DialogStyle().copyWith(clipBehavior: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(clipBehavior: value).hashCode);
    expect(style.toString(), contains('clipBehavior: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.titleTextStyle follows the complete token contract', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final DialogStyle style = DialogStyle(titleTextStyle: value);
    expect(const DialogStyle().titleTextStyle, isNull);
    expect(const DialogStyle().copyWith(titleTextStyle: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(titleTextStyle: value).hashCode);
    expect(style.toString(), contains('titleTextStyle: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.contentTextStyle follows the complete token contract', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final DialogStyle style = DialogStyle(contentTextStyle: value);
    expect(const DialogStyle().contentTextStyle, isNull);
    expect(const DialogStyle().copyWith(contentTextStyle: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(contentTextStyle: value).hashCode);
    expect(style.toString(), contains('contentTextStyle: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.titlePadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(titlePadding: value);
    expect(const DialogStyle().titlePadding, isNull);
    expect(const DialogStyle().copyWith(titlePadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(titlePadding: value).hashCode);
    expect(style.toString(), contains('titlePadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.contentPadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(contentPadding: value);
    expect(const DialogStyle().contentPadding, isNull);
    expect(const DialogStyle().copyWith(contentPadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(contentPadding: value).hashCode);
    expect(style.toString(), contains('contentPadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.actionsPadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(actionsPadding: value);
    expect(const DialogStyle().actionsPadding, isNull);
    expect(const DialogStyle().copyWith(actionsPadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(actionsPadding: value).hashCode);
    expect(style.toString(), contains('actionsPadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.actionsAlignment follows the complete token contract', () {
    final MainAxisAlignment value = MainAxisAlignment.center;
    final DialogStyle style = DialogStyle(actionsAlignment: value);
    expect(const DialogStyle().actionsAlignment, isNull);
    expect(const DialogStyle().copyWith(actionsAlignment: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(actionsAlignment: value).hashCode);
    expect(style.toString(), contains('actionsAlignment: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test(
    'DialogStyle.actionsOverflowAlignment follows the complete token contract',
    () {
      final OverflowBarAlignment value = OverflowBarAlignment.center;
      final DialogStyle style = DialogStyle(actionsOverflowAlignment: value);
      expect(const DialogStyle().actionsOverflowAlignment, isNull);
      expect(
        const DialogStyle().copyWith(actionsOverflowAlignment: value),
        style,
      );
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        DialogStyle(actionsOverflowAlignment: value).hashCode,
      );
      expect(style.toString(), contains('actionsOverflowAlignment: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test(
    'DialogStyle.actionsOverflowDirection follows the complete token contract',
    () {
      final VerticalDirection value = VerticalDirection.up;
      final DialogStyle style = DialogStyle(actionsOverflowDirection: value);
      expect(const DialogStyle().actionsOverflowDirection, isNull);
      expect(
        const DialogStyle().copyWith(actionsOverflowDirection: value),
        style,
      );
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        DialogStyle(actionsOverflowDirection: value).hashCode,
      );
      expect(style.toString(), contains('actionsOverflowDirection: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test('DialogStyle.actionsOverflowButtonSpacing follows the complete token contract', () {
    final double value = 7;
    final DialogStyle style = DialogStyle(actionsOverflowButtonSpacing: value);
    expect(const DialogStyle().actionsOverflowButtonSpacing, isNull);
    expect(
      const DialogStyle().copyWith(actionsOverflowButtonSpacing: value),
      style,
    );
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      DialogStyle(actionsOverflowButtonSpacing: value).hashCode,
    );
    expect(style.toString(), contains('actionsOverflowButtonSpacing: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.buttonPadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(buttonPadding: value);
    expect(const DialogStyle().buttonPadding, isNull);
    expect(const DialogStyle().copyWith(buttonPadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(buttonPadding: value).hashCode);
    expect(style.toString(), contains('buttonPadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.iconPadding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final DialogStyle style = DialogStyle(iconPadding: value);
    expect(const DialogStyle().iconPadding, isNull);
    expect(const DialogStyle().copyWith(iconPadding: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(iconPadding: value).hashCode);
    expect(style.toString(), contains('iconPadding: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.iconTheme follows the complete token contract', () {
    final IconThemeData value = const IconThemeData(size: 21);
    final DialogStyle style = DialogStyle(iconTheme: value);
    expect(const DialogStyle().iconTheme, isNull);
    expect(const DialogStyle().copyWith(iconTheme: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(iconTheme: value).hashCode);
    expect(style.toString(), contains('iconTheme: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('DialogStyle.optionStyle follows the complete token contract', () {
    final ButtonStyle value = const ButtonStyle(spacing: 8);
    final DialogStyle style = DialogStyle(optionStyle: value);
    expect(const DialogStyle().optionStyle, isNull);
    expect(const DialogStyle().copyWith(optionStyle: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(optionStyle: value).hashCode);
    expect(style.toString(), contains('optionStyle: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test(
    'DialogStyle.insetAnimationDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final DialogStyle style = DialogStyle(insetAnimationDuration: value);
      expect(const DialogStyle().insetAnimationDuration, isNull);
      expect(
        const DialogStyle().copyWith(insetAnimationDuration: value),
        style,
      );
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        DialogStyle(insetAnimationDuration: value).hashCode,
      );
      expect(style.toString(), contains('insetAnimationDuration: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test(
    'DialogStyle.insetAnimationCurve follows the complete token contract',
    () {
      final Curve value = Curves.easeInOutCubic;
      final DialogStyle style = DialogStyle(insetAnimationCurve: value);
      expect(const DialogStyle().insetAnimationCurve, isNull);
      expect(const DialogStyle().copyWith(insetAnimationCurve: value), style);
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, DialogStyle(insetAnimationCurve: value).hashCode);
      expect(style.toString(), contains('insetAnimationCurve: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test(
    'DialogStyle.transitionDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final DialogStyle style = DialogStyle(transitionDuration: value);
      expect(const DialogStyle().transitionDuration, isNull);
      expect(const DialogStyle().copyWith(transitionDuration: value), style);
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, DialogStyle(transitionDuration: value).hashCode);
      expect(style.toString(), contains('transitionDuration: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test(
    'DialogStyle.reverseTransitionDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final DialogStyle style = DialogStyle(reverseTransitionDuration: value);
      expect(const DialogStyle().reverseTransitionDuration, isNull);
      expect(
        const DialogStyle().copyWith(reverseTransitionDuration: value),
        style,
      );
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        DialogStyle(reverseTransitionDuration: value).hashCode,
      );
      expect(style.toString(), contains('reverseTransitionDuration: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test('DialogStyle.transitionCurve follows the complete token contract', () {
    final Curve value = Curves.easeInOutCubic;
    final DialogStyle style = DialogStyle(transitionCurve: value);
    expect(const DialogStyle().transitionCurve, isNull);
    expect(const DialogStyle().copyWith(transitionCurve: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(transitionCurve: value).hashCode);
    expect(style.toString(), contains('transitionCurve: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test(
    'DialogStyle.reverseTransitionCurve follows the complete token contract',
    () {
      final Curve value = Curves.easeInOutCubic;
      final DialogStyle style = DialogStyle(reverseTransitionCurve: value);
      expect(const DialogStyle().reverseTransitionCurve, isNull);
      expect(
        const DialogStyle().copyWith(reverseTransitionCurve: value),
        style,
      );
      expect(const DialogStyle().merge(style), style);
      expect(style.merge(const DialogStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        DialogStyle(reverseTransitionCurve: value).hashCode,
      );
      expect(style.toString(), contains('reverseTransitionCurve: $value'));
      expect(style, isNot(const DialogStyle()));
    },
  );
  test('DialogStyle.transitionBuilder follows the complete token contract', () {
    final FeedbackTransitionBuilder value = transition;
    final DialogStyle style = DialogStyle(transitionBuilder: value);
    expect(const DialogStyle().transitionBuilder, isNull);
    expect(const DialogStyle().copyWith(transitionBuilder: value), style);
    expect(const DialogStyle().merge(style), style);
    expect(style.merge(const DialogStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, DialogStyle(transitionBuilder: value).hashCode);
    expect(style.toString(), contains('transitionBuilder: $value'));
    expect(style, isNot(const DialogStyle()));
  });
  test('BottomSheetStyle.decoration follows the complete token contract', () {
    final Decoration value = const BoxDecoration(color: Color(0xff123456));
    final BottomSheetStyle style = BottomSheetStyle(decoration: value);
    expect(const BottomSheetStyle().decoration, isNull);
    expect(const BottomSheetStyle().copyWith(decoration: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.padding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final BottomSheetStyle style = BottomSheetStyle(padding: value);
    expect(const BottomSheetStyle().padding, isNull);
    expect(const BottomSheetStyle().copyWith(padding: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.constraints follows the complete token contract', () {
    final BoxConstraints value = const BoxConstraints(maxWidth: 310);
    final BottomSheetStyle style = BottomSheetStyle(constraints: value);
    expect(const BottomSheetStyle().constraints, isNull);
    expect(const BottomSheetStyle().copyWith(constraints: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(constraints: value).hashCode);
    expect(style.toString(), contains('constraints: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.clipBehavior follows the complete token contract', () {
    final Clip value = Clip.antiAlias;
    final BottomSheetStyle style = BottomSheetStyle(clipBehavior: value);
    expect(const BottomSheetStyle().clipBehavior, isNull);
    expect(const BottomSheetStyle().copyWith(clipBehavior: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(clipBehavior: value).hashCode);
    expect(style.toString(), contains('clipBehavior: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.barrierColor follows the complete token contract', () {
    final Color value = const Color(0xff123456);
    final BottomSheetStyle style = BottomSheetStyle(barrierColor: value);
    expect(const BottomSheetStyle().barrierColor, isNull);
    expect(const BottomSheetStyle().copyWith(barrierColor: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(barrierColor: value).hashCode);
    expect(style.toString(), contains('barrierColor: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test(
    'BottomSheetStyle.dragHandleColor follows the complete token contract',
    () {
      final Color value = const Color(0xff123456);
      final BottomSheetStyle style = BottomSheetStyle(dragHandleColor: value);
      expect(const BottomSheetStyle().dragHandleColor, isNull);
      expect(const BottomSheetStyle().copyWith(dragHandleColor: value), style);
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, BottomSheetStyle(dragHandleColor: value).hashCode);
      expect(style.toString(), contains('dragHandleColor: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test(
    'BottomSheetStyle.dragHandleSize follows the complete token contract',
    () {
      final Size value = const Size(31, 5);
      final BottomSheetStyle style = BottomSheetStyle(dragHandleSize: value);
      expect(const BottomSheetStyle().dragHandleSize, isNull);
      expect(const BottomSheetStyle().copyWith(dragHandleSize: value), style);
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, BottomSheetStyle(dragHandleSize: value).hashCode);
      expect(style.toString(), contains('dragHandleSize: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test(
    'BottomSheetStyle.dragHandleDecoration follows the complete token contract',
    () {
      final Decoration value = const BoxDecoration(color: Color(0xff123456));
      final BottomSheetStyle style = BottomSheetStyle(
        dragHandleDecoration: value,
      );
      expect(const BottomSheetStyle().dragHandleDecoration, isNull);
      expect(
        const BottomSheetStyle().copyWith(dragHandleDecoration: value),
        style,
      );
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        BottomSheetStyle(dragHandleDecoration: value).hashCode,
      );
      expect(style.toString(), contains('dragHandleDecoration: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test(
    'BottomSheetStyle.transitionDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final BottomSheetStyle style = BottomSheetStyle(
        transitionDuration: value,
      );
      expect(const BottomSheetStyle().transitionDuration, isNull);
      expect(
        const BottomSheetStyle().copyWith(transitionDuration: value),
        style,
      );
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        BottomSheetStyle(transitionDuration: value).hashCode,
      );
      expect(style.toString(), contains('transitionDuration: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test('BottomSheetStyle.reverseTransitionDuration follows the complete token contract', () {
    final Duration value = const Duration(milliseconds: 73);
    final BottomSheetStyle style = BottomSheetStyle(
      reverseTransitionDuration: value,
    );
    expect(const BottomSheetStyle().reverseTransitionDuration, isNull);
    expect(
      const BottomSheetStyle().copyWith(reverseTransitionDuration: value),
      style,
    );
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      BottomSheetStyle(reverseTransitionDuration: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionDuration: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test(
    'BottomSheetStyle.transitionCurve follows the complete token contract',
    () {
      final Curve value = Curves.easeInOutCubic;
      final BottomSheetStyle style = BottomSheetStyle(transitionCurve: value);
      expect(const BottomSheetStyle().transitionCurve, isNull);
      expect(const BottomSheetStyle().copyWith(transitionCurve: value), style);
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, BottomSheetStyle(transitionCurve: value).hashCode);
      expect(style.toString(), contains('transitionCurve: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test('BottomSheetStyle.reverseTransitionCurve follows the complete token contract', () {
    final Curve value = Curves.easeInOutCubic;
    final BottomSheetStyle style = BottomSheetStyle(
      reverseTransitionCurve: value,
    );
    expect(const BottomSheetStyle().reverseTransitionCurve, isNull);
    expect(
      const BottomSheetStyle().copyWith(reverseTransitionCurve: value),
      style,
    );
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      BottomSheetStyle(reverseTransitionCurve: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionCurve: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.snapPoints follows the complete token contract', () {
    final List<double> value = const <double>[.3, .7, 1];
    final BottomSheetStyle style = BottomSheetStyle(snapPoints: value);
    expect(const BottomSheetStyle().snapPoints, isNull);
    expect(const BottomSheetStyle().copyWith(snapPoints: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(snapPoints: value).hashCode);
    expect(style.toString(), contains('snapPoints: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test('BottomSheetStyle.spring follows the complete token contract', () {
    final MotionSpring value = MotionSpring.bouncy;
    final BottomSheetStyle style = BottomSheetStyle(spring: value);
    expect(const BottomSheetStyle().spring, isNull);
    expect(const BottomSheetStyle().copyWith(spring: value), style);
    expect(const BottomSheetStyle().merge(style), style);
    expect(style.merge(const BottomSheetStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, BottomSheetStyle(spring: value).hashCode);
    expect(style.toString(), contains('spring: $value'));
    expect(style, isNot(const BottomSheetStyle()));
  });
  test(
    'BottomSheetStyle.transitionBuilder follows the complete token contract',
    () {
      final FeedbackTransitionBuilder value = transition;
      final BottomSheetStyle style = BottomSheetStyle(transitionBuilder: value);
      expect(const BottomSheetStyle().transitionBuilder, isNull);
      expect(
        const BottomSheetStyle().copyWith(transitionBuilder: value),
        style,
      );
      expect(const BottomSheetStyle().merge(style), style);
      expect(style.merge(const BottomSheetStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        BottomSheetStyle(transitionBuilder: value).hashCode,
      );
      expect(style.toString(), contains('transitionBuilder: $value'));
      expect(style, isNot(const BottomSheetStyle()));
    },
  );
  test('SnackBarStyle.decoration follows the complete token contract', () {
    final Decoration value = const BoxDecoration(color: Color(0xff123456));
    final SnackBarStyle style = SnackBarStyle(decoration: value);
    expect(const SnackBarStyle().decoration, isNull);
    expect(const SnackBarStyle().copyWith(decoration: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(decoration: value).hashCode);
    expect(style.toString(), contains('decoration: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.padding follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final SnackBarStyle style = SnackBarStyle(padding: value);
    expect(const SnackBarStyle().padding, isNull);
    expect(const SnackBarStyle().copyWith(padding: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(padding: value).hashCode);
    expect(style.toString(), contains('padding: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.margin follows the complete token contract', () {
    final EdgeInsetsGeometry value = const EdgeInsetsDirectional.only(start: 7);
    final SnackBarStyle style = SnackBarStyle(margin: value);
    expect(const SnackBarStyle().margin, isNull);
    expect(const SnackBarStyle().copyWith(margin: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(margin: value).hashCode);
    expect(style.toString(), contains('margin: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.constraints follows the complete token contract', () {
    final BoxConstraints value = const BoxConstraints(maxWidth: 310);
    final SnackBarStyle style = SnackBarStyle(constraints: value);
    expect(const SnackBarStyle().constraints, isNull);
    expect(const SnackBarStyle().copyWith(constraints: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(constraints: value).hashCode);
    expect(style.toString(), contains('constraints: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.textStyle follows the complete token contract', () {
    final TextStyle value = const TextStyle(fontSize: 19);
    final SnackBarStyle style = SnackBarStyle(textStyle: value);
    expect(const SnackBarStyle().textStyle, isNull);
    expect(const SnackBarStyle().copyWith(textStyle: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(textStyle: value).hashCode);
    expect(style.toString(), contains('textStyle: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.actionStyle follows the complete token contract', () {
    final ButtonStyle value = const ButtonStyle(spacing: 8);
    final SnackBarStyle style = SnackBarStyle(actionStyle: value);
    expect(const SnackBarStyle().actionStyle, isNull);
    expect(const SnackBarStyle().copyWith(actionStyle: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(actionStyle: value).hashCode);
    expect(style.toString(), contains('actionStyle: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test(
    'SnackBarStyle.closeButtonStyle follows the complete token contract',
    () {
      final ButtonStyle value = const ButtonStyle(spacing: 8);
      final SnackBarStyle style = SnackBarStyle(closeButtonStyle: value);
      expect(const SnackBarStyle().closeButtonStyle, isNull);
      expect(const SnackBarStyle().copyWith(closeButtonStyle: value), style);
      expect(const SnackBarStyle().merge(style), style);
      expect(style.merge(const SnackBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, SnackBarStyle(closeButtonStyle: value).hashCode);
      expect(style.toString(), contains('closeButtonStyle: $value'));
      expect(style, isNot(const SnackBarStyle()));
    },
  );
  test('SnackBarStyle.spacing follows the complete token contract', () {
    final double value = 7;
    final SnackBarStyle style = SnackBarStyle(spacing: value);
    expect(const SnackBarStyle().spacing, isNull);
    expect(const SnackBarStyle().copyWith(spacing: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(spacing: value).hashCode);
    expect(style.toString(), contains('spacing: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.alignment follows the complete token contract', () {
    final AlignmentGeometry value = AlignmentDirectional.centerEnd;
    final SnackBarStyle style = SnackBarStyle(alignment: value);
    expect(const SnackBarStyle().alignment, isNull);
    expect(const SnackBarStyle().copyWith(alignment: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(alignment: value).hashCode);
    expect(style.toString(), contains('alignment: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.clipBehavior follows the complete token contract', () {
    final Clip value = Clip.antiAlias;
    final SnackBarStyle style = SnackBarStyle(clipBehavior: value);
    expect(const SnackBarStyle().clipBehavior, isNull);
    expect(const SnackBarStyle().copyWith(clipBehavior: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(clipBehavior: value).hashCode);
    expect(style.toString(), contains('clipBehavior: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test(
    'SnackBarStyle.transitionDuration follows the complete token contract',
    () {
      final Duration value = const Duration(milliseconds: 73);
      final SnackBarStyle style = SnackBarStyle(transitionDuration: value);
      expect(const SnackBarStyle().transitionDuration, isNull);
      expect(const SnackBarStyle().copyWith(transitionDuration: value), style);
      expect(const SnackBarStyle().merge(style), style);
      expect(style.merge(const SnackBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, SnackBarStyle(transitionDuration: value).hashCode);
      expect(style.toString(), contains('transitionDuration: $value'));
      expect(style, isNot(const SnackBarStyle()));
    },
  );
  test('SnackBarStyle.reverseTransitionDuration follows the complete token contract', () {
    final Duration value = const Duration(milliseconds: 73);
    final SnackBarStyle style = SnackBarStyle(reverseTransitionDuration: value);
    expect(const SnackBarStyle().reverseTransitionDuration, isNull);
    expect(
      const SnackBarStyle().copyWith(reverseTransitionDuration: value),
      style,
    );
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(
      style.hashCode,
      SnackBarStyle(reverseTransitionDuration: value).hashCode,
    );
    expect(style.toString(), contains('reverseTransitionDuration: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test('SnackBarStyle.transitionCurve follows the complete token contract', () {
    final Curve value = Curves.easeInOutCubic;
    final SnackBarStyle style = SnackBarStyle(transitionCurve: value);
    expect(const SnackBarStyle().transitionCurve, isNull);
    expect(const SnackBarStyle().copyWith(transitionCurve: value), style);
    expect(const SnackBarStyle().merge(style), style);
    expect(style.merge(const SnackBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(style.copyWith(), style);
    expect(style.hashCode, SnackBarStyle(transitionCurve: value).hashCode);
    expect(style.toString(), contains('transitionCurve: $value'));
    expect(style, isNot(const SnackBarStyle()));
  });
  test(
    'SnackBarStyle.reverseTransitionCurve follows the complete token contract',
    () {
      final Curve value = Curves.easeInOutCubic;
      final SnackBarStyle style = SnackBarStyle(reverseTransitionCurve: value);
      expect(const SnackBarStyle().reverseTransitionCurve, isNull);
      expect(
        const SnackBarStyle().copyWith(reverseTransitionCurve: value),
        style,
      );
      expect(const SnackBarStyle().merge(style), style);
      expect(style.merge(const SnackBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(
        style.hashCode,
        SnackBarStyle(reverseTransitionCurve: value).hashCode,
      );
      expect(style.toString(), contains('reverseTransitionCurve: $value'));
      expect(style, isNot(const SnackBarStyle()));
    },
  );
  test(
    'SnackBarStyle.transitionBuilder follows the complete token contract',
    () {
      final FeedbackTransitionBuilder value = transition;
      final SnackBarStyle style = SnackBarStyle(transitionBuilder: value);
      expect(const SnackBarStyle().transitionBuilder, isNull);
      expect(const SnackBarStyle().copyWith(transitionBuilder: value), style);
      expect(const SnackBarStyle().merge(style), style);
      expect(style.merge(const SnackBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.copyWith(), style);
      expect(style.hashCode, SnackBarStyle(transitionBuilder: value).hashCode);
      expect(style.toString(), contains('transitionBuilder: $value'));
      expect(style, isNot(const SnackBarStyle()));
    },
  );
  test('nested button tokens merge without replacing receiver tokens', () {
    final DialogStyle dialog =
        const DialogStyle(optionStyle: ButtonStyle(spacing: 2)).merge(
          const DialogStyle(
            optionStyle: ButtonStyle(spacing: 8, tapTargetSize: Size(44, 44)),
          ),
        );
    expect(dialog.optionStyle!.spacing, 2);
    expect(dialog.optionStyle!.tapTargetSize, const Size(44, 44));
    final SnackBarStyle snack =
        const SnackBarStyle(
          actionStyle: ButtonStyle(spacing: 2),
          closeButtonStyle: ButtonStyle(spacing: 3),
        ).merge(
          const SnackBarStyle(
            actionStyle: ButtonStyle(tapTargetSize: Size(40, 40)),
            closeButtonStyle: ButtonStyle(tapTargetSize: Size(42, 42)),
          ),
        );
    expect(snack.actionStyle!.spacing, 2);
    expect(snack.actionStyle!.tapTargetSize, const Size(40, 40));
    expect(snack.closeButtonStyle!.spacing, 3);
    expect(snack.closeButtonStyle!.tapTargetSize, const Size(42, 42));
  });
}
