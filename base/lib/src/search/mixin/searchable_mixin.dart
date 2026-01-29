import 'package:collection/collection.dart';
import 'package:base/search.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

mixin SearchableMixin {
  /// 用于搜索的分词字段
  Map<String, String>? _participleFields;

  /// 用于搜索的分词字段
  @JsonKey(includeFromJson: false)
  Map<String, String>? get participleFields =>
      _participleFields ?? _participle();

  /// 用于搜索的分词字段
  set participleFields(Map<String, String>? value) => _participleFields = value;

  /// 获取用于生成分词的字段
  @protected
  @JsonKey(includeFromJson: false)
  Map<String, String>? get searchFields;

  /// 获取用于搜索结果去重的主键
  @protected
  @JsonKey(includeFromJson: false)
  Object get searchKey;

  /// 匹配搜索
  ///
  /// [search] 搜索文本去空格
  /// ```dart
  /// String search = input.trim();
  /// ```
  ///
  /// [searchRegExp] 搜索文本转正则
  /// ```dart
  /// RegExp search = input.escapeWithRegex().split('').join('.*').toRegExp(caseSensitive: false);
  /// ```
  ///
  /// [searchIsAllLetter] 搜索内容是否为纯字母
  /// ```dart
  /// bool searchIsAllLetter = search.hasMatchAllLetter();
  /// ```
  ///
  /// `result` 匹配到的内容
  bool hasMatch({
    required String search,
    required RegExp searchRegExp,
    bool searchIsAllLetter = false,
  }) {
    Iterable<MapEntry<String, String>>? entries = participleFields?.entries;

    // 判断搜索内容不是纯字母
    if (!searchIsAllLetter) {
      // 不搜索拼音
      entries = entries?.where(
        (MapEntry<String, String> e) => !e.key.endsWith('_pinyin'),
      );
    }

    // 遍历分词字段
    MapEntry<String, String>? result = entries?.firstWhereOrNull((
      MapEntry<String, String> entry,
    ) {
      RegExpMatch? match = searchRegExp.firstMatch(entry.value);
      // 匹配成功
      if (match != null) {
        // 过滤非字母开头的匹配 如输入 `ave` 不能匹配 `dave`
        int index = match.input.indexOf(match[0]!);
        if (index > 0 && match.input[index - 1].hasMatchWord()) {
          return false;
        }
        // 过滤非单词开头 如输入 `ceijie` 不能匹配 `chenweijie`
        if (searchIsAllLetter) {
          // 将匹配到的内容转为正则
          String regex = match[0]!
              .escapeWithRegex()
              .split(' ')
              .map((String e) {
                if (e.isEmpty) {
                  return '';
                } else if (e.length == 1) {
                  return '$e?';
                }
                // 将每个词转为左匹配的正则 如dave 转为 (da?v?e?)?
                return '(${e[0]}${e.substring(1).split('').map((String e) => '$e?').join()})?';
              })
              .join(r'\s*');

          // 搜索结果转为单词左匹配正则
          RegExp regExp = regex.toRegExp(caseSensitive: false);
          // 单词左匹配输入内容
          String? stringMatch = regExp.stringMatch(search);
          // 完全匹配
          return stringMatch == search;
        }
        return true;
      }
      return false;
    });

    // 匹配结果不为空
    return result != null;
  }

  /// 分词取拼音
  Map<String, String> _participle() {
    if (_participleFields == null) {
      // 获取用于搜索的字段
      Map<String, String>? searchFields = this.searchFields;
      // 判断子类是否提供字段
      if (searchFields?.isNotEmpty == true) {
        // 分词取拼音
        Map<String, String> participleFields = {};
        // 遍历字段
        for (MapEntry<String, String> entry in searchFields!.entries) {
          // 获取字段值
          String field = entry.value.trim();
          // 过滤空值
          if (field.isNotEmpty) {
            // 分词
            participleFields[entry.key] = field.participle().trim();
            // 是否包含中文
            if (entry.value.hasMatchChinese()) {
              String chineseText = field.trim();
              // 取拼音
              participleFields['${entry.key}_pinyin'] = chineseText.getPinYin();
            }
          }
        }
        _participleFields = participleFields;
      }
    }
    return _participleFields!;
  }
}
