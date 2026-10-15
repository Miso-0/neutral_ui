import 'package:flutter/widgets.dart';

/// Animates the icon tokens merged into the ambient icon theme.
class AnimatedIconTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated merge of [data] with the ambient icon theme.
  const AnimatedIconTheme({
    super.key,
    required this.data,
    required super.duration,
    super.curve,
    required this.child,
  });

  /// The partial icon theme to merge with the ambient theme.
  final IconThemeData data;

  /// The subtree that inherits the animated icon theme.
  final Widget child;

  @override
  AnimatedWidgetBaseState<AnimatedIconTheme> createState() =>
      _AnimatedIconThemeState();
}

class _AnimatedIconThemeState
    extends AnimatedWidgetBaseState<AnimatedIconTheme> {
  _IconThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(
      _data,
      widget.data,
      (dynamic value) => _IconThemeDataTween(begin: value as IconThemeData),
    ) as _IconThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme.merge(
      data: _data!.evaluate(animation),
      child: widget.child,
    );
  }
}

class _IconThemeDataTween extends Tween<IconThemeData> {
  _IconThemeDataTween({super.begin});

  @override
  IconThemeData lerp(double t) => IconThemeData.lerp(begin, end, t);
}
