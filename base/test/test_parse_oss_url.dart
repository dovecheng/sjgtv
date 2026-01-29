import 'package:base/base.dart';

void main() {
  Log log = Log('test_parse_oss_url');

  // String url = '';
  String url =
      'https://image-demo.oss-cn-hangzhou.aliyuncs.com/example.jpg?x-oss-process=image/resize,m_fixed,h_100,w_100';

  Uri uri = Uri.parse(url);
  log.d(() => 'uri=$uri');

  Map<String, String> queryParams = Map<String, String>.of(uri.queryParameters);
  log.d(() => 'queryParams=$queryParams');

  String process = queryParams.putIfAbsent(
    'x-oss-process',
    () => 'image/resize',
  );
  log.d(() => 'process=$process');

  List<String> processParamsList = process.split(',');
  log.d(() => 'processParamsList=$processParamsList');

  String processOpt = processParamsList.first;
  log.d(() => 'processOpt=$processOpt');

  Map<String, String> processParamsMap = processParamsList
      .map((String param) {
        List<String> kv = param.split('_');
        if (kv.length == 2) {
          return MapEntry(kv.first, kv.last);
        }
        return null;
      })
      .nonNulls
      .toMap();

  log.d(() => 'processParamsMap=$processParamsMap');

  processParamsMap['w'] = '200';
  processParamsMap['h'] = '200';
  log.d(() => 'processParamsMap=$processParamsMap');

  processParamsList = [processOpt];
  processParamsList.addAll(
    processParamsMap.entries.map<String>(
      (MapEntry<String, String> entry) => '${entry.key}_${entry.value}',
    ),
  );
  log.d(() => 'processParamsList=$processParamsList');

  process = processParamsList.join(',');
  log.d(() => 'process=$process');

  queryParams['x-oss-process'] = process;
  log.d(() => 'queryParams=$queryParams');

  uri = uri.replace(queryParameters: queryParams);
  log.d(() => 'uri.decode=${Uri.decodeQueryComponent(uri.toString())}');
}
