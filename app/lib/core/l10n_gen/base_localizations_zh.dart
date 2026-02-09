// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'base_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class BaseLocalizationsZh extends BaseLocalizations {
  BaseLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get apiBadCertificate => 'SSL安全证书验证失败';

  @override
  String get apiBadResponse => '服务器响应错误';

  @override
  String get apiCancel => '已取消加载';

  @override
  String get apiConnectionError => '服务器连接失败';

  @override
  String get apiConnectionTimeout => '连接超时, 请重试';

  @override
  String get apiFormatError => '无效的数据格式';

  @override
  String get apiHandshakeError => '建立安全网络连接时发生错误';

  @override
  String get apiParseError => '无效的数据格式';

  @override
  String get apiReceiveTimeout => '接收数据超时, 请重试';

  @override
  String get apiSendTimeout => '发送数据超时, 请重试';

  @override
  String get apiUnknownError => '未知错误';
}

/// The translations for Chinese, as used in China (`zh_CN`).
class BaseLocalizationsZhCn extends BaseLocalizationsZh {
  BaseLocalizationsZhCn() : super('zh_CN');

  @override
  String get apiBadCertificate => 'SSL安全证书验证失败';

  @override
  String get apiBadResponse => '服务器响应错误';

  @override
  String get apiCancel => '已取消加载';

  @override
  String get apiConnectionError => '服务器连接失败';

  @override
  String get apiConnectionTimeout => '连接超时, 请重试';

  @override
  String get apiFormatError => '无效的数据格式';

  @override
  String get apiHandshakeError => '建立安全网络连接时发生错误';

  @override
  String get apiParseError => '无效的数据格式';

  @override
  String get apiReceiveTimeout => '接收数据超时, 请重试';

  @override
  String get apiSendTimeout => '发送数据超时, 请重试';

  @override
  String get apiUnknownError => '未知错误';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class BaseLocalizationsZhHk extends BaseLocalizationsZh {
  BaseLocalizationsZhHk() : super('zh_HK');

  @override
  String get apiBadCertificate => 'SSL安全證書驗證失敗';

  @override
  String get apiBadResponse => '伺服器內部錯誤';

  @override
  String get apiCancel => '已取消加載';

  @override
  String get apiConnectionError => '連接到伺服器时发生錯誤';

  @override
  String get apiConnectionTimeout => '連接超時, 請重試';

  @override
  String get apiFormatError => '無效的數據格式';

  @override
  String get apiHandshakeError => '建立安全網絡連接時發生錯誤';

  @override
  String get apiParseError => '無效的數據格式';

  @override
  String get apiReceiveTimeout => '接收數據超時, 請重試';

  @override
  String get apiSendTimeout => '發送數據超時, 請重試';

  @override
  String get apiUnknownError => '未知錯誤';
}
