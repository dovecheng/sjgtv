import 'package:base/isar.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';

part 'proxies_provider.g.dart';

/// 代理列表提供者 [proxiesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
@Riverpod(keepAlive: true)
class ProxiesStorageProvider extends _$ProxiesStorageProvider {
  @override
  Future<List<ProxyModel>> build() async {
    final List<ProxyModel> list = await $isar.proxies
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
    return list;
  }

  Future<ProxyModel> addProxyModel(ProxyModel proxy) async {
    await $isar.writeTxn(() async => $isar.proxies.put(proxy));
    ref.invalidateSelf();
    return proxy;
  }

  Future<ProxyModel> toggleProxyModel(String uuid) async {
    final List<ProxyModel> list = await $isar.proxies
        .where()
        .filter()
        .uuidEqualTo(uuid)
        .findAll();
    final ProxyModel? e = list.isEmpty ? null : list.first;
    if (e == null) throw Exception('代理不存在');
    e.enabled = !e.enabled;
    e.updatedAt = DateTime.now();
    await $isar.writeTxn(() async => $isar.proxies.put(e));
    ref.invalidateSelf();
    return e;
  }

  Future<void> deleteProxyModel(String uuid) async {
    await $isar.writeTxn(() async {
      final List<ProxyModel> list = await $isar.proxies
          .where()
          .filter()
          .uuidEqualTo(uuid)
          .findAll();
      for (final ProxyModel e in list) {
        if (e.id != null) await $isar.proxies.delete(e.id!);
      }
    });
    ref.invalidateSelf();
  }
}
