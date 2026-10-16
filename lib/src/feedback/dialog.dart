import 'package:flutter/widgets.dart';

import '../buttons/text_button.dart';
import '../foundation/animated_surface.dart';
import '../foundation/decoration_override.dart';
import '../foundation/motion.dart';
import '../localizations/pure_localizations.dart';
import '../menus/key_activators.dart';
import '../styles/dialog_style.dart';
import '../theme/feedback_themes.dart';

/// A headless dialog surface, positioned inside the route's available area.
class Dialog extends StatelessWidget {
  /// Creates a dialog surface.
  const Dialog({
    super.key,
    this.child,
    this.style,
    this.decoration,
    this.insetPadding,
    this.alignment,
    this.constraints,
    this.clipBehavior,
    this.insetAnimationDuration,
    this.insetAnimationCurve,
  }) : _fullscreen = false;

  /// Creates a dialog that fills the available route.
  const Dialog.fullscreen({
    super.key,
    this.child,
    this.style,
    this.decoration,
    this.insetAnimationDuration,
    this.insetAnimationCurve,
  }) : _fullscreen = true,
       insetPadding = EdgeInsets.zero,
       alignment = null,
       constraints = null,
       clipBehavior = Clip.none;

  /// Content displayed within the surface.
  final Widget? child;

  /// Local appearance and motion tokens.
  final DialogStyle? style;

  /// A decoration shortcut overriding inherited decoration.
  final BoxDecoration? decoration;

  /// Space outside the dialog, in addition to keyboard insets.
  final EdgeInsetsGeometry? insetPadding;

  /// Position in the route.
  final AlignmentGeometry? alignment;

  /// Optional size constraints.
  final BoxConstraints? constraints;

  /// How content is clipped to its decoration.
  final Clip? clipBehavior;

  /// Duration for keyboard inset changes.
  final Duration? insetAnimationDuration;

  /// Curve for keyboard inset changes.
  final Curve? insetAnimationCurve;

  final bool _fullscreen;

  @override
  Widget build(BuildContext context) {
    assert(
      debugCheckDecorationOverride(
        widget: 'Dialog',
        parameter: 'decoration',
        styleToken: 'style.decoration',
        value: decoration,
        styleValue: style?.decoration,
      ),
    );
    final DialogStyle resolved =
        style?.merge(DialogTheme.of(context)) ?? DialogTheme.of(context);
    final EdgeInsets outside =
        (insetPadding ?? resolved.insetPadding ?? EdgeInsets.zero).resolve(
          Directionality.of(context),
        ) +
        MediaQuery.viewInsetsOf(context);
    Widget surface = AnimatedSurface(
      duration: reducedMotionDuration(
        context,
        resolved.transitionDuration ?? const Duration(milliseconds: 200),
      ),
      curve: resolved.transitionCurve ?? Curves.easeOutCubic,
      decoration: decoration ?? resolved.decoration,
      padding: resolved.padding,
      constraints: constraints ?? resolved.constraints,
      clipBehavior: clipBehavior ?? resolved.clipBehavior ?? Clip.none,
      child: child,
    );
    if (_fullscreen) surface = SizedBox.expand(child: surface);
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: PureLocalizations.of(context).dialogLabel,
      child: AnimatedPadding(
        padding: outside,
        duration: reducedMotionDuration(
          context,
          insetAnimationDuration ??
              resolved.insetAnimationDuration ??
              const Duration(milliseconds: 100),
        ),
        curve:
            insetAnimationCurve ??
            resolved.insetAnimationCurve ??
            Curves.decelerate,
        child: MediaQuery.removeViewInsets(
          context: context,
          removeLeft: true,
          removeTop: true,
          removeRight: true,
          removeBottom: true,
          child: Align(
            alignment: alignment ?? resolved.alignment ?? Alignment.center,
            child: surface,
          ),
        ),
      ),
    );
  }
}

/// A dialog with an optional heading, message and action buttons.
class AlertDialog extends StatelessWidget {
  /// Creates an alert dialog.
  const AlertDialog({
    super.key,
    this.icon,
    this.title,
    this.content,
    this.actions,
    this.semanticLabel,
    this.scrollable = false,
    this.style,
    this.decoration,
    this.insetPadding,
    this.alignment,
    this.constraints,
    this.clipBehavior,
  });

  /// An optional heading icon.
  final Widget? icon;

  /// An optional heading.
  final Widget? title;

  /// The primary message content.
  final Widget? content;

  /// Action widgets displayed after the content.
  final List<Widget>? actions;

  /// A custom accessibility name for the route.
  final String? semanticLabel;

  /// Whether the heading and message scroll when space is limited.
  final bool scrollable;

  /// Local appearance and motion tokens.
  final DialogStyle? style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// Space outside the surface, in addition to keyboard insets.
  final EdgeInsetsGeometry? insetPadding;

  /// The directional alignment within the available area.
  final AlignmentGeometry? alignment;

  /// Optional size constraints.
  final BoxConstraints? constraints;

  /// How content is clipped to the surface.
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final DialogStyle resolved =
        style?.merge(DialogTheme.of(context)) ?? DialogTheme.of(context);
    final List<Widget> heading = <Widget>[
      if (icon != null)
        Padding(
          padding: resolved.iconPadding ?? EdgeInsets.zero,
          child: IconTheme.merge(
            data: resolved.iconTheme ?? const IconThemeData(),
            child: icon!,
          ),
        ),
      if (title != null)
        Padding(
          padding: resolved.titlePadding ?? EdgeInsets.zero,
          child: DefaultTextStyle.merge(
            style: resolved.titleTextStyle,
            child: title!,
          ),
        ),
      if (content != null)
        Padding(
          padding: resolved.contentPadding ?? EdgeInsets.zero,
          child: DefaultTextStyle.merge(
            style: resolved.contentTextStyle,
            child: content!,
          ),
        ),
    ];
    return Dialog(
      style: style,
      decoration: decoration,
      insetPadding: insetPadding,
      alignment: alignment,
      constraints: constraints,
      clipBehavior: clipBehavior,
      child: Semantics(
        namesRoute: true,
        label: semanticLabel ?? PureLocalizations.of(context).alertDialogLabel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (scrollable)
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: heading,
                  ),
                ),
              )
            else
              ...heading,
            if (actions != null)
              Padding(
                padding: resolved.actionsPadding ?? EdgeInsets.zero,
                child: OverflowBar(
                  alignment: resolved.actionsAlignment ?? MainAxisAlignment.end,
                  overflowAlignment:
                      resolved.actionsOverflowAlignment ??
                      OverflowBarAlignment.end,
                  overflowDirection:
                      resolved.actionsOverflowDirection ??
                      VerticalDirection.down,
                  overflowSpacing: resolved.actionsOverflowButtonSpacing ?? 0,
                  children: actions!
                      .map(
                        (Widget action) => Padding(
                          padding: resolved.buttonPadding ?? EdgeInsets.zero,
                          child: action,
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A dialog containing a title and a scrollable list of choices.
class SimpleDialog extends StatelessWidget {
  /// Creates a simple dialog.
  const SimpleDialog({
    super.key,
    this.title,
    this.children,
    this.semanticLabel,
    this.style,
    this.decoration,
    this.insetPadding,
    this.alignment,
    this.constraints,
    this.clipBehavior,
  });

  /// An optional heading.
  final Widget? title;

  /// The selectable choices displayed by the dialog.
  final List<Widget>? children;

  /// A custom accessibility name for the route.
  final String? semanticLabel;

  /// Local appearance and motion tokens.
  final DialogStyle? style;

  /// A surface decoration overriding inherited tokens.
  final BoxDecoration? decoration;

  /// Space outside the surface, in addition to keyboard insets.
  final EdgeInsetsGeometry? insetPadding;

  /// The directional alignment within the available area.
  final AlignmentGeometry? alignment;

  /// Optional size constraints.
  final BoxConstraints? constraints;

  /// How content is clipped to the surface.
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final DialogStyle resolved =
        style?.merge(DialogTheme.of(context)) ?? DialogTheme.of(context);
    return Dialog(
      style: style,
      decoration: decoration,
      insetPadding: insetPadding,
      alignment: alignment,
      constraints: constraints,
      clipBehavior: clipBehavior,
      child: Semantics(
        namesRoute: true,
        label: semanticLabel ?? PureLocalizations.of(context).dialogLabel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (title != null)
              Padding(
                padding: resolved.titlePadding ?? EdgeInsets.zero,
                child: DefaultTextStyle.merge(
                  style: resolved.titleTextStyle,
                  child: title!,
                ),
              ),
            Flexible(
              child: SingleChildScrollView(
                padding: resolved.contentPadding,
                child: ListBody(children: children ?? const <Widget>[]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// An accessible selectable choice for [SimpleDialog].
class SimpleDialogOption extends StatelessWidget {
  /// Creates a simple dialog option.
  const SimpleDialogOption({
    super.key,
    this.onPressed,
    this.padding,
    this.child,
    this.style,
  });

  /// Invoked when the control is activated.
  final VoidCallback? onPressed;

  /// Space around the content.
  final EdgeInsetsGeometry? padding;

  /// The widget displayed by this component.
  final Widget? child;

  /// Local appearance and motion tokens.
  final DialogStyle? style;
  @override
  Widget build(BuildContext context) {
    final DialogStyle resolved =
        style?.merge(DialogTheme.of(context)) ?? DialogTheme.of(context);
    return TextButton(
      onPressed: onPressed,
      style: resolved.optionStyle,
      child: Padding(padding: padding ?? EdgeInsets.zero, child: child),
    );
  }
}

/// Displays a modal dialog with a focus trap and animated enter and exit.
Future<T?> showDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TraversalEdgeBehavior? traversalEdgeBehavior,
  bool fullscreenDialog = false,
  bool? requestFocus,
  AnimationStyle? animationStyle,
  DialogStyle? style,
}) {
  final DialogStyle resolved =
      style?.merge(DialogTheme.of(context)) ?? DialogTheme.of(context);
  final NavigatorState navigator = Navigator.of(
    context,
    rootNavigator: useRootNavigator,
  );
  final CapturedThemes themes = InheritedTheme.capture(
    from: context,
    to: navigator.context,
  );
  final Duration duration = reducedMotionDuration(
    context,
    animationStyle?.duration ??
        resolved.transitionDuration ??
        const Duration(milliseconds: 200),
  );
  final Duration reverseDuration = reducedMotionDuration(
    context,
    animationStyle?.reverseDuration ??
        resolved.reverseTransitionDuration ??
        const Duration(milliseconds: 200),
  );
  return navigator.push<T>(
    _DialogRoute<T>(
      duration: duration,
      reverseDuration: reverseDuration,
      barrierDismissible: barrierDismissible,
      barrierColor:
          barrierColor ?? resolved.barrierColor ?? const Color(0x00000000),
      barrierLabel:
          barrierLabel ??
          PureLocalizations.of(context).modalBarrierDismissLabel,
      settings: routeSettings,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior:
          traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
      fullscreenDialog: fullscreenDialog,
      requestFocus: requestFocus,
      pageBuilder:
          (
            BuildContext routeContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            Widget result = themes.wrap(Builder(builder: builder));
            if (style != null) {
              result = DialogTheme(data: resolved, child: result);
            }
            if (useSafeArea) result = SafeArea(child: result);
            if (resolved.barrierBlur != null) {
              result = BackdropFilter(
                filterConfig: resolved.barrierBlur!,
                child: result,
              );
            }
            return Shortcuts(
              shortcuts: <ShortcutActivator, Intent>{
                menuKeyActivator(0x10000001b): const DismissIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (DismissIntent intent) {
                      if (barrierDismissible) navigator.maybePop();
                      return null;
                    },
                  ),
                },
                child: result,
              ),
            );
          },
      transitionBuilder:
          (
            BuildContext routeContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return _DialogTransition(
              animation: animation,
              style: resolved,
              forward:
                  animationStyle?.curve ??
                  resolved.transitionCurve ??
                  Curves.easeOutCubic,
              reverse:
                  animationStyle?.reverseCurve ??
                  resolved.reverseTransitionCurve ??
                  Curves.easeInCubic,
              child: child,
            );
          },
    ),
  );
}

class _DialogRoute<T> extends RawDialogRoute<T> {
  _DialogRoute({
    required Duration duration,
    required this._reverseDuration,
    required super.pageBuilder,
    required super.barrierDismissible,
    required super.barrierColor,
    required super.barrierLabel,
    required super.transitionBuilder,
    super.settings,
    super.anchorPoint,
    super.traversalEdgeBehavior,
    super.fullscreenDialog,
    super.requestFocus,
  }) : super(transitionDuration: duration);
  final Duration _reverseDuration;
  @override
  Duration get reverseTransitionDuration => _reverseDuration;
}

class _DialogTransition extends StatefulWidget {
  const _DialogTransition({
    required this.animation,
    required this.style,
    required this.forward,
    required this.reverse,
    required this.child,
  });
  final Animation<double> animation;
  final DialogStyle style;
  final Curve forward;
  final Curve reverse;
  final Widget child;
  @override
  State<_DialogTransition> createState() => _DialogTransitionState();
}

class _DialogTransitionState extends State<_DialogTransition> {
  late CurvedAnimation _animation = CurvedAnimation(
    parent: widget.animation,
    curve: widget.forward,
    reverseCurve: widget.reverse,
  );
  @override
  void didUpdateWidget(_DialogTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) {
      _animation.dispose();
      _animation = CurvedAnimation(
        parent: widget.animation,
        curve: widget.forward,
        reverseCurve: widget.reverse,
      );
    } else {
      _animation.curve = widget.forward;
      _animation.reverseCurve = widget.reverse;
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.style.transitionBuilder?.call(context, _animation, widget.child) ??
      overlayTransition(
        context,
        _animation,
        widget.child,
        alignment: widget.style.alignment ?? Alignment.center,
      );
}
