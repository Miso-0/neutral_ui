import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neutral_ui/neutral_ui.dart' as ui;
import 'package:neutral_ui/src/foundation/animated_surface.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ui.ThemeData theme = const ui.ThemeData(),
}) async {
  await tester.pumpWidget(
    ui.NeutralApp(
      color: const Color(0xFFFFFFFF),
      theme: theme,
      home: Center(child: SizedBox(width: 500, child: child)),
    ),
  );
  await tester.pump();
}

const List<ui.DataTableColumn> _columns = <ui.DataTableColumn>[
  ui.DataTableColumn(header: Text('Name'), sortable: true),
  ui.DataTableColumn(header: Text('Age')),
];
const List<ui.DataTableRow> _rows = <ui.DataTableRow>[
  ui.DataTableRow(cells: <Widget>[Text('Alice'), Text('28')]),
  ui.DataTableRow(cells: <Widget>[Text('Bob'), Text('34')]),
];

void main() {
  testWidgets(
    'renders, sorts and activates a header by keyboard without Material',
    (WidgetTester tester) async {
      final List<int> sorted = <int>[];
      await _pump(
        tester,
        ui.DataTable(
          columns: _columns,
          rows: _rows,
          sortColumnIndex: 0,
          onSort: sorted.add,
        ),
      );
      expect(find.text('Alice'), findsOneWidget);
      expect(
        tester.widget<ui.ArrowGlyph>(find.byType(ui.ArrowGlyph)).direction,
        ui.GlyphDirection.up,
      );
      await tester.tap(find.text('Name'));
      expect(sorted, <int>[0]);
      Focus.of(tester.element(find.text('Name'))).requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(sorted, <int>[0, 0]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'row checkboxes and indeterminate select-all work independently of row taps',
    (WidgetTester tester) async {
      final List<bool?> selections = <bool?>[];
      final List<int> changed = <int>[];
      int taps = 0;
      await _pump(
        tester,
        ui.DataTable(
          columns: _columns,
          rows: _rows,
          showCheckboxes: true,
          onSelectAll: selections.add,
          onRowSelected: changed.add,
          onRowTap: (int index) => taps++,
        ),
      );
      Finder checkboxes() => find.byType(ui.Checkbox);
      await tester.tap(checkboxes().at(1));
      await tester.pumpAndSettle();
      expect(changed, <int>[0]);
      expect(tester.widget<ui.Checkbox>(checkboxes().first).value, isNull);
      await tester.tap(checkboxes().first);
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<ui.Checkbox>(checkboxes())
            .every((ui.Checkbox c) => c.value == true),
        isTrue,
      );
      await tester.tap(checkboxes().first);
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<ui.Checkbox>(checkboxes())
            .every((ui.Checkbox c) => c.value == false),
        isTrue,
      );
      expect(selections, <bool?>[true, false]);
      expect(taps, 0);
    },
  );

  testWidgets('nested expansion paths do not share parent selection', (
    WidgetTester tester,
  ) async {
    final List<String> expanded = <String>[];
    await _pump(
      tester,
      ui.DataTable(
        columns: _columns,
        rows: const <ui.DataTableRow>[
          ui.DataTableRow(
            cells: <Widget>[Text('Parent'), Text('1')],
            children: <ui.DataTableRow>[
              ui.DataTableRow(
                cells: <Widget>[Text('Child'), Text('2')],
                children: <ui.DataTableRow>[
                  ui.DataTableRow(
                    cells: <Widget>[Text('Grandchild'), Text('3')],
                  ),
                ],
              ),
            ],
          ),
        ],
        selectedRows: const <int>{0},
        showCheckboxes: true,
        onRowExpanded: expanded.add,
      ),
    );
    await tester.tap(find.byType(ui.ChevronGlyph).first);
    await tester.pumpAndSettle();
    expect(find.text('Child'), findsOneWidget);
    expect(find.byType(ui.Checkbox), findsNWidgets(2));
    await tester.tap(find.byType(ui.ChevronGlyph).last);
    await tester.pumpAndSettle();
    expect(find.text('Grandchild'), findsOneWidget);
    expect(expanded, <String>['0', '0.0']);
    expect(
      tester
          .widgetList<ui.Checkbox>(find.byType(ui.Checkbox))
          .every((ui.Checkbox c) => c.value == true),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'group headers span the table and rowBuilder wraps each data row',
    (WidgetTester tester) async {
      final List<int> wrapped = <int>[];
      final List<int> toggled = <int>[];
      const Key groupKey = ValueKey<String>('group-content');
      await _pump(
        tester,
        ui.DataTable(
          columns: const <ui.DataTableColumn>[
            ui.DataTableColumn(
              header: Text('Name'),
              width: FixedColumnWidth(80),
            ),
            ui.DataTableColumn(header: Text('Age')),
          ],
          rows: _rows,
          groups: const <ui.DataTableGroup>[
            ui.DataTableGroup(
              header: Text('People'),
              startIndex: 0,
              endIndex: 1,
              collapsible: true,
            ),
          ],
          groupHeaderBuilder: (
            BuildContext context,
            ui.DataTableGroup group,
            int index,
          ) => const SizedBox(key: groupKey, height: 30, child: Text('People')),
          rowBuilder:
              (
                BuildContext context,
                ui.DataTableRow row,
                int index,
                Widget child,
              ) {
                wrapped.add(index);
                return DecoratedBox(
                  key: ValueKey<String>('row-$index'),
                  decoration: const BoxDecoration(),
                  child: child,
                );
              },
          onGroupToggled: toggled.add,
        ),
      );
      expect(tester.getSize(find.byKey(groupKey)).width, 500);
      expect(wrapped, <int>[0, 1]);
      expect(find.byKey(const ValueKey<String>('row-1')), findsOneWidget);
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsNothing);
      expect(toggled, <int>[0]);
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'intrinsic columns stay aligned across spanning expansion and row wrappers',
    (WidgetTester tester) async {
      const Key detailKey = ValueKey<String>('detail');
      await _pump(
        tester,
        ui.DataTable(
          columns: const <ui.DataTableColumn>[
            ui.DataTableColumn(
              header: Text('N'),
              width: IntrinsicColumnWidth(),
            ),
            ui.DataTableColumn(header: Text('Header second')),
          ],
          rows: const <ui.DataTableRow>[
            ui.DataTableRow(cells: <Widget>[Text('A'), Text('First second')]),
            ui.DataTableRow(
              cells: <Widget>[Text('A much longer name'), Text('Last second')],
            ),
          ],
          expandedRows: const <String>{'0'},
          expandedRowChildBuilder: (
            BuildContext context,
            ui.DataTableRow row,
            int index,
          ) => index == 0 ? const SizedBox(key: detailKey, height: 30) : null,
          rowBuilder: (
            BuildContext context,
            ui.DataTableRow row,
            int index,
            Widget child,
          ) => child,
        ),
      );
      expect(tester.getSize(find.byKey(detailKey)).width, 500);
      final double x = tester.getTopLeft(find.text('Header second')).dx;
      expect(tester.getTopLeft(find.text('First second')).dx, x);
      expect(tester.getTopLeft(find.text('Last second')).dx, x);
      await tester.tap(find.byType(ui.ChevronGlyph).first);
      await tester.pumpAndSettle();
      expect(find.byKey(detailKey), findsNothing);
      expect(
        tester.getTopLeft(find.text('First second')).dx,
        tester.getTopLeft(find.text('Last second')).dx,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('intrinsic widths update when a cell rebuilds independently', (
    WidgetTester tester,
  ) async {
    final ValueNotifier<String> name = ValueNotifier<String>('A');
    addTearDown(name.dispose);
    await _pump(
      tester,
      ui.DataTable(
        columns: const <ui.DataTableColumn>[
          ui.DataTableColumn(header: Text('N'), width: IntrinsicColumnWidth()),
          ui.DataTableColumn(header: Text('Second header')),
        ],
        rows: <ui.DataTableRow>[
          ui.DataTableRow(
            cells: <Widget>[
              ValueListenableBuilder<String>(
                valueListenable: name,
                builder: (BuildContext context, String value, Widget? child) =>
                    Text(value),
              ),
              const Text('Second cell'),
            ],
          ),
        ],
      ),
    );
    name.value = 'A considerably longer name';
    await tester.pumpAndSettle();
    expect(
      tester.getTopLeft(find.text('Second cell')).dx,
      tester.getTopLeft(find.text('Second header')).dx,
    );
  });

  testWidgets('row borders and dividers preserve shared column geometry', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      ui.DataTable(
        columns: _columns,
        rows: _rows,
        rowDivider: const BorderSide(width: 3),
        style: ui.DataTableStyle(
          rowDecoration: BoxDecoration(border: Border.all(width: 4)),
          alternateRowDecoration: BoxDecoration(border: Border.all(width: 8)),
        ),
      ),
    );
    expect(
      tester.getTopLeft(find.text('28')).dx,
      tester.getTopLeft(find.text('Age')).dx,
    );
    expect(
      tester.getTopLeft(find.text('34')).dx,
      tester.getTopLeft(find.text('Age')).dx,
    );
  });

  testWidgets('hidden columns retain original data and callback indices', (
    WidgetTester tester,
  ) async {
    final List<int> sorted = <int>[];
    final List<(int, int)> tapped = <(int, int)>[];
    await _pump(
      tester,
      ui.DataTable(
        columns: const <ui.DataTableColumn>[
          ui.DataTableColumn(header: Text('Hidden'), visible: false),
          ui.DataTableColumn(header: Text('Visible'), sortable: true),
        ],
        rows: const <ui.DataTableRow>[
          ui.DataTableRow(cells: <Widget>[Text('Secret'), Text('Public')]),
        ],
        onSort: sorted.add,
        onCellTap: (int ri, int ci) => tapped.add((ri, ci)),
      ),
    );
    expect(find.text('Hidden'), findsNothing);
    expect(find.text('Secret'), findsNothing);
    await tester.tap(find.text('Visible'));
    await tester.tap(find.text('Public'));
    expect(sorted, <int>[1]);
    expect(tapped, <(int, int)>[(0, 1)]);
  });

  testWidgets(
    'inline tokens override themes and null state tokens fall through',
    (WidgetTester tester) async {
      const BoxDecoration global = BoxDecoration(color: Color(0xFF111111));
      const BoxDecoration local = BoxDecoration(color: Color(0xFF222222));
      const BoxDecoration inline = BoxDecoration(color: Color(0xFF333333));
      await _pump(
        tester,
        const ui.DataTableTheme(
          data: ui.DataTableStyle(rowDecoration: local),
          child: ui.DataTable(
            columns: _columns,
            rows: _rows,
            style: ui.DataTableStyle(rowDecoration: inline),
          ),
        ),
        theme: const ui.ThemeData(
          dataTableStyle: ui.DataTableStyle(rowDecoration: global),
        ),
      );
      expect(
        tester
            .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
            .map((AnimatedSurface w) => w.decoration),
        everyElement(inline),
      );
      await _pump(
        tester,
        const ui.DataTableTheme(
          data: ui.DataTableStyle(rowDecoration: local),
          child: ui.DataTable(
            columns: _columns,
            rows: _rows,
            style: ui.DataTableStyle(
              decoration: ui.StateProperty<Decoration?>.all(null),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
            .map((AnimatedSurface w) => w.decoration),
        everyElement(local),
      );
    },
  );

  testWidgets('state styles resolve hover and keyboard focus on rows', (
    WidgetTester tester,
  ) async {
    const BoxDecoration base = BoxDecoration(color: Color(0xFF111111));
    const BoxDecoration focus = BoxDecoration(color: Color(0xFF222222));
    const BoxDecoration hovered = BoxDecoration(color: Color(0xFF333333));
    int taps = 0;
    await _pump(
      tester,
      ui.DataTable(
        columns: _columns,
        rows: _rows,
        onRowTap: (int index) => taps++,
        style: ui.DataTableStyle(
          decoration: ui.StateProperty<Decoration?>.resolveWith(
            (ui.InteractionState state) => state.isFocused
                ? focus
                : state.isHovered
                ? hovered
                : base,
          ),
        ),
      ),
    );
    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('Alice')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<AnimatedSurface>(find.byType(AnimatedSurface).first)
          .decoration,
      hovered,
    );
    await mouse.removePointer();
    Focus.of(tester.element(find.text('Alice'))).requestFocus();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    // Tab moves from the requested row to the next row.
    expect(
      tester
          .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
          .map((AnimatedSurface w) => w.decoration),
      contains(focus),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets(
    'all text slots inherit ambient typography and row padding overrides columns',
    (WidgetTester tester) async {
      final Map<String, TextStyle> styles = <String, TextStyle>{};
      Widget slot(String id) => Builder(
        builder: (BuildContext context) {
          styles[id] = DefaultTextStyle.of(context).style;
          return SizedBox(key: ValueKey<String>(id), width: 10, height: 10);
        },
      );
      await _pump(
        tester,
        DefaultTextStyle(
          style: const TextStyle(fontSize: 23, color: Color(0xFF123456)),
          child: ui.DataTable(
            columns: <ui.DataTableColumn>[
              ui.DataTableColumn(
                header: slot('header'),
                cellPadding: const EdgeInsets.all(20),
              ),
            ],
            rows: <ui.DataTableRow>[
              ui.DataTableRow(
                cells: <Widget>[slot('cell')],
                cellPadding: const EdgeInsets.all(3),
              ),
            ],
            footerRows: <ui.DataTableRow>[
              ui.DataTableRow(cells: <Widget>[slot('footer')]),
            ],
            groups: <ui.DataTableGroup>[
              ui.DataTableGroup(
                header: slot('group'),
                startIndex: 0,
                endIndex: 0,
              ),
            ],
          ),
        ),
      );
      for (final TextStyle style in styles.values) {
        expect(style.fontSize, 23);
        expect(style.color, const Color(0xFF123456));
      }
      final Finder table = find.ancestor(
        of: find.byKey(const ValueKey<String>('cell')),
        matching: find.byType(Table),
      );
      expect(tester.getSize(table).height, 16);
    },
  );

  testWidgets(
    'empty, loading, custom builders and zero visible columns need no Material',
    (WidgetTester tester) async {
      await _pump(tester, const ui.DataTable(columns: _columns));
      expect(find.text('No data available'), findsOneWidget);
      await _pump(
        tester,
        const ui.DataTable(columns: _columns, isLoading: true),
      );
      expect(find.byType(ui.CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull);
      await _pump(
        tester,
        ui.DataTable(
          columns: _columns,
          isLoading: true,
          loadingBuilder: (BuildContext context) => const Text('Fetching'),
        ),
      );
      expect(find.text('Fetching'), findsOneWidget);
      await _pump(
        tester,
        const ui.DataTable(columns: <ui.DataTableColumn>[], rows: _rows),
      );
      expect(find.byType(Table), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'legacy inline theme and merged component themes inherit unset tokens',
    (WidgetTester tester) async {
      const BoxDecoration decoration = BoxDecoration(color: Color(0xFF123456));
      await _pump(
        tester,
        ui.DataTableTheme.merge(
          data: const ui.DataTableStyle(cellPadding: EdgeInsets.all(5)),
          child: const ui.DataTable(
            columns: _columns,
            rows: _rows,
            theme: ui.DataTableThemeData(rowDecoration: decoration),
          ),
        ),
        theme: const ui.ThemeData(
          dataTableStyle: ui.DataTableStyle(
            cellTextStyle: TextStyle(fontSize: 21),
          ),
        ),
      );
      expect(
        tester
            .widgetList<AnimatedSurface>(find.byType(AnimatedSurface))
            .map((AnimatedSurface s) => s.decoration),
        everyElement(decoration),
      );
      expect(
        DefaultTextStyle.of(tester.element(find.text('Alice'))).style.fontSize,
        21,
      );
      expect(
        tester.getTopLeft(find.text('Alice')).dx -
            tester.getTopLeft(find.byType(ui.DataTable)).dx,
        5,
      );
    },
  );

  testWidgets(
    'stateful cell content survives selection, expansion and column visibility changes',
    (WidgetTester tester) async {
      late StateSetter update;
      bool visible = true;
      await _pump(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return ui.DataTable(
              columns: <ui.DataTableColumn>[
                ui.DataTableColumn(
                  header: const Text('Other'),
                  visible: visible,
                ),
                const ui.DataTableColumn(header: Text('Counter')),
              ],
              rows: const <ui.DataTableRow>[
                ui.DataTableRow(
                  cells: <Widget>[Text('Other cell'), _CounterCell()],
                ),
              ],
              showCheckboxes: true,
              expandedRowChildBuilder: (
                BuildContext context,
                ui.DataTableRow row,
                int index,
              ) => const Text('Detail'),
            );
          },
        ),
      );
      await tester.tap(find.text('Count 0'));
      await tester.pumpAndSettle();
      expect(find.text('Count 1'), findsOneWidget);
      await tester.tap(find.byType(ui.Checkbox).last);
      await tester.pumpAndSettle();
      expect(find.text('Count 1'), findsOneWidget);
      await tester.tap(find.byType(ui.ChevronGlyph).first);
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);
      expect(find.text('Count 1'), findsOneWidget);
      update(() => visible = false);
      await tester.pumpAndSettle();
      expect(find.text('Count 1'), findsOneWidget);
    },
  );

  testWidgets(
    'supplied selection, expansion and group sets resynchronize on rebuild',
    (WidgetTester tester) async {
      late StateSetter update;
      Set<int> selected = <int>{};
      Set<String> expanded = <String>{};
      Set<int> collapsed = <int>{};
      await _pump(
        tester,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return ui.DataTable(
              columns: _columns,
              rows: _rows,
              showCheckboxes: true,
              selectedRows: selected,
              expandedRows: expanded,
              collapsedGroups: collapsed,
              groups: const <ui.DataTableGroup>[
                ui.DataTableGroup(
                  header: Text('People'),
                  startIndex: 0,
                  endIndex: 1,
                  collapsible: true,
                ),
              ],
              expandedRowChildBuilder: (
                BuildContext context,
                ui.DataTableRow row,
                int index,
              ) => index == 0 ? const Text('Detail') : null,
            );
          },
        ),
      );
      update(() {
        selected = <int>{0};
        expanded = <String>{'0'};
      });
      await tester.pumpAndSettle();
      expect(
        tester.widget<ui.Checkbox>(find.byType(ui.Checkbox).at(1)).value,
        isTrue,
      );
      expect(find.text('Detail'), findsOneWidget);
      update(() => collapsed = <int>{0});
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsNothing);
      expect(find.text('Detail'), findsNothing);
      update(() {
        collapsed = <int>{};
        expanded = <String>{};
        selected = <int>{};
      });
      await tester.pumpAndSettle();
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Detail'), findsNothing);
      expect(
        tester.widget<ui.Checkbox>(find.byType(ui.Checkbox).at(1)).value,
        isFalse,
      );
    },
  );

  test('central table styles copy, merge and participate in equality', () {
    const ui.DataTableStyle style = ui.DataTableStyle(
      cellPadding: EdgeInsets.all(4),
    );
    const ui.ThemeData theme = ui.ThemeData(dataTableStyle: style);
    expect(const ui.ThemeData().copyWith(dataTableStyle: style), theme);
    expect(theme.copyWith(), theme);
    expect(theme.hashCode, theme.copyWith().hashCode);
    expect(
      theme
          .merge(
            const ui.ThemeData(
              dataTableStyle: ui.DataTableStyle(
                headerCellPadding: EdgeInsets.all(8),
              ),
            ),
          )
          .dataTableStyle,
      const ui.DataTableStyle(
        cellPadding: EdgeInsets.all(4),
        headerCellPadding: EdgeInsets.all(8),
      ),
    );
  });
}

class _CounterCell extends StatefulWidget {
  const _CounterCell();

  @override
  State<_CounterCell> createState() => _CounterCellState();
}

class _CounterCellState extends State<_CounterCell> {
  int _count = 0;

  @override
  Widget build(BuildContext context) => ui.TextButton(
    onPressed: () => setState(() => _count++),
    child: Text('Count $_count'),
  );
}
