import 'dart:io';

import 'package:base/log.dart';
import 'package:path/path.dart' as path;

export 'analyzer.dart';
export 'coder.dart';
export 'l10n.dart';

/// 日志记录器
final Log log = Log(path.basenameWithoutExtension(Platform.script.path));
