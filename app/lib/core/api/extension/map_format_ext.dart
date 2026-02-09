import '../../../core/converter.dart';
import '../../../core/extension.dart';
import 'package:collection/collection.dart';

extension MapFormatExt on Map<String, dynamic> {
  /// format [Map.entries] to string
  String format() => keys
      .map((String key) => key.length)
      .max
      .let(
        (int width) => entries
            .map((MapEntry<String, dynamic> e) {
              String key = e.key.padRight(width);
              String value = JSONConverter.toJsonStringify(e.value);
              return '$key: $value';
            })
            .join('\n'),
      );
}
