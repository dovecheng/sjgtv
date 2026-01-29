import 'dart:developer';

import 'package:isar_community/isar.dart';

extension IsarExt on Isar {
  /// 数据库调试地址
  Future<String?> get inspectorUrl async {
    ServiceProtocolInfo info = await Service.getInfo();
    Uri? serviceUri = info.serverUri;
    if (serviceUri == null) {
      return null;
    }
    int port = serviceUri.port;
    String path = serviceUri.path;
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path.endsWith('=')) {
      path = path.substring(0, path.length - 1);
    }
    // return 'https://inspect.isar.dev/${Isar.version}/#/$port$path';
    return 'https://inspect.isar-community.dev/${Isar.version}/#/$port$path';
  }
}
