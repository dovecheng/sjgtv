import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'package_info_provider.g.dart';

@Deprecated('use packageInfoProvider')
const packageInfoProviderProvider = packageInfoProvider;

/// 应用信息 [packageInfoProvider]
@Riverpod(keepAlive: true)
class PackageInfoProvider extends _$PackageInfoProvider {
  @override
  Future<PackageInfo> build() => PackageInfo.fromPlatform();
}
