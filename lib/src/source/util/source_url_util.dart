import 'package:sjgtv/src/proxy/model/proxy_model.dart';

/// 去掉重复的 vod/api.php/provide/，保证格式为 https://{domain}/api.php/provide/vod。
String normalizeSourceBase(String url) {
  const String duplicate = '/vod/api.php/provide/';
  if (url.contains(duplicate)) {
    return url.replaceFirst(duplicate, '/');
  }
  return url;
}

/// 使用代理时：代理 origin + 规范化源 URL，格式为 https://{proxy}/https://{domain}/api.php/provide/vod。
String resolveSourceBaseUrl(ProxyModel? proxy, String sourceUrl) {
  final String normalized = normalizeSourceBase(sourceUrl);
  if (proxy == null) return normalized;
  final bool sourceIsAbsolute =
      normalized.startsWith('http://') || normalized.startsWith('https://');
  if (sourceIsAbsolute) {
    final Uri uri = Uri.parse(proxy.url);
    final String origin =
        '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}/';
    return origin + normalized;
  }
  return proxy.url;
}
