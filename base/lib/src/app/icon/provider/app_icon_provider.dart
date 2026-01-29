import 'package:base/app.dart';
import 'package:base/converter.dart';
import 'package:base/extension.dart';
import 'package:base/log.dart';
import 'package:dynamic_app_icon_flutter/dynamic_app_icon.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_icon_provider.g.dart';

@Deprecated('use appIconProvider')
const appIconProviderProvider = appIconProvider;

/// 应用图标切换器 [appIconProvider]
@Riverpod(keepAlive: false, dependencies: [AppConfigProvider])
class AppIconProvider extends _$AppIconProvider {
  Future<void>? changingAppIcon;

  @override
  Future<AppIconModel?> build() async {
    Map<String, dynamic>? json =
        await ref.read(appConfigProvider('appIcon').future)
            as Map<String, dynamic>?;
    AppIconModel? model = json?.let(
      (Map<String, dynamic> it) => AppIconModel.fromJson(it),
    );
    log.d(() => 'model=${JSONConverter.toJsonStringify(model)}');
    return model;
  }

  /// 尝试切换图标, 如相同则不切换
  Future<bool> maybeChangeAppIcon(
    AppIconModel icon,
    List<AppIconModel> icons,
  ) async {
    if (await canChangeAppIcon(icon)) {
      log.d(() => 'changing');
      await changeAppIcon(icon, icons);
      return true;
    }
    log.d(() => 'no changed');
    return false;
  }

  /// 是否需要切换图标
  Future<bool> canChangeAppIcon(AppIconModel icon) async {
    // // 当为iOS平台时，一直允许切换图标(即使待切换的图标已经是应用图标)
    // if ($platform.isIOSNative) {
    //   return true;
    // }

    // 安卓检查是否需要换图标
    if ($platform.isAny(android: true, iOS: true)) {
      // if ($platform.isAndroidNative) {
      AppIconModel? current = state.value ?? await future;
      log.d(
        () => '${state.runtimeType} ${current?.toJson()} == ${icon.toJson()}',
      );
      // 当前图标不是接口返回的图标 或者 接口返回的图标不是安装时的默认图标
      return current?.let((AppIconModel it) => it != icon) ?? !icon.isDefault;
    }

    return false;
  }

  /// 切换图标
  Future<void> changeAppIcon(
    AppIconModel icon,
    List<AppIconModel> icons,
  ) async => changingAppIcon ??= Future(() async {
    if ($platform.isAndroidNative) {
      state = const AsyncLoading();

      await ref
          .read(appConfigProvider('appIcon').notifier)
          .saveOrUpdate(icon.toJson());

      state = AsyncData(icon);

      log.d(() => '安卓切换应用图标 ${icon.androidIconName}');

      // 安卓执行这句代码会重启应用
      try {
        await DynamicAppIcon.setupAppIcon(
          iconName: icon.androidIconName,
          iconList: icons.map((AppIconModel e) => e.androidIconName).toList(),
        );
      } on TypeError catch (_) {}
    } else if ($platform.isIOSNative &&
        await DynamicAppIcon.supportsAlternateIcons) {
      state = const AsyncLoading();

      await DynamicAppIcon.setAlternateIconName(icon.iosIconName);

      log.d(() => 'iOS切换应用图标 ${icon.iosIconName}');

      await ref
          .read(appConfigProvider('appIcon').notifier)
          .saveOrUpdate(icon.toJson());

      state = AsyncData(icon);
    }
  })..whenComplete(() => changingAppIcon = null);
}
