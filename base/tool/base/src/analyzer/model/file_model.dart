import 'dart:io';

import '../../../analyzer.dart';

/// 文件解析结果
class FileModel {
  /// 程序包
  final PackageModel package;

  /// 文件包路径
  late final String packageUri = package.getPackageUri(file);

  /// 文件包路径
  String getPackageUri(int offset) =>
      '$packageUri:${result.unit.lineInfo.getLocation(offset)}';

  /// 工具箱路径
  late final String toolBoxUri = package.getToolBoxUri(file);

  /// 工具箱路径
  String getToolBoxUri(int offset) =>
      '$toolBoxUri:${result.unit.lineInfo.getLocation(offset)}';

  /// 解析文件
  final File file;

  /// 解析结果
  final ParseStringResult result;

  /// 库声明
  late final LibraryDirective? library = result.unit.directives
      .whereType<LibraryDirective>()
      .firstOrNull;

  /// 片段声明
  late final List<PartDirective> part = result.unit.directives
      .whereType<PartDirective>()
      .toList();

  /// 片段部分声明
  late final PartOfDirective? partOf = result.unit.directives
      .whereType<PartOfDirective>()
      .firstOrNull;

  /// 导入声明
  late final List<ImportDirective> imports = result.unit.directives
      .whereType<ImportDirective>()
      .toList();

  /// 导出声明
  late final List<ExportDirective> exports = result.unit.directives
      .whereType<ExportDirective>()
      .toList();

  /// 类型别名
  late final List<TypeAlias> typeAliases = result.unit.declarations
      .whereType<TypeAlias>()
      .toList();

  /// 顶级方法声明
  late final List<FunctionDeclaration> topLevelFunctions = result
      .unit
      .declarations
      .whereType<FunctionDeclaration>()
      .toList();

  /// 顶级变量声明
  late final List<TopLevelVariableDeclaration> topLevelVariables = result
      .unit
      .declarations
      .whereType<TopLevelVariableDeclaration>()
      .toList();

  /// 类声明
  late final List<ClassModel> classes = result.unit.declarations
      .whereType<ClassDeclaration>()
      .map((cd) => ClassModel(this, cd))
      .toList();

  /// 枚举声明
  late final List<EnumDeclaration> enums = result.unit.declarations
      .whereType<EnumDeclaration>()
      .toList();

  /// 混入类声明
  late final List<MixinDeclaration> mixins = result.unit.declarations
      .whereType<MixinDeclaration>()
      .toList();

  /// 扩展声明
  late final List<ExtensionDeclaration> extensions = result.unit.declarations
      .whereType<ExtensionDeclaration>()
      .toList();

  FileModel(this.package, this.file, this.result);
}
