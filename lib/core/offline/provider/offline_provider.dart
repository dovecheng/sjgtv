import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/offline/offline_manager.dart';

/// 离线模式状态
final offlineModeProvider = Provider<bool>((ref) {
  return OfflineManager.instance.shouldUseOfflineMode();
});