import 'dart:io';

import 'base/base.dart';

void main() {
  PackageModel package = PackageModel.current;

  List<ClassModel> classes = package.srcDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_page.dart'))
      .parse(package)
      .expand((fm) {
        Iterable<ClassModel> classes = fm.classes.where((c) => !c.isAbstract);
        if (classes.any((c) => c.name.endsWith('PageState'))) {
          classes = classes.where((c) => c.name.endsWith('PageState'));
        } else {
          classes = classes.where((c) => c.name.endsWith('Page'));
        }
        return classes.where(
          (c) =>
              c.withs?.any((nt) => '${nt.name2}'.endsWith('L10nMixin')) != true,
        );
      })
      .toList();

  for (ClassModel c in classes) {
    log.w('${c.name} not has l10n mixin');
  }
}
