import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import 'base/base.dart';

void main() {
  PackageModel package = PackageModel.current;

  RegExp todoRegExp = RegExp(
    r'// ?(TODO|FIXME)(\((\w+)\))?:? ?(\d{4}[\-/]\d{2}[\-/]\d{2})? ?(.+)?',
  );

  Iterable<String> todos = package.libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) {
        String basename = path.basename(f.path);
        if (basename.endsWith('.g.dart') || basename.endsWith('.gen.dart')) {
          return false;
        }
        return const [
          '.dart',
          '.rm.dart',
          '.dart.rm',
          '.bak.dart',
          '.dart.bak',
        ].any((s) => basename.endsWith(s));
      })
      .expand(
        (f) => f.readAsLinesSync().mapIndexed((index, text) {
          RegExpMatch? match = todoRegExp.firstMatch(text);
          if (match != null) {
            int line = index + 1;
            String filename = path.basename(f.path);
            String toolBoxUri = package.getToolBoxUri(f);
            String? type = match.group(1);
            String? text = match.group(5);
            return <String?>[
              '[$filename]($toolBoxUri:$line)',
              text,
              '#${package.dirName}',
              '#$type',
            ].join(' ');
          }
          return null;
        }).nonNulls,
      );

  log.i('${package.dirName}/ has ${todos.length} todos:\n${todos.join('\n')}');
}
