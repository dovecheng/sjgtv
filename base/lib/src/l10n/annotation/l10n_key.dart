// ignore_for_file: non_constant_identifier_names

import 'package:base/src/l10n/annotation/l10n_key_type.dart';
import 'package:meta/meta_meta.dart';

/// 国际化单个Key声明, 用于字段的注解.
///
/// 语言地区编码
/// http://www.lingoes.net/en/translator/langcode.htm
///
/// 语言编码
/// https://zh.wikipedia.org/wiki/ISO_639-1
///
/// 地区编码(二位代码)
/// https://zh.wikipedia.org/wiki/ISO_3166-1
@Target(<TargetKind>{TargetKind.getter})
final class L10nKey {
  /// 英语
  final String en;

  /// 中文简体
  final String zh_CN;

  /// 中文繁体
  final String zh_HK;

  /// Key描述, 用于导出.
  final String keyDesc;

  /// Value类型
  final L10nKeyType keyType;

  /// 国际化单个Key声明, 用于字段的注解.
  const L10nKey({
    required this.en,
    required this.zh_CN,
    required this.zh_HK,
    required this.keyDesc,
    required this.keyType,
  });
}
