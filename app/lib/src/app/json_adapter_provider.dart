import 'package:base/base.dart';
import 'package:sjgtv/src/proxy/proxy_model.dart';
import 'package:sjgtv/src/source/source_model.dart';
import 'package:sjgtv/src/tag/tag_model.dart';

/// sjgtv 应用的 JSON 转换器实现
///
/// 在 build() 中注册所有模型类的 fromJson 方法
class JsonAdapterImpl extends JsonAdapterProvider {
  @override
  void build() {
    super.build();

    registerFromJson(SourceModel.fromJson);
    registerFromJson(ProxyModel.fromJson);
    registerFromJson(TagModel.fromJson);
  }
}
