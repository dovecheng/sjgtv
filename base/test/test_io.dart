import 'dart:convert';
import 'dart:io';

import 'package:base/log.dart';

void main() {
  Log log = Log('test_io');
  log.d(() => '${Directory.current}');

  File file = File('test/test_io.dart');
  RandomAccessFile read = file.openSync();
  List<int> line = [];
  while (true) {
    int byte = read.readByteSync();
    if (byte == -1 || byte == 10 || byte == 13) {
      break;
    }
    line.add(byte);
  }
  read.closeSync();
  String firstLine = utf8.decode(line);
  log.d(() => firstLine);

  log.d(() => '${Platform.numberOfProcessors}');
}
