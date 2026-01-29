import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:base/log.dart';
import '../../../coder.dart';

extension FileExt on File {
  /// 生成代码
  bool gen({
    required void Function(LibraryBuilder b) coder,
    Set<String>? ignoreForFile,
  }) {
    try {
      SourceModel source = Library(coder).toSource(ignoreForFile);
      // 跳过相同的生成代码
      if (source != parseSourceSync()) {
        createSync(recursive: true);
        writeAsStringSync('$source');
        log.i('output ${path.relative(this.path)}');
        return true;
      } else {
        log.v('skip ${path.relative(this.path)}');
      }
    } catch (e, s) {
      log.e('fail ${path.relative(this.path)}', e, s);
    }
    return false;
  }

  /// 获取最后生成时间
  DateTime? getLastGeneratedTimeSync() {
    if (existsSync()) {
      RandomAccessFile reader = openSync();
      String? line = reader.readLineSync();
      reader.closeSync();
      if (line != null) {
        return SourceModel.getLastGenerated(line);
      }
    }
    return null;
  }

  /// 解析已生成的代码
  SourceModel? parseSourceSync() =>
      existsSync() ? SourceModel.parse(readAsStringSync()) : null;
}

extension RandomAccessFileExt on RandomAccessFile {
  /// 按行读取文本
  String? readLineSync() {
    List<int> line = [];
    while (true) {
      int byte = readByteSync();
      // -1: 结束符, 10: 换行符, 13: 回车键.
      if (byte == -1 || byte == 10 || byte == 13) {
        break;
      }
      line.add(byte);
    }
    if (line.isEmpty) {
      return null;
    }
    return utf8.decode(line);
  }
}
