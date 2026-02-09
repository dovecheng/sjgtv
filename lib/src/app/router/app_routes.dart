/// 应用路由常量定义
class AppRoutes {
  AppRoutes._();

  // 根路径
  static const String home = '/';

  // 电影相关
  static const String search = '/search';
  static const String movieDetail = '/movie-detail';
  static const String player = '/player';

  // 源管理
  static const String sourceManage = '/sources';
  static const String sourceForm = '/sources/form';

  // 代理管理
  static const String proxyManage = '/proxies';
  static const String proxyForm = '/proxies/form';

  // 标签管理
  static const String tagManage = '/tags';
  static const String tagForm = '/tags/form';

  // 设置
  static const String settings = '/settings';

  // 二维码
  static const String qrCode = '/qr-code';
}
