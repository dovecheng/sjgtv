import 'package:base/app.dart';
import 'package:base/converter.dart';
import 'package:base/debug.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'json_adapter_provider.g.dart';

/// 注册Json转换器 [jsonAdapterProvider]
@Riverpod(keepAlive: false)
class JsonAdapterProvider extends _$JsonAdapterProvider {
  @override
  @mustCallSuper
  void build() {
    registerFromJson(AppIconModel.fromJson);
    registerFromJson(DebugModel.fromJson);
  }

  void register<T extends Object>(T? Function(Object? value) converter) =>
      JSONConverter.register(converter);

  void registerFromJson<T extends Object>(
    T? Function(Map<String, dynamic> json) converter,
  ) => JSONConverter.registerFromJson(converter);
}
