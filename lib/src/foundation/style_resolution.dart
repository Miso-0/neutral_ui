import 'interaction_state.dart';
import 'state_property.dart';

/// Returns the first non-null resolved token in precedence-ordered [layers].
T? resolveStateful<S, T>(
  InteractionState state,
  List<S?> layers,
  StateProperty<T?>? Function(S style) select,
) {
  for (final S? layer in layers) {
    if (layer == null) {
      continue;
    }
    final T? value = select(layer)?.resolve(state);
    if (value != null) {
      return value;
    }
  }
  return null;
}

/// Returns the first non-null plain token in precedence-ordered [layers].
T? resolvePlain<S, T>(List<S?> layers, T? Function(S style) select) {
  for (final S? layer in layers) {
    if (layer == null) {
      continue;
    }
    final T? value = select(layer);
    if (value != null) {
      return value;
    }
  }
  return null;
}

/// Resolves a token like [resolveStateful], with a painted [fallback].
///
/// The fallback applies only when no layer provides the token at all. A
/// provided token that resolves to null for [state] still falls through to
/// later layers, and if every layer resolves null the result is null, which
/// lets an application opt out of the default.
T? resolveStatefulOrDefault<S, T>(
  InteractionState state,
  List<S?> layers,
  StateProperty<T?>? Function(S style) select,
  T Function() fallback,
) {
  final T? value = resolveStateful<S, T>(state, layers, select);
  if (value != null) {
    return value;
  }
  final bool provided = layers.any(
    (S? layer) => layer != null && select(layer) != null,
  );
  return provided ? null : fallback();
}
