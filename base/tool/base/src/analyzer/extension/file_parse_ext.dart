import 'dart:io';

import 'package:base/log.dart';
import 'package:path/path.dart' as path;

import '../../../analyzer.dart';

extension FileIterableParseExt on Iterable<File> {
  /// 批量解析文件
  List<FileModel> parse([PackageModel? package]) =>
      map((file) => file.parse(package)).nonNulls.toList();
}

extension FileParseExt on File {
  /// 解析文件
  FileModel? parse([PackageModel? package]) {
    package ??= PackageModel.current;
    if (this.path.endsWith('.dart')) {
      try {
        log.v(path.relative(this.path));
        ParseStringResult result = parseFile(
          path: path.absolute(this.path),
          featureSet: FeatureSet.latestLanguageVersion(),
        );
        return FileModel(package, this, result);
      } catch (e, s) {
        log.e('', e, s);
      }
    }
    return null;
  }
}
