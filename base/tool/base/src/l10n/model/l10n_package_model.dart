import 'dart:io';

import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';

import '../../../analyzer.dart';
import '../../../coder.dart';
import '../../../l10n.dart';

/// 国际化程序包
class L10nPackageModel extends PackageModel {
  /// 当前程序包
  static final L10nPackageModel current = L10nPackageModel(Directory.current);

  L10nPackageModel(super.dir);

  /// 包内所有国际化定义文件
  late final List<L10nFileModel> l10nFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('_l10n.dart'))
      .parseL10n(this)
      .where(
        (L10nFileModel lfm) =>
            lfm.l10nClasses.isNotEmpty &&
            lfm.library == null &&
            lfm.partOf == null,
      )
      .sortedBy((lfm) => path.basename(lfm.file.path));

  /// 包内所有国际化定义类(page/group)
  late final List<L10nClassModel> l10nClasses = l10nFiles
      .expand((lfm) => lfm.l10nClasses)
      .sortedBy((lcm) => lcm.name);

  /// 包内所有国际化定义方法(key)
  late final Map<String, L10nMethodModel> l10nMethods = {
    for (L10nMethodModel method
        in l10nClasses
            .expand((lcm) => lcm.l10nMethods)
            .sortedBy((lmm) => lmm.l10nKeyName))
      method.l10nKeyName: method,
  };

  /// 包内所有国际化翻译字典, 用于生成代码
  late final Map<String, Map<String, String>> l10nTranslations = {
    'en': {
      for (L10nMethodModel method in l10nMethods.values)
        method.l10nKeyName: method.l10nKey.en,
    },
    'zh-CN': {
      for (L10nMethodModel method in l10nMethods.values)
        method.l10nKeyName: method.l10nKey.zh_CN,
    },
    'zh-HK': {
      for (L10nMethodModel method in l10nMethods.values)
        method.l10nKeyName: method.l10nKey.zh_HK,
    },
  };

  /// 包内所有国际化翻译字典, 用于生成表格
  late final List<List<String>> l10nTable = [
    [
      '#',
      'Filename',
      'UsedContext',
      'KeysDesc',
      'KeyDesc',
      'KeyType',
      'KeyTypeDesc',
      'keyTypeUsage',
      'KeyName',
      'en',
      'zh-CN',
      'zh-HK',
      'UsedAppVersion',
      'LastGenerated',
    ],
    ...l10nMethods.values.mapIndexed((i, lmm) {
      File file = lmm.clazz.file.file;
      File genFile = File(path.setExtension(file.path, '.gen.dart'));
      DateTime? lastGeneratedTime = genFile.getLastGeneratedTimeSync();
      String lastGeneratedTimeFormatted = lastGeneratedTime != null
          ? DateFormat('yyyy-MM-dd HH:mm:ss').format(lastGeneratedTime)
          : '';
      return [
        '${i + 1}',
        path.basename(file.path),
        lmm.l10nClass.l10nKeys.usedContext.join(', '),
        lmm.l10nClass.l10nKeys.keysDesc,
        lmm.l10nKey.keyDesc,
        lmm.l10nKey.keyType.name,
        lmm.l10nKey.keyType.keyTypeDesc,
        lmm.l10nKey.keyType.keyTypeUsage,
        lmm.l10nKeyName,
        lmm.l10nKey.en,
        lmm.l10nKey.zh_CN,
        lmm.l10nKey.zh_HK,
        '${pubspec.version ?? Version.none}',
        lastGeneratedTimeFormatted,
      ];
    }),
  ];
}
