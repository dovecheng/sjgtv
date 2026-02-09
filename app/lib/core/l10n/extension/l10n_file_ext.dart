import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import '../../../core/extension/extension.dart';

extension L10nFileExt on FileSystemEntity {
  /// 文件大小单位
  static const List<String> sizeSuffixes = [
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ];

  /// 文件大小格式化
  static String formatBytesSize(int bytes, [int decimals = 2]) {
    if (bytes <= 0) {
      return '0 B';
    }
    int i = (math.log(bytes) / math.log(1024)).floor().clamp(
      0,
      sizeSuffixes.length - 1,
    );
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${sizeSuffixes[i]}';
  }

  /// 获取文件大小
  String get sizeSync => formatBytesSize(lengthSync());

  /// 异步获取文件大小
  Future<String> get size async => formatBytesSize(await length());

  /// 递归获取文件/文件夹大小(字节数)
  int lengthSync() {
    if (this is File) {
      return (this as File).lengthSync();
    } else if (this is Directory) {
      return (this as Directory)
          .listSync(recursive: true)
          .whereType<File>()
          .fold<int>(0, (int size, File file) => size += file.lengthSync());
    }
    return 0;
  }

  /// 异步递归获取文件/文件夹大小(字节数)
  Future<int> length() async {
    if (this is File) {
      return (this as File).length();
    } else if (this is Directory) {
      int length = 0;
      Stream<File> files = (this as Directory)
          .list(recursive: true)
          .whereType<File>();
      await for (File file in files) {
        length = await file.length();
      }
      return length;
    }
    return 0;
  }
}
