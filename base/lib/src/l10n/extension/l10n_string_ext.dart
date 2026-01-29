extension L10nStringExt on String {
  /// 格式化占位符
  static final RegExp _formatPlaceholderRE = RegExp(r'(\\)?{(\w*)(\\)?}');

  /// 格式化字符串
  ///
  /// [params]: 支持[List]和[Map]
  ///
  ///
  /// 如果[params]是[List], 占位符为`{0}`
  ///
  /// 如果[params]是[Map], 占位符为`{name}`
  ///
  /// 如果[params]是单个值[Object], 占位符为`{}`
  ///
  /// 转义符: \{name} 输出 \abc
  ///
  /// 转义符: \{name\} 输出 {name}
  String format(Object params) {
    Map<String, dynamic> map = switch (params) {
      Map<String, dynamic> _ => params,
      Map _ => params.map((key, value) => MapEntry('$key', value)),
      List _ => {for (int i = 0; i < params.length; i++) '$i': params[i]},
      _ => {'': params},
    };

    int? index;

    // replace string with mapParams
    return replaceAllMapped(_formatPlaceholderRE, (Match match) {
      var (String? group1, String? group2, String? group3) = (
        match.group(1),
        match.group(2),
        match.group(3),
      );
      if (group2?.isNotEmpty != true) {
        int i = index ??= 0;
        group2 = '$i';
        index = i + 1;
      }
      if (group1 != null && group3 != null) {
        return '{$group2}';
      }
      String? value = map[group2]?.toString();
      if (value != null) {
        if (group1 != null) {
          return '$group1$value';
        } else if (group3 != null) {
          return '$value$group3';
        }
        return value;
      }
      return match.group(0)!;
    });
  }
}
