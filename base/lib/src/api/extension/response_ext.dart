import 'package:base/api.dart';
import 'package:base/l10n.dart';
import 'package:dio/dio.dart';

extension ResponseExt<T> on Response<T> {
  /// convert [Response] to [Map]
  Map<String, dynamic> toMap() => {
    if (statusCode != 200) 'response.statusCode': statusCode,
    if (statusMessage?.isNotEmpty == true)
      'response.statusMessage': statusMessage!,
    if (headers.map.isNotEmpty) 'response.headers': headers.map,
    'response.data':
        requestOptions.isLoggableData &&
            requestOptions.responseBytes < 1024 * 32
        ? data
        : [
            L10nFileExt.formatBytesSize(requestOptions.responseBytes),
            if (requestOptions.isLoggableData)
              switch (data) {
                Map<String, dynamic> data => {
                  for (var MapEntry(key: String key, value: dynamic value)
                      in data.entries)
                    key: switch (value) {
                      List<dynamic> _ ||
                      Map<String, dynamic> _ => value.runtimeType,
                      String _ =>
                        value.length <= 64
                            ? value
                            : '${value.substring(64)}...',
                      _ => value,
                    },
                },
                _ => data.runtimeType,
              },
          ].join(' '),
  };
}
