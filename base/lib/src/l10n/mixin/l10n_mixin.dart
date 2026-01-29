import 'package:base/l10n.dart';
import 'package:meta/meta.dart';

/// 国际化枚举基类
mixin L10nMixin on Enum {
  /// 枚举名称等于国际化Key
  @protected
  String get name => EnumName(this).name;

  /// 国际化Key等于枚举名称
  String get key => name;

  /// 获取翻译内容
  String get value => $tr?[key] ?? key;
}
