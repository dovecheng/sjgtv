import '../../../analyzer.dart';

/// 解析类结果
class ClassModel {
  /// 解析文件结果
  final FileModel file;

  /// 类声明
  final ClassDeclaration clazz;

  /// 注解列表
  late final List<AnnotationModel<ClassModel>> annotations = clazz.metadata
      .map((ann) => AnnotationModel(this, ann))
      .toList();

  /// 类注释文档
  late final List<String>? docs = clazz.documentationComment?.tokens
      .map((t) => '$t')
      .toList();

  /// 抽象类
  late final bool isAbstract = clazz.abstractKeyword != null;

  /// 类名
  late final String name = '${clazz.name}';

  /// 类泛型参数
  late final TypeParameterList? typeParameters = clazz.typeParameters;

  /// 继承父类
  late final NamedType? superclass = clazz.extendsClause?.superclass;

  /// 混入类型列表
  late final List<NamedType>? withs = clazz.withClause?.mixinTypes;

  /// 实现接口列表
  late final List<NamedType>? implements = clazz.implementsClause?.interfaces;

  /// 字段声明列表
  late final List<FieldDeclaration> fields = clazz.members
      .whereType<FieldDeclaration>()
      .toList();

  /// 构造声明列表
  late final List<ConstructorDeclaration> constructors = clazz.members
      .whereType<ConstructorDeclaration>()
      .toList();

  /// 方法声明列表
  late final List<MethodModel> methods = clazz.members
      .whereType<MethodDeclaration>()
      .map((md) => MethodModel(this, md))
      .toList();

  ClassModel(this.file, this.clazz);
}
