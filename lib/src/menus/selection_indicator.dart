import 'package:flutter/widgets.dart';

import '../foundation/glyphs.dart';

/// The default chosen or checked option indicator.
///
/// A [CheckGlyph] that keeps its space while hidden, so checked and unchecked
/// rows stay aligned.
Widget defaultSelectionIndicator({required bool selected}) => Visibility(
  visible: selected,
  maintainSize: true,
  maintainAnimation: true,
  maintainState: true,
  child: const CheckGlyph(),
);
