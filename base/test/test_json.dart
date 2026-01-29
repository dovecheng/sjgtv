import 'package:base/converter.dart';
import 'package:base/log.dart';

void main() {
  Log log = Log('test_json');
  log.d(() => '...');
  List<String>? list = JSONConverter.fromJsonArrayOrNull(["1", "2", "3"]);
  log.d(() => 'list=$list');
  log.d(() => '...');

  String json = """
  {
    "code": 999999,
    "data": {
        "app_url": "https://play.google.com/"
     }
  }
  """;
  Map<String, dynamic> result = JSONConverter.fromJson(json);
  if (result case {'code': 999999, 'data': {'app_url': String _}}) {
    log.d(() => result);
  }
}
