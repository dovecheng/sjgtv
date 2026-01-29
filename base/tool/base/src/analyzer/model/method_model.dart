import '../../../analyzer.dart';

/// 解析方法结果
class MethodModel {
  /// 解析类结果
  final ClassModel clazz;

  /// 方法声明
  final MethodDeclaration method;

  /// 注解列表
  late final List<AnnotationModel<MethodModel>> annotations = method.metadata
      .map((ann) => AnnotationModel(this, ann))
      .toList();

  /// 方法注释文档
  late final List<String>? docs = method.documentationComment?.tokens
      .map((t) => '$t')
      .toList();

  /// 是静态方法
  late final bool isStatic = method.isStatic;

  /// 是抽象方法
  late final bool isAbstract = method.isAbstract;

  /// 方法返回类型
  late final String? returnType = method.returnType?.toSource();

  /// 是Get方法
  late final bool isGetter = method.isGetter;

  /// 是Set方法
  late final bool isSetter = method.isSetter;

  /// 方法名
  late final String name = '${method.name}';

  /// 方法泛型声明
  late final TypeParameterList? typeParameters = method.typeParameters;

  /// 方法参数列表
  late final FormalParameterList? parameters = method.parameters;

  /// 是运算符方法
  late final bool isOperator = method.isOperator;

  MethodModel(this.clazz, this.method);
}
