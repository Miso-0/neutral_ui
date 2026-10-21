import 'package:flutter/widgets.dart';
import 'package:neutral_ui/neutral_ui.dart';

const Color _ink = Color(0xFF142C2A);
const Color _muted = Color(0xFF657B77);
const Color _accent = Color(0xFF087F6D);
const Color _canvas = Color(0xFFF4F7F3);
const Color _line = Color(0xFFCFDDD4);
const Color _white = Color(0xFFFFFFFF);

const DataTableStyle _tableStyle = DataTableStyle(
  headerDecoration: BoxDecoration(color: _canvas),
  rowDecoration: BoxDecoration(color: _white),
  alternateRowDecoration: BoxDecoration(color: Color(0xFFFAFCF9)),
  hoveredRowDecoration: BoxDecoration(color: Color(0xFFF0F5F0)),
  selectedRowDecoration: BoxDecoration(color: Color(0xFFE4F1E7)),
  footerDecoration: BoxDecoration(color: _canvas),
  expandedRowDecoration: BoxDecoration(color: Color(0xFFF0F5F0)),
  groupHeaderDecoration: BoxDecoration(color: Color(0xFFE9F2EB)),
  headerCellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  cellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
  footerCellPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 15),
  expandedRowPadding: EdgeInsets.all(18),
  groupHeaderPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
  headerCellAlignment: AlignmentDirectional.centerStart,
  cellAlignment: AlignmentDirectional.centerStart,
  headerTextStyle: TextStyle(
    color: _muted,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  cellTextStyle: TextStyle(color: _ink, fontSize: 13),
  footerTextStyle: TextStyle(
    color: _ink,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
  groupHeaderTextStyle: TextStyle(
    color: _accent,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  ),
  sortIconColor: _accent,
);

/// Interactive table examples using the gallery's shared control themes.
class TableSection extends StatefulWidget {
  /// Creates the gallery's table section.
  const TableSection({super.key});

  @override
  State<TableSection> createState() => _TableSectionState();
}

class _TableSectionState extends State<TableSection> {
  final Set<String> _selectedProjectIds = <String>{};
  final Set<String> _expandedProjectIds = <String>{};
  final Set<String> _expandedWorkstreams = <String>{};
  final Set<int> _collapsedGroups = <int>{1};
  int _sortColumn = 0;
  bool _sortAscending = true;

  static const List<_Project> _projects = <_Project>[
    _Project(
      id: 'atlas',
      name: 'Atlas website',
      owner: 'Alex Morgan',
      status: 'In progress',
      budget: 42000,
      detail: 'A refreshed home for the brand, from discovery to launch.',
      milestone: 'Next milestone: Design review · 24 Oct',
    ),
    _Project(
      id: 'beacon',
      name: 'Beacon mobile',
      owner: 'Sam Patel',
      status: 'Review',
      budget: 28000,
      detail: 'A focused mobile experience for customers on the move.',
      milestone: 'Next milestone: Usability testing · 28 Oct',
    ),
    _Project(
      id: 'canopy',
      name: 'Canopy platform',
      owner: 'Jordan Lee',
      status: 'In progress',
      budget: 56000,
      detail: 'A shared workspace that brings people, projects and reporting together.',
      milestone: 'Next milestone: Platform beta · 04 Nov',
    ),
    _Project(
      id: 'delta',
      name: 'Delta research',
      owner: 'Robin Chen',
      status: 'Complete',
      budget: 22000,
      detail:
          'Customer interviews and findings to guide the next product cycle.',
      milestone: 'Latest milestone: Research report delivered',
    ),
  ];

  List<_Project> get _sortedProjects =>
      List<_Project>.of(_projects)..sort((_Project a, _Project b) {
        final int order = switch (_sortColumn) {
          1 => a.owner.compareTo(b.owner),
          3 => a.budget.compareTo(b.budget),
          _ => a.name.compareTo(b.name),
        };
        return _sortAscending ? order : -order;
      });

  void _toggle<T>(Set<T> values, T value) {
    if (!values.remove(value)) values.add(value);
  }

  String _money(int value) => '\$${value ~/ 1000},000';

  Widget _status(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: label == 'Review'
          ? const Color(0xFFF4EDDC)
          : label == 'Complete'
          ? const Color(0xFFE4F1E7)
          : const Color(0xFFEAF0F6),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: label == 'Review'
            ? const Color(0xFF82632C)
            : label == 'Complete'
            ? _accent
            : const Color(0xFF3C627E),
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _scrollableTable({required double minWidth, required Widget child}) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth < minWidth
                      ? minWidth
                      : constraints.maxWidth,
                  child: child,
                ),
              ),
        ),
      );

  Widget _projectTable() {
    final List<_Project> projects = _sortedProjects;
    return _scrollableTable(
      minWidth: 780,
      child: DataTable(
        key: const ValueKey<String>('table-projects'),
        rowDivider: const BorderSide(color: _line),
        columns: const <DataTableColumn>[
          DataTableColumn(
            header: Text(
              'Project',
              key: ValueKey<String>('table-sort-project'),
            ),
            width: FlexColumnWidth(2),
            sortable: true,
          ),
          DataTableColumn(
            header: Text('Owner', key: ValueKey<String>('table-sort-owner')),
            width: FlexColumnWidth(1.2),
            sortable: true,
          ),
          DataTableColumn(header: Text('Status'), width: FixedColumnWidth(134)),
          DataTableColumn(
            header: Text('Budget', key: ValueKey<String>('table-sort-budget')),
            width: FixedColumnWidth(112),
            sortable: true,
            cellAlignment: AlignmentDirectional.centerEnd,
            headerAlignment: AlignmentDirectional.centerEnd,
          ),
        ],
        rows: <DataTableRow>[
          for (final _Project project in projects)
            DataTableRow(
              key: ValueKey<String>('table-project-${project.id}'),
              cells: <Widget>[
                Text(
                  project.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(project.owner),
                _status(project.status),
                Text(_money(project.budget)),
              ],
            ),
        ],
        showCheckboxes: true,
        selectedRows: <int>{
          for (int i = 0; i < projects.length; i++)
            if (_selectedProjectIds.contains(projects[i].id)) i,
        },
        onRowSelected: (int index) =>
            setState(() => _toggle(_selectedProjectIds, projects[index].id)),
        onSelectAll: (bool? selected) => setState(() {
          _selectedProjectIds.clear();
          if (selected == true) {
            _selectedProjectIds.addAll(projects.map((_Project p) => p.id));
          }
        }),
        sortColumnIndex: _sortColumn,
        sortAscending: _sortAscending,
        onSort: (int column) => setState(() {
          _sortAscending = _sortColumn == column ? !_sortAscending : true;
          _sortColumn = column;
        }),
        expandedRows: <String>{
          for (int i = 0; i < projects.length; i++)
            if (_expandedProjectIds.contains(projects[i].id)) '$i',
        },
        onRowExpanded: (String path) => setState(
          () => _toggle(_expandedProjectIds, projects[int.parse(path)].id),
        ),
        expandedRowChildBuilder:
            (BuildContext context, DataTableRow row, int index) {
              final _Project project = projects[index];
              return Column(
                key: ValueKey<String>('table-details-${project.id}'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    project.detail,
                    style: const TextStyle(color: _ink, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.milestone,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              );
            },
        footerRows: <DataTableRow>[
          DataTableRow(
            cells: <Widget>[
              const Text('Portfolio total'),
              Text('${projects.length} projects'),
              const SizedBox.shrink(),
              Text(
                _money(
                  _projects.fold(
                    0,
                    (int total, _Project p) => total + p.budget,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _groupedTable() => _scrollableTable(
    minWidth: 620,
    child: DataTable(
      key: const ValueKey<String>('table-groups'),
      rowDivider: const BorderSide(color: _line),
      columns: const <DataTableColumn>[
        DataTableColumn(header: Text('Workstream'), width: FlexColumnWidth(2)),
        DataTableColumn(header: Text('Tasks'), width: FixedColumnWidth(100)),
        DataTableColumn(header: Text('Progress'), width: FlexColumnWidth()),
      ],
      rows: const <DataTableRow>[
        DataTableRow(
          cells: <Widget>[
            Text('Design system'),
            Text('12'),
            Text('8 of 12 complete'),
          ],
          children: <DataTableRow>[
            DataTableRow(
              cells: <Widget>[Text('Token audit'), Text('4'), Text('Complete')],
            ),
            DataTableRow(
              cells: <Widget>[
                Text('Component QA'),
                Text('8'),
                Text('4 of 8 complete'),
              ],
            ),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Website launch'),
            Text('8'),
            Text('6 of 8 complete'),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Team onboarding'),
            Text('6'),
            Text('3 of 6 complete'),
          ],
        ),
        DataTableRow(
          cells: <Widget>[
            Text('Quarterly planning'),
            Text('4'),
            Text('Not started'),
          ],
        ),
      ],
      groups: const <DataTableGroup>[
        DataTableGroup(
          key: ValueKey<String>('table-group-product'),
          header: Text('Product / 2 workstreams'),
          startIndex: 0,
          endIndex: 1,
          collapsible: true,
        ),
        DataTableGroup(
          key: ValueKey<String>('table-group-operations'),
          header: Text('Operations / 2 workstreams'),
          startIndex: 2,
          endIndex: 3,
          collapsible: true,
        ),
      ],
      collapsedGroups: Set<int>.of(_collapsedGroups),
      onGroupToggled: (int group) =>
          setState(() => _toggle(_collapsedGroups, group)),
      expandedRows: Set<String>.of(_expandedWorkstreams),
      onRowExpanded: (String path) =>
          setState(() => _toggle(_expandedWorkstreams, path)),
    ),
  );

  @override
  Widget build(BuildContext context) => DataTableTheme(
    data: _tableStyle,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            '14 / Tables',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Sort, select and expand rows. Scroll horizontally on smaller screens.',
            style: TextStyle(color: _muted, fontSize: 13),
          ),
          const SizedBox(height: 24),
          const Text(
            'Project portfolio',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _projectTable(),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              Text(
                key: const ValueKey<String>('table-selection-status'),
                _selectedProjectIds.isEmpty
                    ? 'No projects selected'
                    : '${_selectedProjectIds.length} ${_selectedProjectIds.length == 1 ? 'project' : 'projects'} selected',
                style: const TextStyle(color: _muted, fontSize: 12),
              ),
              TextButton(
                key: const ValueKey<String>('table-clear-selection'),
                onPressed: _selectedProjectIds.isEmpty
                    ? null
                    : () => setState(_selectedProjectIds.clear),
                child: const Text('Clear selection'),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Grouped workstreams',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Open a group or expand Design system to see its nested tasks.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          _groupedTable(),
        ],
      ),
    ),
  );
}

class _Project {
  const _Project({
    required this.id,
    required this.name,
    required this.owner,
    required this.status,
    required this.budget,
    required this.detail,
    required this.milestone,
  });

  final String id;
  final String name;
  final String owner;
  final String status;
  final int budget;
  final String detail;
  final String milestone;
}
