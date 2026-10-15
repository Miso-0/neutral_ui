import 'interaction_state.dart';

/// Resolves a token from a component's current interaction state.
typedef StateResolver<T> = T Function(InteractionState state);

/// A token whose value can vary with a component's interaction state.
abstract class StateProperty<T> {
  /// Creates a token with the same [value] in every state.
  const factory StateProperty.all(T value) = _AllStateProperty<T>;

  /// Creates a token resolved by [resolver] in every state.
  const factory StateProperty.resolveWith(StateResolver<T> resolver) =
      _ResolvingStateProperty<T>;

  /// Resolves this token for [state].
  T resolve(InteractionState state);
}

class _AllStateProperty<T> implements StateProperty<T> {
  const _AllStateProperty(this.value);

  final T value;

  @override
  T resolve(InteractionState state) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType &&
          other is _AllStateProperty<T> &&
          value == other.value;

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @override
  String toString() => 'StateProperty<$T>.all($value)';
}

class _ResolvingStateProperty<T> implements StateProperty<T> {
  const _ResolvingStateProperty(this.resolver);

  final StateResolver<T> resolver;

  @override
  T resolve(InteractionState state) => resolver(state);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other.runtimeType == runtimeType &&
          other is _ResolvingStateProperty<T> &&
          resolver == other.resolver;

  @override
  int get hashCode => Object.hash(runtimeType, resolver);

  @override
  String toString() => 'StateProperty<$T>.resolveWith($resolver)';
}
