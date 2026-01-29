import 'dart:io';

import 'package:path/path.dart' as path;

import 'base/base.dart';

void main() {
  PackageModel package = PackageModel.current;

  List<Directory> modules = package.srcDir
      .listSync()
      .whereType<Directory>()
      .toList();
  for (Directory module in modules) {
    File moduleExport = File(
      path.join(package.libDir.path, '${path.basename(module.path)}.dart'),
    );
    String moduleExports = module
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path)
        .where(
          (p) =>
              p.endsWith('.dart') &&
              !p.startsWith('_') &&
              !p.endsWith('.g.dart'),
        )
        .map(
          (p) =>
              path.split(path.relative(p, from: package.libDir.path)).join('/'),
        )
        .map((p) => "export '$p';")
        .join('\n');
    moduleExport.writeAsStringSync(moduleExports);
    log.i(() => 'output ${package.getPackageUri(moduleExport)}');
  }

  File projectExport = File(
    path.join(package.libDir.path, '${package.dirName}.dart'),
  );
  String projectExports = modules
      .map((d) => path.basename(d.path))
      .map((bn) => "export '$bn.dart';")
      .join('\n');
  projectExport.writeAsStringSync(
    "export 'env.dart';\n$projectExports",
    flush: true,
  );
  log.i(() => 'output ${package.getPackageUri(projectExport)}');
}
