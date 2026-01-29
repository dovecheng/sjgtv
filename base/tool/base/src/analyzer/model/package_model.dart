import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

/// 程序包
class PackageModel {
  /// 当前程序包
  static final PackageModel current = PackageModel(Directory.current);

  /// 包目录
  final Directory dir;

  /// 目录名
  late final String dirName = path.basename(dir.path);

  /// 资源目录
  late final Directory resDir = Directory(path.join(dir.path, 'res'));

  /// 源码目录
  late final Directory libDir = Directory(path.join(dir.path, 'lib'));

  /// 内部源码目录
  late final Directory srcDir = Directory(path.join(dir.path, 'lib', 'src'));

  /// 生成源码目录
  late final Directory genDir = Directory(path.join(dir.path, 'lib', 'gen'));

  /// 配置清单文件
  late final File pubspecFile = File(path.join(dir.path, 'pubspec.yaml'));

  /// 配置清单
  late final Pubspec pubspec = Pubspec.parse(pubspecFile.readAsStringSync());

  /// 包名
  late final String name = pubspec.name;

  /// 版本号
  late final Version version = pubspec.version ?? Version.none;

  PackageModel(this.dir);

  /// 文件包路径
  String getPackageUri(File file) =>
      'package:$name/${path.relative(file.path, from: libDir.path).replaceAll('\\', '/')}';

  /// [工具箱路径](https://jb.gg/toolbox-app)
  String getToolBoxUri(File file) =>
      'jetbrains://idea/navigate/reference?project=root&path=${path.relative(file.path, from: dir.parent.path).replaceAll('\\', '/')}';
}
