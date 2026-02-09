import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sjgtv/core/log/log.dart';

/// 网络状态监听器
///
/// 监听网络连接状态，支持离线模式
class NetworkStatus {
  final Log log = (NetworkStatus).log;

  static NetworkStatus? _instance;

  static NetworkStatus get instance => _instance ??= NetworkStatus._();

  NetworkStatus._() {
    _init();
  }

  /// 网络状态流
  final StreamController<NetworkResult> _statusController =
      StreamController<NetworkResult>.broadcast();

  Stream<NetworkResult> get statusStream => _statusController.stream;

  /// 当前网络状态
  NetworkResult _currentStatus = NetworkResult.online;

  NetworkResult get currentStatus => _currentStatus;

  /// 初始化网络监听
  void _init() {
    // 监听网络连接变化
    Connectivity().onConnectivityChanged.listen(_onConnectivityChanged);

    // 初始检查网络状态
    _checkConnectivity();
  }

  /// 检查当前连接状态
  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateStatus(connectivityResult);
  }

  /// 网络连接变化回调
  void _onConnectivityChanged(List<ConnectivityResult> results) {
    _updateStatus(results);
  }

  /// 更新网络状态
  void _updateStatus(List<ConnectivityResult> results) {
    final newStatus = _parseConnectivityResult(results);

    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(newStatus);
      log.i(() => '网络状态变化: $newStatus');
    }
  }

  /// 解析连接状态
  NetworkResult _parseConnectivityResult(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      return NetworkResult.unknown;
    }

    final result = results.first;

    switch (result) {
      case ConnectivityResult.wifi:
        return NetworkResult.wifi;
      case ConnectivityResult.ethernet:
        return NetworkResult.ethernet;
      case ConnectivityResult.mobile:
        return NetworkResult.mobile;
      case ConnectivityResult.vpn:
        return NetworkResult.vpn;
      case ConnectivityResult.bluetooth:
        return NetworkResult.bluetooth;
      case ConnectivityResult.other:
        return NetworkResult.other;
      case ConnectivityResult.none:
        return NetworkResult.offline;
    }
  }

  /// 检查是否在线
  bool get isOnline => _currentStatus != NetworkResult.offline;

  /// 检查是否离线
  bool get isOffline => _currentStatus == NetworkResult.offline;

  /// 检查是否是 WiFi
  bool get isWifi => _currentStatus == NetworkResult.wifi;

  /// 检查是否是移动网络
  bool get isMobile => _currentStatus == NetworkResult.mobile;

  /// 销毁监听器
  void dispose() {
    _statusController.close();
  }
}

/// 网络状态结果
enum NetworkResult {
  /// 在线（WiFi）
  wifi,

  /// 在线（以太网）
  ethernet,

  /// 在线（移动网络）
  mobile,

  /// 在线（VPN）
  vpn,

  /// 在线（蓝牙）
  bluetooth,

  /// 在线（其他）
  other,

  /// 离线
  offline,

  /// 未知
  unknown,
}