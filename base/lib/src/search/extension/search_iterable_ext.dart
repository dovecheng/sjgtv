import 'package:base/search.dart';

extension SearchIterableExt on Iterable<SearchableMixin> {
  /// 搜索
  ///
  /// [search] 输入的搜索内容
  Iterable<T> search<T extends SearchableMixin>(String search) {
    String text = search.trim();
    // 搜索内容是否纯字母
    bool searchIsAllLetter = text.hasMatchAllLetter();
    // 将搜索内容转为模糊正则匹配
    String regex = text.escapeWithRegex().split('').join('.*');
    // 转换为不区分大小写正则
    RegExp regExp = regex.toRegExp(caseSensitive: false);
    // 遍历实体类
    return whereType<T>().where(
      (T e) => e.hasMatch(
        search: text,
        searchRegExp: regExp,
        searchIsAllLetter: searchIsAllLetter,
      ),
    );
  }
}
