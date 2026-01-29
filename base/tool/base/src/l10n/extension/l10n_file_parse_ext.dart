import 'dart:io';

import 'package:base/log.dart';
import 'package:path/path.dart' as path;

import '../../../analyzer.dart';
import '../../../l10n.dart';

extension L10nFileIterableParseExt on Iterable<File> {
  /// 批量解析国际化定义文件
  List<L10nFileModel> parseL10n([PackageModel? package]) =>
      map((file) => file.parseL10n(package)).nonNulls.toList();
}

extension L10nFileParseExt on File {
  /// 解析国际化定义文件
  L10nFileModel? parseL10n([PackageModel? package]) {
    package ??= PackageModel.current;
    if (this.path.endsWith('.dart')) {
      try {
        log.v(path.relative(this.path));
        ParseStringResult result = parseFile(
          path: path.absolute(this.path),
          featureSet: FeatureSet.latestLanguageVersion(),
        );
        return L10nFileModel(package, this, result);
      } catch (e, s) {
        log.e('', e, s);
      }
    }
    return null;
  }
}
