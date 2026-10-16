import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pure_ui/pure_ui.dart';

const Widget _selectedIcon = Text('Selected');
const Widget _deleteIcon = Text('Delete');

void main() {
  test(
    'ChipStyle.buttonStyle copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(buttonStyle: ButtonStyle(spacing: 3));
      expect(
        const ChipStyle().copyWith(buttonStyle: ButtonStyle(spacing: 3)),
        style,
      );
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const ChipStyle()
            .copyWith(buttonStyle: ButtonStyle(spacing: 3))
            .hashCode,
      );
      expect(style.toString(), contains('buttonStyle:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test('ChipStyle.deleteButtonStyle copies, inherits, compares and reports its token', () {
    const ChipStyle style = ChipStyle(
      deleteButtonStyle: ButtonStyle(spacing: 4),
    );
    expect(
      const ChipStyle().copyWith(deleteButtonStyle: ButtonStyle(spacing: 4)),
      style,
    );
    expect(const ChipStyle().merge(style), style);
    expect(style.merge(const ChipStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ChipStyle()
          .copyWith(deleteButtonStyle: ButtonStyle(spacing: 4))
          .hashCode,
    );
    expect(style.toString(), contains('deleteButtonStyle:'));
    expect(style, isNot(const ChipStyle()));
  });
  test(
    'ChipStyle.avatarSize copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(avatarSize: 21.0);
      expect(const ChipStyle().copyWith(avatarSize: 21.0), style);
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const ChipStyle().copyWith(avatarSize: 21.0).hashCode,
      );
      expect(style.toString(), contains('avatarSize:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test(
    'ChipStyle.spacing copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(spacing: 7.0);
      expect(const ChipStyle().copyWith(spacing: 7.0), style);
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(style.hashCode, const ChipStyle().copyWith(spacing: 7.0).hashCode);
      expect(style.toString(), contains('spacing:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test(
    'ChipStyle.selectedIcon copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(
        selectedIcon: StateProperty<Widget?>.all(_selectedIcon),
      );
      expect(
        const ChipStyle().copyWith(
          selectedIcon: StateProperty<Widget?>.all(_selectedIcon),
        ),
        style,
      );
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const ChipStyle()
            .copyWith(selectedIcon: StateProperty<Widget?>.all(_selectedIcon))
            .hashCode,
      );
      expect(style.toString(), contains('selectedIcon:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test(
    'ChipStyle.deleteIcon copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(
        deleteIcon: StateProperty<Widget?>.all(_deleteIcon),
      );
      expect(
        const ChipStyle().copyWith(
          deleteIcon: StateProperty<Widget?>.all(_deleteIcon),
        ),
        style,
      );
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const ChipStyle()
            .copyWith(deleteIcon: StateProperty<Widget?>.all(_deleteIcon))
            .hashCode,
      );
      expect(style.toString(), contains('deleteIcon:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test('ChipStyle.animationDuration copies, inherits, compares and reports its token', () {
    const ChipStyle style = ChipStyle(
      animationDuration: Duration(milliseconds: 120),
    );
    expect(
      const ChipStyle().copyWith(
        animationDuration: Duration(milliseconds: 120),
      ),
      style,
    );
    expect(const ChipStyle().merge(style), style);
    expect(style.merge(const ChipStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ChipStyle()
          .copyWith(animationDuration: Duration(milliseconds: 120))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const ChipStyle()));
  });
  test(
    'ChipStyle.animationCurve copies, inherits, compares and reports its token',
    () {
      const ChipStyle style = ChipStyle(animationCurve: Curves.linear);
      expect(const ChipStyle().copyWith(animationCurve: Curves.linear), style);
      expect(const ChipStyle().merge(style), style);
      expect(style.merge(const ChipStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const ChipStyle().copyWith(animationCurve: Curves.linear).hashCode,
      );
      expect(style.toString(), contains('animationCurve:'));
      expect(style, isNot(const ChipStyle()));
    },
  );
  test(
    'TabBarStyle.tabStyle copies, inherits, compares and reports its token',
    () {
      const TabBarStyle style = TabBarStyle(tabStyle: ButtonStyle(spacing: 3));
      expect(
        const TabBarStyle().copyWith(tabStyle: ButtonStyle(spacing: 3)),
        style,
      );
      expect(const TabBarStyle().merge(style), style);
      expect(style.merge(const TabBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const TabBarStyle()
            .copyWith(tabStyle: ButtonStyle(spacing: 3))
            .hashCode,
      );
      expect(style.toString(), contains('tabStyle:'));
      expect(style, isNot(const TabBarStyle()));
    },
  );
  test('TabBarStyle.indicatorDecoration copies, inherits, compares and reports its token', () {
    const TabBarStyle style = TabBarStyle(
      indicatorDecoration: StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xff123456)),
      ),
    );
    expect(
      const TabBarStyle().copyWith(
        indicatorDecoration: StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xff123456)),
        ),
      ),
      style,
    );
    expect(const TabBarStyle().merge(style), style);
    expect(style.merge(const TabBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const TabBarStyle()
          .copyWith(
            indicatorDecoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: Color(0xff123456)),
            ),
          )
          .hashCode,
    );
    expect(style.toString(), contains('indicatorDecoration:'));
    expect(style, isNot(const TabBarStyle()));
  });
  test(
    'TabBarStyle.labelPadding copies, inherits, compares and reports its token',
    () {
      const TabBarStyle style = TabBarStyle(labelPadding: EdgeInsets.all(2));
      expect(
        const TabBarStyle().copyWith(labelPadding: EdgeInsets.all(2)),
        style,
      );
      expect(const TabBarStyle().merge(style), style);
      expect(style.merge(const TabBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const TabBarStyle().copyWith(labelPadding: EdgeInsets.all(2)).hashCode,
      );
      expect(style.toString(), contains('labelPadding:'));
      expect(style, isNot(const TabBarStyle()));
    },
  );
  test(
    'TabBarStyle.padding copies, inherits, compares and reports its token',
    () {
      const TabBarStyle style = TabBarStyle(padding: EdgeInsets.all(3));
      expect(const TabBarStyle().copyWith(padding: EdgeInsets.all(3)), style);
      expect(const TabBarStyle().merge(style), style);
      expect(style.merge(const TabBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const TabBarStyle().copyWith(padding: EdgeInsets.all(3)).hashCode,
      );
      expect(style.toString(), contains('padding:'));
      expect(style, isNot(const TabBarStyle()));
    },
  );
  test('TabBarStyle.indicatorPadding copies, inherits, compares and reports its token', () {
    const TabBarStyle style = TabBarStyle(indicatorPadding: EdgeInsets.all(1));
    expect(
      const TabBarStyle().copyWith(indicatorPadding: EdgeInsets.all(1)),
      style,
    );
    expect(const TabBarStyle().merge(style), style);
    expect(style.merge(const TabBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const TabBarStyle()
          .copyWith(indicatorPadding: EdgeInsets.all(1))
          .hashCode,
    );
    expect(style.toString(), contains('indicatorPadding:'));
    expect(style, isNot(const TabBarStyle()));
  });
  test('TabBarStyle.indicatorWeight copies, inherits, compares and reports its token', () {
    const TabBarStyle style = TabBarStyle(indicatorWeight: 3.0);
    expect(const TabBarStyle().copyWith(indicatorWeight: 3.0), style);
    expect(const TabBarStyle().merge(style), style);
    expect(style.merge(const TabBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const TabBarStyle().copyWith(indicatorWeight: 3.0).hashCode,
    );
    expect(style.toString(), contains('indicatorWeight:'));
    expect(style, isNot(const TabBarStyle()));
  });
  test(
    'TabBarStyle.spacing copies, inherits, compares and reports its token',
    () {
      const TabBarStyle style = TabBarStyle(spacing: 2.0);
      expect(const TabBarStyle().copyWith(spacing: 2.0), style);
      expect(const TabBarStyle().merge(style), style);
      expect(style.merge(const TabBarStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const TabBarStyle().copyWith(spacing: 2.0).hashCode,
      );
      expect(style.toString(), contains('spacing:'));
      expect(style, isNot(const TabBarStyle()));
    },
  );
  test('TabBarStyle.animationDuration copies, inherits, compares and reports its token', () {
    const TabBarStyle style = TabBarStyle(
      animationDuration: Duration(milliseconds: 130),
    );
    expect(
      const TabBarStyle().copyWith(
        animationDuration: Duration(milliseconds: 130),
      ),
      style,
    );
    expect(const TabBarStyle().merge(style), style);
    expect(style.merge(const TabBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const TabBarStyle()
          .copyWith(animationDuration: Duration(milliseconds: 130))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const TabBarStyle()));
  });
  test('TabBarStyle.animationCurve copies, inherits, compares and reports its token', () {
    const TabBarStyle style = TabBarStyle(animationCurve: Curves.linear);
    expect(const TabBarStyle().copyWith(animationCurve: Curves.linear), style);
    expect(const TabBarStyle().merge(style), style);
    expect(style.merge(const TabBarStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const TabBarStyle().copyWith(animationCurve: Curves.linear).hashCode,
    );
    expect(style.toString(), contains('animationCurve:'));
    expect(style, isNot(const TabBarStyle()));
  });
  test('NavigationStyle.destinationStyle copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      destinationStyle: ButtonStyle(spacing: 3),
    );
    expect(
      const NavigationStyle().copyWith(
        destinationStyle: ButtonStyle(spacing: 3),
      ),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(destinationStyle: ButtonStyle(spacing: 3))
          .hashCode,
    );
    expect(style.toString(), contains('destinationStyle:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('NavigationStyle.indicatorDecoration copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      indicatorDecoration: StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xff123456)),
      ),
    );
    expect(
      const NavigationStyle().copyWith(
        indicatorDecoration: StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xff123456)),
        ),
      ),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(
            indicatorDecoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: Color(0xff123456)),
            ),
          )
          .hashCode,
    );
    expect(style.toString(), contains('indicatorDecoration:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('NavigationStyle.labelStyle copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      labelStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
    );
    expect(
      const NavigationStyle().copyWith(
        labelStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
      ),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(
            labelStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
          )
          .hashCode,
    );
    expect(style.toString(), contains('labelStyle:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('NavigationStyle.iconTheme copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      iconTheme: StateProperty<IconThemeData?>.all(IconThemeData(size: 19)),
    );
    expect(
      const NavigationStyle().copyWith(
        iconTheme: StateProperty<IconThemeData?>.all(IconThemeData(size: 19)),
      ),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(
            iconTheme: StateProperty<IconThemeData?>.all(
              IconThemeData(size: 19),
            ),
          )
          .hashCode,
    );
    expect(style.toString(), contains('iconTheme:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test(
    'NavigationStyle.padding copies, inherits, compares and reports its token',
    () {
      const NavigationStyle style = NavigationStyle(padding: EdgeInsets.all(3));
      expect(
        const NavigationStyle().copyWith(padding: EdgeInsets.all(3)),
        style,
      );
      expect(const NavigationStyle().merge(style), style);
      expect(style.merge(const NavigationStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const NavigationStyle().copyWith(padding: EdgeInsets.all(3)).hashCode,
      );
      expect(style.toString(), contains('padding:'));
      expect(style, isNot(const NavigationStyle()));
    },
  );
  test('NavigationStyle.indicatorPadding copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      indicatorPadding: EdgeInsets.all(2),
    );
    expect(
      const NavigationStyle().copyWith(indicatorPadding: EdgeInsets.all(2)),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(indicatorPadding: EdgeInsets.all(2))
          .hashCode,
    );
    expect(style.toString(), contains('indicatorPadding:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('NavigationStyle.indicatorSize copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(indicatorSize: Size(30, 20));
    expect(
      const NavigationStyle().copyWith(indicatorSize: Size(30, 20)),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle().copyWith(indicatorSize: Size(30, 20)).hashCode,
    );
    expect(style.toString(), contains('indicatorSize:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test(
    'NavigationStyle.spacing copies, inherits, compares and reports its token',
    () {
      const NavigationStyle style = NavigationStyle(spacing: 5.0);
      expect(const NavigationStyle().copyWith(spacing: 5.0), style);
      expect(const NavigationStyle().merge(style), style);
      expect(style.merge(const NavigationStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const NavigationStyle().copyWith(spacing: 5.0).hashCode,
      );
      expect(style.toString(), contains('spacing:'));
      expect(style, isNot(const NavigationStyle()));
    },
  );
  test('NavigationStyle.animationDuration copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      animationDuration: Duration(milliseconds: 120),
    );
    expect(
      const NavigationStyle().copyWith(
        animationDuration: Duration(milliseconds: 120),
      ),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle()
          .copyWith(animationDuration: Duration(milliseconds: 120))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('NavigationStyle.animationCurve copies, inherits, compares and reports its token', () {
    const NavigationStyle style = NavigationStyle(
      animationCurve: Curves.linear,
    );
    expect(
      const NavigationStyle().copyWith(animationCurve: Curves.linear),
      style,
    );
    expect(const NavigationStyle().merge(style), style);
    expect(style.merge(const NavigationStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const NavigationStyle().copyWith(animationCurve: Curves.linear).hashCode,
    );
    expect(style.toString(), contains('animationCurve:'));
    expect(style, isNot(const NavigationStyle()));
  });
  test('ExpansionTileStyle.tileStyle copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      tileStyle: ListTileStyle(horizontalTitleGap: 3),
    );
    expect(
      const ExpansionTileStyle().copyWith(
        tileStyle: ListTileStyle(horizontalTitleGap: 3),
      ),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(tileStyle: ListTileStyle(horizontalTitleGap: 3))
          .hashCode,
    );
    expect(style.toString(), contains('tileStyle:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.decoration copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      decoration: StateProperty<Decoration?>.all(
        BoxDecoration(color: Color(0xff123456)),
      ),
    );
    expect(
      const ExpansionTileStyle().copyWith(
        decoration: StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xff123456)),
        ),
      ),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(
            decoration: StateProperty<Decoration?>.all(
              BoxDecoration(color: Color(0xff123456)),
            ),
          )
          .hashCode,
    );
    expect(style.toString(), contains('decoration:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.padding copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      padding: EdgeInsets.all(2),
    );
    expect(
      const ExpansionTileStyle().copyWith(padding: EdgeInsets.all(2)),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle().copyWith(padding: EdgeInsets.all(2)).hashCode,
    );
    expect(style.toString(), contains('padding:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.childrenPadding copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      childrenPadding: EdgeInsets.all(3),
    );
    expect(
      const ExpansionTileStyle().copyWith(childrenPadding: EdgeInsets.all(3)),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(childrenPadding: EdgeInsets.all(3))
          .hashCode,
    );
    expect(style.toString(), contains('childrenPadding:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.expandedAlignment copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      expandedAlignment: AlignmentDirectional.centerEnd,
    );
    expect(
      const ExpansionTileStyle().copyWith(
        expandedAlignment: AlignmentDirectional.centerEnd,
      ),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(expandedAlignment: AlignmentDirectional.centerEnd)
          .hashCode,
    );
    expect(style.toString(), contains('expandedAlignment:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.expandedCrossAxisAlignment copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      expandedCrossAxisAlignment: CrossAxisAlignment.end,
    );
    expect(
      const ExpansionTileStyle().copyWith(
        expandedCrossAxisAlignment: CrossAxisAlignment.end,
      ),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(expandedCrossAxisAlignment: CrossAxisAlignment.end)
          .hashCode,
    );
    expect(style.toString(), contains('expandedCrossAxisAlignment:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.animationDuration copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      animationDuration: Duration(milliseconds: 110),
    );
    expect(
      const ExpansionTileStyle().copyWith(
        animationDuration: Duration(milliseconds: 110),
      ),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(animationDuration: Duration(milliseconds: 110))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ExpansionTileStyle.animationCurve copies, inherits, compares and reports its token', () {
    const ExpansionTileStyle style = ExpansionTileStyle(
      animationCurve: Curves.linear,
    );
    expect(
      const ExpansionTileStyle().copyWith(animationCurve: Curves.linear),
      style,
    );
    expect(const ExpansionTileStyle().merge(style), style);
    expect(style.merge(const ExpansionTileStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ExpansionTileStyle()
          .copyWith(animationCurve: Curves.linear)
          .hashCode,
    );
    expect(style.toString(), contains('animationCurve:'));
    expect(style, isNot(const ExpansionTileStyle()));
  });
  test('ProgressIndicatorStyle.color copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      color: StateProperty<Color?>.all(Color(0xff123456)),
    );
    expect(
      const ProgressIndicatorStyle().copyWith(
        color: StateProperty<Color?>.all(Color(0xff123456)),
      ),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(color: StateProperty<Color?>.all(Color(0xff123456)))
          .hashCode,
    );
    expect(style.toString(), contains('color:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.backgroundColor copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      backgroundColor: StateProperty<Color?>.all(Color(0xffabcdef)),
    );
    expect(
      const ProgressIndicatorStyle().copyWith(
        backgroundColor: StateProperty<Color?>.all(Color(0xffabcdef)),
      ),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(
            backgroundColor: StateProperty<Color?>.all(Color(0xffabcdef)),
          )
          .hashCode,
    );
    expect(style.toString(), contains('backgroundColor:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.strokeWidth copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      strokeWidth: 3.0,
    );
    expect(const ProgressIndicatorStyle().copyWith(strokeWidth: 3.0), style);
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle().copyWith(strokeWidth: 3.0).hashCode,
    );
    expect(style.toString(), contains('strokeWidth:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.strokeCap copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      strokeCap: StrokeCap.round,
    );
    expect(
      const ProgressIndicatorStyle().copyWith(strokeCap: StrokeCap.round),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(strokeCap: StrokeCap.round)
          .hashCode,
    );
    expect(style.toString(), contains('strokeCap:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.minHeight copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(minHeight: 5.0);
    expect(const ProgressIndicatorStyle().copyWith(minHeight: 5.0), style);
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle().copyWith(minHeight: 5.0).hashCode,
    );
    expect(style.toString(), contains('minHeight:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.size copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      size: Size(30, 30),
    );
    expect(const ProgressIndicatorStyle().copyWith(size: Size(30, 30)), style);
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle().copyWith(size: Size(30, 30)).hashCode,
    );
    expect(style.toString(), contains('size:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.borderRadius copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      borderRadius: BorderRadius.all(Radius.circular(3)),
    );
    expect(
      const ProgressIndicatorStyle().copyWith(
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(borderRadius: BorderRadius.all(Radius.circular(3)))
          .hashCode,
    );
    expect(style.toString(), contains('borderRadius:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.animationDuration copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      animationDuration: Duration(milliseconds: 120),
    );
    expect(
      const ProgressIndicatorStyle().copyWith(
        animationDuration: Duration(milliseconds: 120),
      ),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(animationDuration: Duration(milliseconds: 120))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.animationCurve copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      animationCurve: Curves.linear,
    );
    expect(
      const ProgressIndicatorStyle().copyWith(animationCurve: Curves.linear),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(animationCurve: Curves.linear)
          .hashCode,
    );
    expect(style.toString(), contains('animationCurve:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test('ProgressIndicatorStyle.indeterminateDuration copies, inherits, compares and reports its token', () {
    const ProgressIndicatorStyle style = ProgressIndicatorStyle(
      indeterminateDuration: Duration(milliseconds: 700),
    );
    expect(
      const ProgressIndicatorStyle().copyWith(
        indeterminateDuration: Duration(milliseconds: 700),
      ),
      style,
    );
    expect(const ProgressIndicatorStyle().merge(style), style);
    expect(style.merge(const ProgressIndicatorStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const ProgressIndicatorStyle()
          .copyWith(indeterminateDuration: Duration(milliseconds: 700))
          .hashCode,
    );
    expect(style.toString(), contains('indeterminateDuration:'));
    expect(style, isNot(const ProgressIndicatorStyle()));
  });
  test(
    'BadgeStyle.decoration copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(
        decoration: StateProperty<Decoration?>.all(
          BoxDecoration(color: Color(0xff123456)),
        ),
      );
      expect(
        const BadgeStyle().copyWith(
          decoration: StateProperty<Decoration?>.all(
            BoxDecoration(color: Color(0xff123456)),
          ),
        ),
        style,
      );
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle()
            .copyWith(
              decoration: StateProperty<Decoration?>.all(
                BoxDecoration(color: Color(0xff123456)),
              ),
            )
            .hashCode,
      );
      expect(style.toString(), contains('decoration:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.textStyle copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(
        textStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
      );
      expect(
        const BadgeStyle().copyWith(
          textStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
        ),
        style,
      );
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle()
            .copyWith(
              textStyle: StateProperty<TextStyle?>.all(TextStyle(fontSize: 19)),
            )
            .hashCode,
      );
      expect(style.toString(), contains('textStyle:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.padding copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(padding: EdgeInsets.all(2));
      expect(const BadgeStyle().copyWith(padding: EdgeInsets.all(2)), style);
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle().copyWith(padding: EdgeInsets.all(2)).hashCode,
      );
      expect(style.toString(), contains('padding:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.smallSize copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(smallSize: 8.0);
      expect(const BadgeStyle().copyWith(smallSize: 8.0), style);
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle().copyWith(smallSize: 8.0).hashCode,
      );
      expect(style.toString(), contains('smallSize:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.largeSize copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(largeSize: 18.0);
      expect(const BadgeStyle().copyWith(largeSize: 18.0), style);
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle().copyWith(largeSize: 18.0).hashCode,
      );
      expect(style.toString(), contains('largeSize:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.alignment copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(
        alignment: AlignmentDirectional.bottomStart,
      );
      expect(
        const BadgeStyle().copyWith(
          alignment: AlignmentDirectional.bottomStart,
        ),
        style,
      );
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle()
            .copyWith(alignment: AlignmentDirectional.bottomStart)
            .hashCode,
      );
      expect(style.toString(), contains('alignment:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test(
    'BadgeStyle.offset copies, inherits, compares and reports its token',
    () {
      const BadgeStyle style = BadgeStyle(offset: Offset(2, 3));
      expect(const BadgeStyle().copyWith(offset: Offset(2, 3)), style);
      expect(const BadgeStyle().merge(style), style);
      expect(style.merge(const BadgeStyle()), style);
      expect(style.merge(null), same(style));
      expect(
        style.hashCode,
        const BadgeStyle().copyWith(offset: Offset(2, 3)).hashCode,
      );
      expect(style.toString(), contains('offset:'));
      expect(style, isNot(const BadgeStyle()));
    },
  );
  test('BadgeStyle.animationDuration copies, inherits, compares and reports its token', () {
    const BadgeStyle style = BadgeStyle(
      animationDuration: Duration(milliseconds: 100),
    );
    expect(
      const BadgeStyle().copyWith(
        animationDuration: Duration(milliseconds: 100),
      ),
      style,
    );
    expect(const BadgeStyle().merge(style), style);
    expect(style.merge(const BadgeStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const BadgeStyle()
          .copyWith(animationDuration: Duration(milliseconds: 100))
          .hashCode,
    );
    expect(style.toString(), contains('animationDuration:'));
    expect(style, isNot(const BadgeStyle()));
  });
  test('BadgeStyle.animationCurve copies, inherits, compares and reports its token', () {
    const BadgeStyle style = BadgeStyle(animationCurve: Curves.linear);
    expect(const BadgeStyle().copyWith(animationCurve: Curves.linear), style);
    expect(const BadgeStyle().merge(style), style);
    expect(style.merge(const BadgeStyle()), style);
    expect(style.merge(null), same(style));
    expect(
      style.hashCode,
      const BadgeStyle().copyWith(animationCurve: Curves.linear).hashCode,
    );
    expect(style.toString(), contains('animationCurve:'));
    expect(style, isNot(const BadgeStyle()));
  });
  test('nested chip button tokens merge without losing either layer', () {
    const ChipStyle child = ChipStyle(buttonStyle: ButtonStyle(spacing: 4));
    const ChipStyle parent = ChipStyle(
      buttonStyle: ButtonStyle(tapTargetSize: Size(48, 48)),
    );
    expect(
      child.merge(parent).buttonStyle,
      const ButtonStyle(spacing: 4, tapTargetSize: Size(48, 48)),
    );
  });
  test('tab indicator builder survives copy and merge', () {
    Widget builder(BuildContext context, double position) =>
        Text(position.toString());
    final TabBarStyle style = TabBarStyle(indicatorBuilder: builder);
    expect(style.copyWith().indicatorBuilder, same(builder));
    expect(const TabBarStyle().merge(style).indicatorBuilder, same(builder));
  });
}
