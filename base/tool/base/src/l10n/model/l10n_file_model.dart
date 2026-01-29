import '../../../analyzer.dart';
import '../../../l10n.dart';

/// 国际化定义文件
class L10nFileModel extends FileModel {
  /// 文件内国际化类定义
  late final List<L10nClassModel> l10nClasses = classes
      .where(
        (cm) =>
            cm.annotations.isNotEmpty &&
            cm.annotations.any((am) => am.name == '$L10nKeys') &&
            cm.isAbstract &&
            cm.name.endsWith('L10n') &&
            cm.typeParameters == null &&
            cm.withs?.isEmpty != false &&
            cm.fields.isEmpty &&
            cm.constructors.isEmpty &&
            cm.methods.isNotEmpty,
      )
      .map((cm) => L10nClassModel(this, cm.clazz))
      .where((lcm) => lcm.l10nKeys.enable)
      .toList();

  L10nFileModel(super.package, super.file, super.parsed);
}
