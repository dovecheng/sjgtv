import 'dart:convert';

import '../../../analyzer.dart';
import '../../../l10n.dart';

/// 国际化类定义
class L10nClassModel extends ClassModel {
  /// 用于生成文件的国际化混入类文档注释
  late final List<String> l10nDocs = [
    '/// has ${l10nMethods.length} keys',
    '/// ',
    '/// keysPrefix: ${l10nKeys.keysPrefix}',
    '/// ',
    '/// usedContext: ${l10nKeys.usedContext.map((e) => '[$e]').join(', ')}',
    '/// ',
    '/// keysDesc: ${LineSplitter.split(l10nKeys.keysDesc).join('\n/// ')}',
  ];

  /// 类注解
  late final L10nKeys l10nKeys = annotations
      .firstWhere((am) => am.name == '$L10nKeys' && am.arguments != null)
      .argumentsMap
      .let(
        (Map<dynamic, Expression> it) => L10nKeys(
          keysPrefix: (it['keysPrefix'] as StringLiteral).stringValue!,
          usedContext:
              (it['usedContext'] as SetOrMapLiteral?)?.elements
                  .map((e) => e.toSource())
                  .toSet() ??
              const <Object>{},
          keysDesc: (it['keysDesc'] as StringLiteral).stringValue!,
          enable: (it['enable'] as BooleanLiteral?)?.value ?? true,
        ),
      );

  /// 国际化方法定义
  late final List<L10nMethodModel> l10nMethods = methods
      .where(
        (mm) =>
            mm.annotations.isNotEmpty &&
            mm.annotations.any((am) => am.name == '$L10nKey') &&
            !mm.isStatic &&
            mm.isAbstract &&
            mm.typeParameters == null &&
            mm.isGetter &&
            mm.returnType == 'String' &&
            mm.name.endsWith('L10n'),
      )
      .map((mm) => L10nMethodModel(this, mm.method))
      .toList();

  L10nClassModel(super.file, super.clazz);
}
