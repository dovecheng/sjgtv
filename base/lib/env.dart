import 'dart:io';

export 'package:flutter/src/foundation/constants.dart';

/// * Dart Command Line: true
/// * Flutter Mobile: true
/// * Flutter Desktop: true
/// * Flutter Web: false
/// * Flutter Test: true
const bool kIsNative = bool.fromEnvironment('dart.library.io');

/// * Dart Command Line: false
/// * Flutter Mobile: true
/// * Flutter Desktop: true
/// * Flutter Web: true
/// * Flutter Test: true
const bool kIsGraphic = bool.fromEnvironment('dart.library.ui');

/// * Dart Command Line: false
/// * Flutter Mobile: false
/// * Flutter Desktop: false
/// * Flutter Web: false
/// * Flutter Test: true
final bool kIsTest =
    kIsNative && Platform.environment.containsKey('FLUTTER_TEST');

/// * Dart Command Line: false
/// * Flutter Mobile: true
/// * Flutter Desktop: true
/// * Flutter Web: false
/// * Flutter Test: false
final bool kIsApp = kIsNative && kIsGraphic && !kIsTest;
