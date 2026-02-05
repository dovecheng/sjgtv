import 'dart:io';

import 'package:base/env.dart';
import 'package:base/isar.dart';
import 'package:base/log.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isar_provider.g.dart';

Isar? _isar;

Isar get $isar => _isar!;

/// 数据库实例 [isarProvider]
///
/// 暂时不支持Web
@Riverpod(keepAlive: true)
class IsarProvider extends _$IsarProvider {
  final List<CollectionSchema<dynamic>>? schemas;
  final String name;
  final int version;
  final bool inspector;
  final int maxSizeMiB;

  IsarProvider({
    this.name = 'isar',
    this.version = 6,
    this.schemas,
    this.inspector = !kReleaseMode,
    this.maxSizeMiB = 256,
  });

  @override
  Future<Isar> build() async {
    Isar isar = await Isar.open(
      <CollectionSchema<dynamic>>[...?schemas],
      directory: await getApplicationDocumentsDirectory().then(
        (Directory dir) => dir.path,
      ),
      name: '${name}_v$version',
      inspector: inspector,
      maxSizeMiB: maxSizeMiB,
    );

    if (inspector) {
      log.d(() async => 'build: ${await isar.inspectorUrl}');
    }

    ref.onDispose(isar.close);

    return _isar = isar;
  }
}
