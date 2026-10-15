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
