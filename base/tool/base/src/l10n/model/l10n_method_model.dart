import 'dart:convert';

import 'package:recase/recase.dart';

import '../../../analyzer.dart';
import '../../../l10n.dart';

/// 国际化单个key的方法
class L10nMethodModel extends MethodModel {
  /// 解析类结果
  final L10nClassModel l10nClass;

  /// 用于生成文件的国际化混入类实现方法的文档注释
  late final List<String> l10nDocs = [
    '/// key: $l10nKeyName',
    '/// ',
    '/// en: ${LineSplitter.split(l10nKey.en).join('\n/// ')}',
    '/// ',
    '/// zh_CN: ${LineSplitter.split(l10nKey.zh_CN).join('\n/// ')}',
    '/// ',
    '/// zh_HK: ${LineSplitter.split(l10nKey.zh_HK).join('\n/// ')}',
    '/// ',
    '/// keyDesc: ${LineSplitter.split(l10nKey.keyDesc).join('\n/// ')}',
    '/// ',
    '/// keyType: ${l10nKey.keyType.name}',
  ];

  /// 组合完整的国际化key

  /// 国际化方法注解
  late final L10nKey l10nKey = annotations
      .firstWhere((am) => am.name == '$L10nKey' && am.arguments != null)
      .argumentsMap
      .let(
        (Map<dynamic, Expression> it) => L10nKey(
          en: (it['en'] as StringLiteral).stringValue!,
          zh_CN: (it['zh_CN'] as StringLiteral).stringValue!,
          zh_HK: (it['zh_HK'] as StringLiteral).stringValue!,
          keyDesc: (it['keyDesc'] as StringLiteral).stringValue!,
          keyType: L10nKeyType.values.byName(
            (it['keyType'] as PrefixedIdentifier).identifier.name,
          ),
        ),
      );

  late final String l10nKeyName =
      '${l10nClass.l10nKeys.keysPrefix}_${name.endsWith('L10n') ? name.substring(0, name.length - 4) : name}'
          .snakeCase;

  L10nMethodModel(this.l10nClass, MethodDeclaration method)
    : super(l10nClass, method);
}
