import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/src/overlay/overlay_placement.dart';

void main() {
  const Size overlay = Size(400, 300);
  const Rect anchor = Rect.fromLTWH(100, 100, 80, 30);

  OverlayPlacementResult place({
    Rect anchorRect = anchor,
    Size childSize = const Size(100, 60),
    Size overlaySize = overlay,
    TextDirection direction = TextDirection.ltr,
    OverlayPlacement placement = const OverlayPlacement(),
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets viewInsets = EdgeInsets.zero,
  }) => resolvePlacement(
    anchorRect: anchorRect,
    overlaySize: overlaySize,
    childSize: childSize,
    textDirection: direction,
    placement: placement,
    padding: padding,
    viewInsets: viewInsets,
  );

  test('all four sides attach with a gap', () {
    const Map<AxisDirection, Offset> positions = <AxisDirection, Offset>{
      AxisDirection.down: Offset(100, 137),
      AxisDirection.up: Offset(100, 33),
      AxisDirection.right: Offset(187, 100),
      AxisDirection.left: Offset(0, 100),
    };
    for (final MapEntry<AxisDirection, Offset> entry in positions.entries) {
      final OverlayPlacementResult result = place(
        placement: OverlayPlacement(
          preferredSide: entry.key,
          gap: 7,
          flip: OverlayFlip.none,
        ),
      );
      expect(result.rect.topLeft, entry.value);
      expect(result.side, entry.key);
    }
  });

  test('start and end alignment and cross offsets mirror in RTL', () {
    for (final OverlayAlignment alignment in OverlayAlignment.values) {
      final OverlayPlacement placement = OverlayPlacement(
        alignment: alignment,
        crossOffset: 4,
      );
      expect(place(placement: placement).rect.left, switch (alignment) {
        OverlayAlignment.start => 104,
        OverlayAlignment.center => 94,
        OverlayAlignment.end => 84,
      });
      expect(
        place(placement: placement, direction: TextDirection.rtl).rect.left,
        switch (alignment) {
          OverlayAlignment.start => 76,
          OverlayAlignment.center => 86,
          OverlayAlignment.end => 96,
        },
      );
    }
  });

  test('horizontal-side alignment follows the vertical cross axis', () {
    final OverlayPlacementResult result = place(
      direction: TextDirection.rtl,
      placement: const OverlayPlacement(
        preferredSide: AxisDirection.right,
        alignment: OverlayAlignment.end,
        crossOffset: 4,
      ),
    );
    expect(result.rect.topLeft, const Offset(180, 74));
  });

  test('cover anchor uses the near edge on either chosen side', () {
    expect(
      place(placement: const OverlayPlacement(coverAnchor: true)).rect.top,
      100,
    );
    expect(
      place(
        placement: const OverlayPlacement(
          preferredSide: AxisDirection.up,
          coverAnchor: true,
        ),
      ).rect.bottom,
      130,
    );
  });

  test('ifNeeded keeps the preferred side while the panel fits', () {
    expect(
      place(anchorRect: const Rect.fromLTWH(100, 180, 80, 30)).side,
      AxisDirection.down,
    );
  });

  test('ifNeeded flips with the gap facing away from the anchor', () {
    final OverlayPlacementResult result = place(
      anchorRect: const Rect.fromLTWH(100, 250, 80, 30),
      placement: const OverlayPlacement(gap: 8),
    );
    expect(result.side, AxisDirection.up);
    expect(result.rect.bottom, 242);
    expect(result.rect.size, const Size(100, 60));
  });

  test('toLargerSide flips even when the preferred side can fit', () {
    expect(
      place(
        anchorRect: const Rect.fromLTWH(100, 180, 80, 30),
        placement: const OverlayPlacement(flip: OverlayFlip.toLargerSide),
      ).side,
      AxisDirection.up,
    );
  });

  test('none keeps the preferred side and shrink uses only that side', () {
    final OverlayPlacementResult result = place(
      anchorRect: const Rect.fromLTWH(100, 250, 80, 30),
      placement: const OverlayPlacement(flip: OverlayFlip.none, gap: 8),
    );
    expect(result.side, AxisDirection.down);
    expect(result.rect, const Rect.fromLTWH(100, 288, 100, 12));
  });

  test('shift retains size and moves a panel into the available viewport', () {
    final OverlayPlacementResult result = place(
      anchorRect: const Rect.fromLTWH(390, 250, 10, 30),
      placement: const OverlayPlacement(
        flip: OverlayFlip.none,
        overflow: OverlayOverflow.shift,
        margin: EdgeInsets.all(10),
      ),
    );
    expect(result.rect, const Rect.fromLTWH(290, 230, 100, 60));
  });

  test('keepSize retains the anchor attachment even beyond the viewport', () {
    final OverlayPlacementResult result = place(
      anchorRect: const Rect.fromLTWH(390, 250, 10, 30),
      placement: const OverlayPlacement(
        flip: OverlayFlip.none,
        overflow: OverlayOverflow.keepSize,
        margin: EdgeInsets.all(10),
      ),
    );
    expect(result.rect, const Rect.fromLTWH(290, 280, 100, 60));
  });

  test('safe padding and keyboard use their union plus directional margin', () {
    final OverlayPlacementResult result = place(
      anchorRect: const Rect.fromLTWH(0, 250, 10, 20),
      childSize: const Size(500, 300),
      padding: const EdgeInsets.fromLTRB(12, 20, 15, 30),
      viewInsets: const EdgeInsets.only(bottom: 100),
      placement: const OverlayPlacement(
        margin: EdgeInsetsDirectional.fromSTEB(8, 5, 3, 7),
      ),
    );
    expect(result.side, AxisDirection.up);
    expect(result.rect, const Rect.fromLTWH(20, 25, 362, 168));
    final OverlayPlacementResult rtl = place(
      anchorRect: const Rect.fromLTWH(0, 250, 10, 20),
      childSize: const Size(500, 300),
      direction: TextDirection.rtl,
      padding: const EdgeInsets.fromLTRB(12, 20, 15, 30),
      viewInsets: const EdgeInsets.only(bottom: 100),
      placement: const OverlayPlacement(
        margin: EdgeInsetsDirectional.fromSTEB(8, 5, 3, 7),
      ),
    );
    expect(rtl.rect.left, 15);
    expect(rtl.rect.right, 377);
  });

  test('explicit constraints apply before anchor minimum and exact width', () {
    const OverlayPlacement base = OverlayPlacement(
      constraints: BoxConstraints(minWidth: 30, maxWidth: 120, maxHeight: 50),
    );
    expect(place(placement: base).rect.size, const Size(100, 50));
    expect(
      place(
        childSize: const Size(20, 20),
        placement: base.copyWith(anchorWidth: OverlayAnchorWidth.min),
      ).rect.width,
      80,
    );
    expect(
      place(placement: base.copyWith(anchorWidth: OverlayAnchorWidth.exact))
          .rect
          .width,
      80,
    );
    expect(
      place(
        anchorRect: const Rect.fromLTWH(10, 10, 200, 20),
        placement: base.copyWith(anchorWidth: OverlayAnchorWidth.exact),
      ).rect.width,
      120,
    );
  });

  test('shrink normalizes oversized minimum constraints and zero bounds', () {
    final OverlayPlacementResult result = place(
      overlaySize: const Size(20, 20),
      placement: const OverlayPlacement(
        margin: EdgeInsets.all(20),
        constraints: BoxConstraints(minWidth: 1000, minHeight: 1000),
      ),
    );
    expect(result.rect.size, Size.zero);
    const OverlayPositionDelegate delegate = OverlayPositionDelegate(
      anchorRect: anchor,
      textDirection: TextDirection.ltr,
      placement: OverlayPlacement(
        margin: EdgeInsets.all(20),
        constraints: BoxConstraints(minWidth: 1000, minHeight: 1000),
      ),
    );
    expect(
      delegate.getConstraintsForChild(
        const BoxConstraints.tightFor(width: 20, height: 20),
      ),
      BoxConstraints.tight(Size.zero),
    );
  });

  test('delegate constraints and final geometry agree after flipping', () {
    const OverlayPositionDelegate delegate = OverlayPositionDelegate(
      anchorRect: Rect.fromLTWH(100, 250, 80, 30),
      textDirection: TextDirection.ltr,
      placement: OverlayPlacement(gap: 8),
    );
    final BoxConstraints constraints = delegate.getConstraintsForChild(
      BoxConstraints.tight(overlay),
    );
    expect(constraints.maxHeight, 242);
    final Size child = constraints.constrain(const Size(100, 1000));
    expect(delegate.placementResult(overlay, child).rect.size, child);
    expect(delegate.getPositionForChild(overlay, child), const Offset(100, 0));
  });

  test('placement value equality includes every token', () {
    const OverlayPlacement base = OverlayPlacement();
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    final List<OverlayPlacement> changes = <OverlayPlacement>[
      base.copyWith(preferredSide: AxisDirection.up),
      base.copyWith(alignment: OverlayAlignment.center),
      base.copyWith(coverAnchor: true),
      base.copyWith(gap: 4),
      base.copyWith(crossOffset: 3),
      base.copyWith(flip: OverlayFlip.none),
      base.copyWith(overflow: OverlayOverflow.shift),
      base.copyWith(margin: const EdgeInsets.all(3)),
      base.copyWith(constraints: const BoxConstraints(maxWidth: 100)),
      base.copyWith(anchorWidth: OverlayAnchorWidth.exact),
    ];
    for (final OverlayPlacement change in changes) {
      expect(change, isNot(base));
    }
    expect(base.toString(), contains('anchorWidth: OverlayAnchorWidth.none'));
  });
}
