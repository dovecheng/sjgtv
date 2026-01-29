import 'package:collection/collection.dart';

import '../../../analyzer.dart';

/// 解析注解结果
class AnnotationModel<O> {
  /// 所在节点
  final O owner;

  /// 注解
  final Annotation annotation;

  /// 注解名称
  late final String name = annotation.name.name;

  /// 注解参数列表
  late final ArgumentList? arguments = annotation.arguments;

  /// 注解参数字典
  late final Map<dynamic, Expression> argumentsMap = arguments != null
      ? Map<dynamic, Expression>.fromEntries(
          arguments!.arguments.mapIndexed(
            (index, exp) => exp is NamedExpression
                ? MapEntry(exp.name.label.name, exp.expression)
                : MapEntry(index, exp),
          ),
        )
      : const {};

  AnnotationModel(this.owner, this.annotation);
}
