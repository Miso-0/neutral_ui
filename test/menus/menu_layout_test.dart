import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';
import 'package:pure_ui/src/menus/menu_layout.dart';

void main() {
  const Size overlay = Size(400, 300);
  const Rect anchor = Rect.fromLTWH(100, 100, 80, 30);
  const BoxConstraints bounds = BoxConstraints.tightFor(
    width: 400,
    height: 300,
  );
  MenuPositionDelegate delegate({
    Rect rect = anchor,
    TextDirection direction = TextDirection.ltr,
    MenuStyle style = const MenuStyle(),
    PopupMenuPosition position = PopupMenuPosition.under,
    Offset offset = Offset.zero,
    double? maxHeight,
    bool match = true,
  }) => MenuPositionDelegate(
    anchorRect: rect,
    textDirection: direction,
    style: style,
    position: position,
    offset: offset,
    maxHeight: maxHeight,
    matchAnchorWidth: match,
  );

  test('under and over attach to the intended anchor edge', () {
    expect(
      delegate().getPositionForChild(overlay, const Size(100, 60)),
      const Offset(100, 130),
    );
    expect(
      delegate(position: PopupMenuPosition.over)
          .getPositionForChild(overlay, const Size(100, 60)),
      const Offset(100, 100),
    );
  });
  test('insufficient space below flips above', () {
    expect(
      delegate(rect: const Rect.fromLTWH(100, 250, 80, 30))
          .getPositionForChild(overlay, const Size(100, 60)),
      const Offset(100, 190),
    );
  });
  test('offset and RTL align from the anchor end', () {
    expect(
      delegate(
        direction: TextDirection.rtl,
        offset: const Offset(3, 7),
      ).getPositionForChild(overlay, const Size(100, 60)),
      const Offset(83, 137),
    );
  });
  test('clamps horizontal placement within padded overlay edges', () {
    expect(
      delegate(
        rect: const Rect.fromLTWH(390, 100, 10, 30),
        style: const MenuStyle(edgePadding: EdgeInsets.all(12)),
      ).getPositionForChild(overlay, const Size(100, 60)),
      const Offset(288, 130),
    );
  });
  test('minimum anchor width and explicit size constraints are respected', () {
    expect(delegate().getConstraintsForChild(bounds).minWidth, 80);
    expect(delegate(match: false).getConstraintsForChild(bounds).minWidth, 0);
    final BoxConstraints result = delegate(
      style: const MenuStyle(
        minimumSize: Size(90, 25),
        maximumSize: Size(150, 120),
      ),
    ).getConstraintsForChild(bounds);
    expect(
      result,
      const BoxConstraints(
        minWidth: 90,
        minHeight: 25,
        maxWidth: 150,
        maxHeight: 120,
      ),
    );
  });
  test(
    'widget maximum height overrides style and still fits available space',
    () {
      expect(
        delegate(
          style: const MenuStyle(maximumSize: Size(200, 20)),
          maxHeight: 50,
        ).getConstraintsForChild(bounds).maxHeight,
        50,
      );
      expect(
        delegate(maxHeight: 1000).getConstraintsForChild(bounds).maxHeight,
        170,
      );
    },
  );
  test('oversized minima are constrained to available padded overlay', () {
    final BoxConstraints result = delegate(
      style: const MenuStyle(
        minimumSize: Size(1000, 1000),
        edgePadding: EdgeInsets.all(10),
      ),
    ).getConstraintsForChild(bounds);
    expect(result.maxWidth, 380);
    expect(result.minWidth, 380);
    expect(result.minHeight, result.maxHeight);
    expect(result.isNormalized, isTrue);
  });
  test('geometry, direction and token changes trigger relayout', () {
    expect(delegate().shouldRelayout(delegate()), isFalse);
    expect(
      delegate(direction: TextDirection.rtl).shouldRelayout(delegate()),
      isTrue,
    );
    expect(delegate(maxHeight: 20).shouldRelayout(delegate()), isTrue);
  });
}
