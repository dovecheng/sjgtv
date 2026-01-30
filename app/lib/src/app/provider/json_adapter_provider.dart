import 'package:base/base.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/tag.dart';

/// sjgtv 应用的 JSON 转换器实现
///
/// 在 build() 中注册所有实体类的 fromJson 方法
class JsonAdapterImpl extends JsonAdapterProvider {
  @override
  void build() {
    super.build();

    // 注册本地 API 实体类
    registerFromJson(Source.fromJson);
    registerFromJson(Proxy.fromJson);
    registerFromJson(Tag.fromJson);

    // TODO: 后续添加更多实体类的 fromJson 注册
  }
}
