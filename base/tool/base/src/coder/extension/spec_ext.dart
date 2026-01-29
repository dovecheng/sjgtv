import '../../../coder.dart';

extension SpecExt on Spec {
  static final DartEmitter _dartEmitter = DartEmitter.scoped(
    orderDirectives: true,
    useNullSafetySyntax: true,
  );

  /// 格式化源码
  SourceModel toSource([Set<String>? ignoreForFile]) => SourceModel(
    SourceModel.format('${accept(_dartEmitter)}'),
    ignoreForFile: ignoreForFile,
  );
}
