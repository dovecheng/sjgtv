# 使用 Dart MCP 获取控件坐标并用 ADB 模拟点击

## 方案概述

通过 Dart MCP 获取 Flutter Widget 树信息，提取目标控件的坐标，然后使用 ADB 命令模拟点击。这样可以实现精准的自动化测试，而不需要猜测坐标。

## 前置条件

1. 应用在 Debug 模式下运行（Release 模式会禁用调试功能）
2. 已连接到 Dart Tooling Daemon (DTD)
3. 设备通过 ADB 连接

## 实现步骤

### 1. 连接到 Dart Tooling Daemon

```dart
// 需要先获取 DTD URI
// 通常在应用启动时，Flutter 会输出 DTD URI
// 格式类似：ws://127.0.0.1:xxxxx/xxx

// 方法1：从应用日志中提取
adb -s {device_id} logcat -d | grep "The Dart VM service is listening on"

// 方法2：从 Flutter DevTools 获取
// 运行应用时会输出类似：
// Observatory listening on http://127.0.0.1:xxxxx/
// DTD URI: ws://127.0.0.1:xxxxx/xxx
```

### 2. 获取 Widget 树

```dart
// 使用 Dart MCP 工具获取 Widget 树
final widgetTree = await getWidgetTree(summaryOnly: false);

// Widget 树数据结构示例
{
  "type": "Widget",
  "runtimeType": "MaterialApp",
  "children": [
    {
      "type": "Widget",
      "runtimeType": "Scaffold",
      "children": [
        {
          "type": "Widget",
          "runtimeType": "AppBar",
          "properties": {
            "title": "首页"
          },
          // 可能包含位置信息
          "renderObject": {
            "paintBounds": {
              "left": 0.0,
              "top": 0.0,
              "right": 1920.0,
              "bottom": 200.0
            }
          }
        },
        {
          "type": "Widget",
          "runtimeType": "Container",
          "properties": {
            "child": {
              "type": "Widget",
              "runtimeType": "Text",
              "properties": {
                "data": "搜索"
              },
              "renderObject": {
                "paintBounds": {
                  "left": 1720.0,
                  "top": 50.0,
                  "right": 1800.0,
                  "right": 90.0
                }
              }
            }
          }
        }
      ]
    }
  ]
}
```

### 3. 提取目标控件坐标

```dart
class WidgetCoordinateFinder {
  static Map<String, double>? findWidgetCoordinates(
    Map<String, dynamic> widgetTree,
    String targetRuntimeType, {
    String? targetText,
    String? targetKey,
  }) {
    // 递归搜索 Widget 树
    final result = _searchWidget(
      widgetTree,
      targetRuntimeType,
      targetText: targetText,
      targetKey: targetKey,
    );

    if (result == null) {
      print('未找到目标控件: $targetRuntimeType');
      return null;
    }

    // 提取坐标信息
    final renderObject = result['renderObject'];
    if (renderObject == null) {
      print('控件没有 renderObject 信息');
      return null;
    }

    final paintBounds = renderObject['paintBounds'];
    if (paintBounds == null) {
      print('控件没有 paintBounds 信息');
      return null;
    }

    // 计算中心点坐标
    final left = paintBounds['left'] as double;
    final top = paintBounds['top'] as double;
    final right = paintBounds['right'] as double;
    final bottom = paintBounds['bottom'] as double;

    final centerX = (left + right) / 2;
    final centerY = (top + bottom) / 2;

    print('找到控件: $targetRuntimeType');
    print('  位置: left=$left, top=$top, right=$right, bottom=$bottom');
    print('  中心点: ($centerX, $centerY)');

    return {
      'x': centerX,
      'y': centerY,
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    };
  }

  static Map<String, dynamic>? _searchWidget(
    Map<String, dynamic> widget,
    String targetRuntimeType, {
    String? targetText,
    String? targetKey,
  }) {
    // 检查当前 Widget 是否匹配
    final runtimeType = widget['runtimeType'] as String?;
    if (runtimeType == targetRuntimeType) {
      // 检查文本匹配
      if (targetText != null) {
        final properties = widget['properties'] as Map<String, dynamic>?;
        if (properties != null) {
          final data = properties['data'] as String?;
          if (data != null && data.contains(targetText)) {
            return widget;
          }
        }
      }

      // 检查 Key 匹配
      if (targetKey != null) {
        final properties = widget['properties'] as Map<String, dynamic>?;
        if (properties != null) {
          final key = properties['key'] as String?;
          if (key != null && key.contains(targetKey)) {
            return widget;
          }
        }
      }

      // 如果没有额外的匹配条件，直接返回
      if (targetText == null && targetKey == null) {
        return widget;
      }
    }

    // 递归搜索子 Widget
    final children = widget['children'] as List<dynamic>?;
    if (children != null) {
      for (final child in children) {
        if (child is Map<String, dynamic>) {
          final result = _searchWidget(
            child,
            targetRuntimeType,
            targetText: targetText,
            targetKey: targetKey,
          );
          if (result != null) {
            return result;
          }
        }
      }
    }

    return null;
  }
}
```

### 4. 使用 ADB 模拟点击

```dart
class AdbClicker {
  static Future<void> tap(String deviceId, double x, double y) async {
    // 使用 ADB 命令模拟点击
    final command = 'adb -s $deviceId shell input tap $x $y';
    final result = await run_shell_command(
      command: command,
      description: '点击坐标 ($x, $y)',
    );

    if (result.error != null) {
      throw Exception('ADB 点击失败: ${result.error}');
    }

    print('成功点击坐标: ($x, $y)');
  }

  static Future<void> tapWidget(
    String deviceId,
    Map<String, double> coordinates,
  ) async {
    final x = coordinates['x']!;
    final y = coordinates['y']!;

    await tap(deviceId, x, y);
  }
}
```

### 5. 完整示例

```dart
Future<void> automatedTest() async {
  final deviceId = '192.168.3.158:5555';

  try {
    // 1. 连接到 Dart Tooling Daemon
    // 假设 DTD URI 已知
    final dtdUri = 'ws://127.0.0.1:xxxxx/xxx';
    await connect_dart_tooling_daemon(uri: dtdUri);

    // 2. 获取 Widget 树
    final widgetTree = await get_widget_tree(summaryOnly: false);

    // 3. 查找搜索按钮
    final searchButtonCoords = WidgetCoordinateFinder.findWidgetCoordinates(
      widgetTree,
      'Text',
      targetText: '搜索',
    );

    if (searchButtonCoords == null) {
      print('未找到搜索按钮');
      return;
    }

    // 4. 使用 ADB 点击搜索按钮
    await AdbClicker.tapWidget(deviceId, searchButtonCoords);

    // 5. 等待页面切换
    await Future.delayed(Duration(seconds: 3));

    // 6. 查找搜索框
    final searchBoxCoords = WidgetCoordinateFinder.findWidgetCoordinates(
      widgetTree,
      'TextField',
    );

    if (searchBoxCoords != null) {
      // 点击搜索框获取焦点
      await AdbClicker.tapWidget(deviceId, searchBoxCoords);

      // 输入文字
      await run_shell_command(
        command: 'adb -s $deviceId shell input text "movie"',
        description: '输入搜索关键词',
      );
    }

  } catch (e) {
    print('自动化测试失败: $e');
  }
}
```

## Widget 树坐标信息说明

### 可能的坐标字段

根据 Flutter 的实现，Widget 树中的 `renderObject` 可能包含以下坐标信息：

```dart
// RenderObject 的 paintBounds
{
  "left": 0.0,      // 左边界（相对于父容器）
  "top": 0.0,       // 上边界
  "right": 1920.0,  // 右边界
  "bottom": 200.0,  // 下边界
}

// 或者使用 Rect 格式
{
  "rect": {
    "x": 0.0,
    "y": 0.0,
    "width": 1920.0,
    "height": 200.0
  }
}
```

### 坐标转换

如果坐标是相对于父容器的，需要递归计算全局坐标：

```dart
class GlobalCoordinateCalculator {
  static Map<String, double> calculateGlobalCoordinates(
    Map<String, dynamic> widget,
    Map<String, dynamic>? parentCoords,
  ) {
    final renderObject = widget['renderObject'];
    if (renderObject == null) {
      return parentCoords ?? {'x': 0, 'y': 0};
    }

    final paintBounds = renderObject['paintBounds'];
    if (paintBounds == null) {
      return parentCoords ?? {'x': 0, 'y': 0};
    }

    final left = paintBounds['left'] as double;
    final top = paintBounds['top'] as double;

    // 加上父容器的偏移
    final parentX = parentCoords?['x'] ?? 0;
    final parentY = parentCoords?['y'] ?? 0;

    return {
      'x': parentX + left,
      'y': parentY + top,
    };
  }
}
```

## 实际测试方法

### 方法 1：使用 Flutter Driver（推荐）

```dart
import 'package:flutter_driver/flutter_driver.dart';

void main() async {
  final FlutterDriver driver = await FlutterDriver.connect();

  // 查找 Widget 并点击
  final searchButton = find.text('搜索');
  await driver.tap(searchButton);

  // 或者通过 Key 查找
  final searchBox = find.byValueKey('search_box');
  await driver.tap(searchBox);

  // 输入文字
  await driver.enterText('movie');

  await driver.close();
}
```

### 方法 2：使用 Dart MCP + ADB（本文档方案）

优势：
- 可以获取更详细的 Widget 信息
- 可以同时检查 Widget 属性和坐标
- 可以进行更复杂的验证

劣势：
- 需要手动解析 Widget 树
- 坐标计算可能复杂
- 需要处理各种边界情况

### 方法 3：使用 image_read + 点击坐标

```dart
// 使用图片识别找到目标元素的位置
final analysis = await image_read(
  image_input: 'screenshot.png',
  prompt: '找出搜索按钮的位置，返回坐标',
);

// 解析分析结果获取坐标
final coords = parseCoordinates(analysis);

// 使用 ADB 点击
await run_shell_command(
  command: 'adb shell input tap $x $y',
);
```

## 工具类实现

```dart
class AutomatedTester {
  final String deviceId;
  String? dtdUri;

  AutomatedTester(this.deviceId);

  Future<void> connect() async {
    // 从日志中提取 DTD URI
    final result = await run_shell_command(
      command: 'adb -s $deviceId logcat -d | grep "The Dart VM service is listening on"',
      description: '获取 DTD URI',
    );

    // 解析 URI
    // ...
  }

  Future<void> tapByText(String text) async {
    final widgetTree = await get_widget_tree(summaryOnly: false);
    final coords = WidgetCoordinateFinder.findWidgetCoordinates(
      widgetTree,
      'Text',
      targetText: text,
    );

    if (coords != null) {
      await AdbClicker.tapWidget(deviceId, coords);
    }
  }

  Future<void> tapByKey(String key) async {
    final widgetTree = await get_widget_tree(summaryOnly: false);
    final coords = WidgetCoordinateFinder.findWidgetCoordinates(
      widgetTree,
      'Widget',
      targetKey: key,
    );

    if (coords != null) {
      await AdbClicker.tapWidget(deviceId, coords);
    }
  }
}
```

## 注意事项

1. **坐标精度**：ADB 点击的坐标可能需要微调（+/- 5 像素）
2. **Widget 变化**：Widget 树可能在不同时间点不同，需要动态获取
3. **性能影响**：频繁获取 Widget 树可能影响应用性能
4. **Debug 模式**：此方法仅在 Debug 模式下有效
5. **异步操作**：所有操作都是异步的，需要正确处理 Future

## 优化建议

1. **缓存 Widget 树**：避免频繁获取 Widget 树
2. **批量操作**：一次性获取多个 Widget 的坐标
3. **错误重试**：添加重试机制处理网络或连接问题
4. **日志记录**：详细记录每一步操作用于调试
5. **坐标验证**：点击前验证坐标是否在有效范围内

## 参考资源

- Flutter Driver: https://flutter.dev/docs/cookbook/testing/integration/introduction
- Dart VM Service Protocol: https://github.com/dart-lang/sdk/blob/main/runtime/vm/service/service.md
- ADB Input: https://developer.android.com/studio/command-line/adb#input