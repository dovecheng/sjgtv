import 'package:base/l10n.dart';
import 'package:base/provider.dart';
import 'package:sjgtv/src/source/source_l10n.dart';

/// 网页用国际化：从 base 的 [l10nTranslationProvider] 取当前语言的翻译 map，只返回 key 以 [webL10nKeysPrefix]_ 开头的项。
Map<String, String> getWebL10nMap() {
  final L10nTranslationModel tr = $ref
      .read(l10nTranslationProvider)
      .requireValue;
  final String prefix = '${webL10nKeysPrefix}_';
  return Map.fromEntries(
    tr.entries.where((MapEntry<String, String> e) => e.key.startsWith(prefix)),
  );
}
