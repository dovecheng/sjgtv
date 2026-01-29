import 'dart:io';

import 'base/base.dart';

void main() {
  PackageModel package = PackageModel.current;

  List<File> files = package.srcDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
  for (File file in files) {
    int lengthSync = file.lengthSync();
    List<String> lines = file.readAsLinesSync();
    if (lengthSync < 160 || lines.length < 10) {
      log.w(
        '${package.getPackageUri(file)} size=$lengthSync lines=${lines.length}',
      );
    }
  }
}
