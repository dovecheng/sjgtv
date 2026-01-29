import 'package:meta/meta_meta.dart';

/// 国际化多个Key声明, 用于类的注解.
@Target(<TargetKind>{TargetKind.classType})
final class L10nKeys {
  /// 国际化Key前缀, 用于导出.
  final String keysPrefix;

  /// 使用场景, 例如某个页面或某个组件.
  final Set<Object> usedContext;

  /// Key组描述, 用于导出.
  final String keysDesc;

  /// 是否自动生成代码
  final bool enable;

  /// 国际化多个Key声明, 用于类的注解.
  const L10nKeys({
    required this.keysPrefix,
    required this.keysDesc,
    this.usedContext = const <Object>{},
    this.enable = true,
  });
}
