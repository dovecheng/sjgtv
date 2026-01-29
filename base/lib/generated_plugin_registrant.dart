//
// Generated file. Do not edit.
//

import 'package:connectivity_for_web/connectivity_for_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:video_player_web/video_player_web.dart';
import 'package:wakelock_web/wakelock_web.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  ConnectivityPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  VideoPlayerPlugin.registerWith(registrar);
  WakelockWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
