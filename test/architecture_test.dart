import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('library depends only on widgets, math and package-local code', () {
    final RegExp directives = RegExp(
      r'''(?:import|export)\s+['"]([^'"]+)['"]''',
    );
    for (final File file
        in Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((File f) => f.path.endsWith('.dart'))) {
      for (final RegExpMatch match in directives.allMatches(
        file.readAsStringSync(),
      )) {
        final String uri = match.group(1)!;
        expect(
          uri == 'package:flutter/widgets.dart' ||
              uri == 'dart:math' ||
              uri.startsWith('package:pure_ui/') ||
              !uri.contains(':'),
          isTrue,
          reason: '${file.path} imports $uri',
        );
      }
    }
  });

  test('source and documentation contain no em dash characters', () {
    final List<File> files = <File>[
      for (final String path in <String>['lib', 'test', 'example/lib'])
        if (Directory(path).existsSync())
          ...Directory(path)
              .listSync(recursive: true)
              .whereType<File>()
              .where((File f) => f.path.endsWith('.dart')),
      File('README.md'),
      File('CHANGELOG.md'),
    ];
    for (final File file in files) {
      expect(
        file.readAsStringSync(),
        isNot(contains(String.fromCharCode(0x2014))),
        reason: file.path,
      );
    }
  });
}
