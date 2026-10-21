import 'package:flutter/widgets.dart';

import 'decoration_lerp.dart';

/// Animates the icon tokens merged into the ambient icon theme.
///
/// Both ends of a transition are merged with the ambient theme first, so a
/// token left null in one state fades from the inherited value rather than
/// from transparent or zero.
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
  IconThemeData _ambient = const IconThemeData();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ambient = IconTheme.of(context);
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(
      _data,
      widget.data,
      (dynamic value) =>
          _IconThemeDataTween(this, begin: value as IconThemeData),
    ) as _IconThemeDataTween?;
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(data: _data!.evaluate(animation), child: widget.child);
  }
}

class _IconThemeDataTween extends Tween<IconThemeData> {
  _IconThemeDataTween(this.owner, {super.begin});

  final _AnimatedIconThemeState owner;

  // Tween.transform returns the raw endpoints at 0 and 1; merge those too.
  @override
  IconThemeData transform(double t) => lerp(t);

  @override
  IconThemeData lerp(double t) {
    final IconThemeData a = owner._ambient.merge(begin);
    final IconThemeData b = owner._ambient.merge(end);
    if (t == 0) return a;
    if (t == 1) return b;
    return IconThemeData.lerp(
      a,
      b,
      t,
    ).copyWith(color: lerpColorPremultiplied(a.color, b.color, t));
  }
}
