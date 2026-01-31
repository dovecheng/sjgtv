import 'package:base/base.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/proxy_entity.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/source_entity.dart';
import 'package:sjgtv/src/model/tag.dart';
import 'package:sjgtv/src/model/tag_entity.dart';

/// sjgtv 应用的 JSON 转换器实现
///
/// 在 build() 中注册所有实体类的 fromJson 方法
class JsonAdapterImpl extends JsonAdapterProvider {
  @override
  void build() {
    super.build();

    // 注册域模型
    registerFromJson(Source.fromJson);
    registerFromJson(Proxy.fromJson);
    registerFromJson(Tag.fromJson);

    // 注册 Isar 实体类（供 JSON 反序列化时使用）
    registerFromJson(SourceEntity.fromJson);
    registerFromJson(ProxyEntity.fromJson);
    registerFromJson(TagEntity.fromJson);
  }
}
