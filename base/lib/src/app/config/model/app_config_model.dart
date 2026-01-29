import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:meta/meta.dart';

part 'app_config_model.g.dart';

/// 应用配置实体类
@Name('config')
@Collection(accessor: 'appConfig', inheritance: false)
class AppConfigModel {
  Id? id;

  /// 配置枚举
  @Index(unique: true, replace: true)
  late String key;

  @ignore
  Object? value;

  AppConfigModel(this.key, [this.value]);

  @visibleForTesting
  String get stringify => jsonEncode(value);

  @visibleForTesting
  set stringify(String value) => this.value = jsonDecode(value);

  @override
  String toString() => '$key: $value';
}
