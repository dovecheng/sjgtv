import 'dart:io';

import 'base/base.dart';

void main() {
  PackageModel package = PackageModel.current;

  List<FileModel> files = package.libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'))
      .parse(package)
      .where(
        (fm) =>
            fm.topLevelFunctions.isNotEmpty || fm.topLevelVariables.isNotEmpty,
      )
      .toList();

  for (FileModel file in files) {
    for (CompilationUnitMember e in [
      ...file.topLevelFunctions,
      ...file.topLevelVariables,
    ]) {
      log.i('${file.getPackageUri(e.offset)}\n  ${e.toSource()}');
    }
  }
}
