import 'package:lpinyin/lpinyin.dart';

extension SearchStringExt on String {
  /// 用于匹配英文字母或数字及下划线
  static final RegExp _wordRE = RegExp(r'\w');

  /// 用于匹配中文(简繁)
  static final RegExp _chineseRE = RegExp(r'[\u4e00-\u9fa5]');

  /// 用于匹配非中文
  static final RegExp _noChineseRE = RegExp(r'[^\u4e00-\u9fa5]');

  /// 用于匹配空格和英文字母
  static final RegExp _allLetterRE = RegExp(r'[\sa-zA-Z]+');

  /// 用于匹配正则表达式的符号
  static final RegExp _escapeRE = RegExp(r'[\^$.?+*{\}\[\](|)\\]');

  /// 用于单词拆分为空格间隔
  static final RegExp _participleRE = RegExp(
    r'(([^\sA-Z]?[A-Z]?[a-z\d]+(\d\D)?)|([^a-zA-Z][a-z][A-Z][a-z]+)|(\w+)|(\W+))',
  );

  /// 用于单词拆分为集合
  static final RegExp _wordsRE = RegExp(
    r'([A-Z]?[a-z\d]+(\d\D)?|[a-z][A-Z][a-z]+|\w+|[^\w\s]+)',
  );

  /// 单词拆分
  List<String> get words => _wordsRE
      .allMatches(this)
      .map((RegExpMatch match) => match.group(1)!)
      .toList();

  /// 去除非中文
  String clearNotChinese() => replaceAll(_noChineseRE, '');

  /// 转义正则表达式符号
  String escapeWithRegex() =>
      replaceAllMapped(_escapeRE, (Match match) => '\\${match[0]}');

  /// 取拼音
  ///
  /// [separator] 分隔符
  ///
  /// [defPinyin] 默认拼音
  ///
  /// [format] 拼音格式
  ///
  /// [multi] 是否处理多音字
  String getPinYin({
    String separator = ' ',
    String defPinyin = '',
    PinyinFormat format = PinyinFormat.WITHOUT_TONE,
    bool multi = true,
  }) {
    StringBuffer sb = StringBuffer();
    String str = ChineseHelper.convertToSimplifiedChinese(this);
    int strLength = str.length;
    int i = 0;
    while (i < strLength) {
      String subStr = str.substring(i);
      MultiPinyin? node = PinyinHelper.convertToMultiPinyin(
        subStr,
        separator,
        format,
      );
      if (i > 0 && sb.isNotEmpty) {
        sb.write(separator);
      }
      if (node == null) {
        String char = str[i];
        if (ChineseHelper.isChinese(char)) {
          List<String> pinyinArray = PinyinHelper.convertToPinyinArray(
            char,
            format,
          );
          if (pinyinArray.isNotEmpty) {
            if (multi) {
              sb.write(pinyinArray.join(separator));
            } else {
              sb.write(pinyinArray[0]);
            }
          } else {
            sb.write(defPinyin);
          }
        } else {
          sb.write(char);
        }
        i++;
      } else {
        sb.write(node.pinyin);
        i += node.word!.length;
      }
    }
    String pinyin = sb.toString();
    return (pinyin.endsWith(separator) && separator.isNotEmpty)
        ? pinyin.substring(0, pinyin.length - 1)
        : pinyin;
  }

  // /// 取首字母
  // String getShortLetter() => split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join();
  //
  // /// 取拼音首字母
  // String getShortPinYin() => PinyinHelper.getShortPinyin(this);

  /// 是否为纯字母或空格
  bool hasMatchAllLetter() => _allLetterRE.hasMatch(this);

  /// 是否包含中文
  bool hasMatchChinese() => _chineseRE.hasMatch(this);

  /// 是否包含英文或数字
  bool hasMatchWord() => _wordRE.hasMatch(this);

  /// 分词
  ///
  /// [separator] 分隔符
  String participle({String separator = ' '}) {
    bool flag = false;
    return replaceAllMapped(_participleRE, (Match match) {
      String? word = match.group(0)!.trim();
      if (word.isEmpty) {
        return '';
      }
      if (!flag) {
        flag = true;
        return word;
      }
      return '$separator$word';
    });
  }

  /// 字符串转正则
  RegExp toRegExp({
    bool multiLine = false,
    bool caseSensitive = true,
    bool unicode = false,
    bool dotAll = false,
  }) => RegExp(
    this,
    multiLine: multiLine,
    caseSensitive: caseSensitive,
    unicode: unicode,
    dotAll: dotAll,
  );
}
