import 'package:base/log.dart';
import 'package:dart_style/dart_style.dart';
import 'package:intl/intl.dart';

/// 源代码
class SourceModel {
  static final DartFormatter _dartFormatter = DartFormatter(
    languageVersion: DartFormatter.latestLanguageVersion,
    lineEnding: '\n',
    pageWidth: 80,
    // fixes: StyleFix.all,
  );

  /// 源代码格式化
  static String format(String source) => _dartFormatter.format(source).trim();

  /// 获取生成文件的生成日期和时间
  static DateTime? getLastGenerated(String source) {
    String? group = _headerRE.firstMatch(source)?.group(1);
    if (group != null) {
      return DateTime.tryParse(group);
    }
    return null;
  }

  // GENERATED CODE BY 2021-12-31 23:59:59 - DO NOT MODIFY BY HAND
  static final RegExp _headerRE = RegExp(
    r'^// GENERATED CODE BY (\d{2,4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}) - DO NOT MODIFY BY HAND$',
    multiLine: true,
  );

  // ignore_for_file: unused_import, unnecessary_import
  static final RegExp _ignoreForFileRE = RegExp(
    r'^// ignore_for_file: (\w+(, \w+)*)$',
    multiLine: true,
  );

  /// 生成时间
  final DateTime? generatedTime;

  /// 忽略警告
  final Set<String>? ignoreForFile;

  /// 源码
  final String source;

  const SourceModel(this.source, {this.generatedTime, this.ignoreForFile});

  factory SourceModel.parse(String source) {
    DateTime? lastGenerated;
    source = source.replaceFirstMapped(_headerRE, (m) {
      String? group = m.group(1);
      if (group != null) {
        lastGenerated = DateTime.tryParse(group);
      }
      return '';
    });

    Set<String>? ignoreForFile;
    source = source.replaceAllMapped(_ignoreForFileRE, (match) {
      List<String>? split = match.group(1)?.split(', ');
      if (split != null) {
        (ignoreForFile ??= <String>{}).addAll(split);
      }
      return '';
    });

    return SourceModel(
      source.trim(),
      generatedTime: lastGenerated,
      ignoreForFile: ignoreForFile,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SourceModel &&
          runtimeType == other.runtimeType &&
          source == other.source;

  @override
  int get hashCode => source.hashCode;

  @override
  String toString() => [
    '// GENERATED CODE BY ${DateFormat('yyyy-MM-dd HH:mm:ss').format(generatedTime ?? DateTime.now())} - DO NOT MODIFY BY HAND',
    if (ignoreForFile?.isNotEmpty == true)
      '// ignore_for_file: ${ignoreForFile!.join(', ')}',
    '',
    source,
  ].join('\n');
}
