# 自动化测试方案

## 1. 测试目标

### 1.1 主要目标
- 验证应用在真机设备上的功能正确性
- 测试多平台兼容性（TV、平板、桌面）
- 发现运行时错误和类型转换问题
- 验证 UI 布局和焦点管理
- 测试关键用户流程（首页、搜索、设置等）

### 1.2 测试范围
- 首页（分类导航、轮播图、影片列表）
- 搜索页面（输入、搜索结果）
- 设置页面
- 影片详情页
- 播放功能（如有）

## 2. 测试设备

| 设备 | 平台 | 分辨率 | 连接方式 | 用途 |
|------|------|--------|----------|------|
| HK1 RBOX K8 | Android 13 | 1920x1080 | ADB Network | TV 测试 |
| Samsung Tab A8 | Android 11 | 1200x1920 | ADB Network | 平板测试 |
| Linux Desktop | Linux | N/A | 本地运行 | 桌面测试 |

## 3. 测试流程

### 3.1 准备阶段
1. 清空 screenshots 目录
2. 检查设备连接状态
3. 编译最新的 Debug APK
4. 在所有设备上安装 APK
5. 启动应用并等待完全加载

### 3.2 测试阶段
对每个页面执行以下步骤：
1. 导航到目标页面
2. 等待页面完全加载（动态等待时间）
3. 使用 Dart MCP 获取 UI 状态（焦点、Widget 树）
4. 截图（仅在页面完全加载后）
5. 验证 UI 状态是否正确
6. 记录测试结果

### 3.3 清理阶段
1. 删除无效截图
2. 生成测试报告
3. 提交测试结果

## 4. 等待时间策略

### 4.1 固定等待时间
- 应用启动：10-15 秒（Debug 版本较慢）
- 页面导航：3-5 秒
- 键盘弹出：2-3 秒
- 搜索结果加载：5-10 秒

### 4.2 动态等待机制
```dart
// 使用 Dart MCP 获取 Widget 树，判断页面是否加载完成
bool isPageLoaded = false;
int maxRetries = 10;
int retryCount = 0;

while (!isPageLoaded && retryCount < maxRetries) {
  await Future.delayed(Duration(seconds: 1));
  
  // 获取 Widget 树
  final widgetTree = await getWidgetTree();
  
  // 检查关键 Widget 是否存在
  isPageLoaded = widgetTree.contains('搜索结果') || 
                 widgetTree.contains('影片列表');
  
  retryCount++;
}
```

### 4.3 等待时间矩阵
| 操作 | 最小等待 | 最大等待 | 推荐等待 |
|------|----------|----------|----------|
| 应用启动 | 10s | 20s | 15s |
| 首页加载 | 5s | 10s | 8s |
| 导航到搜索 | 3s | 5s | 4s |
| 键盘弹出 | 2s | 4s | 3s |
| 输入文字 | 1s | 2s | 1s |
| 搜索结果 | 5s | 15s | 10s |
| 页面切换 | 3s | 5s | 4s |

## 5. 截图管理策略

### 5.1 截图命名规范
```
{device}_{page}_{action}_{timestamp}.{status}.png

示例：
- tv_home_loaded_20260210_032500.png
- tablet_search_input_20260210_033010.png
- tablet_search_results_20260210_033015.png
```

### 5.2 截图验证机制
在保存截图前，使用 Dart MCP 验证：
```dart
// 获取 Widget 树
final widgetTree = await getWidgetTree();

// 验证关键元素
bool isValid = widgetTree.contains('搜索结果') && 
               widgetTree.contains('搜索结果 (100)');

if (isValid) {
  await screenshot('tv_search_results_valid.png');
} else {
  // 删除无效截图
  await deleteScreenshot('tv_search_results_invalid.png');
  // 记录错误
  logError('搜索结果页面验证失败');
}
```

### 5.3 无效截图清理
```bash
# 定期清理空截图或过小的截图
find screenshots/ -name "*.png" -size -10k -delete

# 清理重复截图
# 比较截图的哈希值，删除重复项
```

## 6. Dart MCP 使用策略

### 6.1 获取 UI 状态
```dart
// 获取 Widget 树
final widgetTree = await getWidgetTree(summaryOnly: false);

// 获取焦点状态
final activeLocation = await getActiveLocation();

// 获取运行时错误
final errors = await getRuntimeErrors();
```

### 6.2 验证 UI 元素
```dart
// 检查特定 Widget 是否存在
bool hasElement(String elementName) {
  return widgetTree.contains(elementName);
}

// 检查焦点位置
bool isFocusOn(String elementName) {
  return activeLocation.description.contains(elementName);
}
```

### 6.3 捕获运行时错误
```dart
// 获取运行时错误
final errors = await getRuntimeErrors();

if (errors.isNotEmpty) {
  // 记录错误详情
  for (var error in errors) {
    logError('运行时错误: ${error.message}');
    logError('堆栈: ${error.stackTrace}');
  }
  
  // 如果是严重错误，停止测试
  if (errors.any((e) => e.isFatal)) {
    throw TestException('发现严重运行时错误');
  }
}
```

## 7. 布局验证策略

### 7.1 重要性
布局问题是移动应用中常见的问题，包括：
- 文字溢出（下半身被遮挡）
- 元素重叠
- 布局错位
- 响应式适配失败
- 多设备显示不一致

这些问题在真机测试中容易被忽略，但会严重影响用户体验。必须通过自动化测试主动发现并修复。

### 7.2 图片分析提示词模板

每次截图后，使用以下标准提示词进行分析：

```dart
String buildLayoutAnalysisPrompt(String context) {
  return '''
作为专业 UI 测试工程师，请仔细分析这个${context}界面的截图，重点检查以下布局问题：

## 必须检查的布局问题

### 1. 文字显示问题
- [ ] 文字是否被遮挡或截断（特别是下半身）
- [ ] 文字是否超出容器边界
- [ ] 文字是否与其他元素重叠
- [ ] 文字是否显示不完整（如 "..." 截断）
- [ ] 多行文字是否正确换行
- [ ] 文字大小是否合适（太大/太小）

### 2. 元素布局问题
- [ ] 元素是否超出屏幕边界
- [ ] 元素之间是否有不必要的重叠
- [ ] 元素间距是否合理（太密/太疏）
- [ ] 元素对齐是否正确（左对齐/居中/右对齐）
- [ ] 元素大小是否符合设计规范

### 3. 焦点和交互问题
- [ ] 焦点指示器是否完整显示
- [ ] 焦点边框是否被遮挡
- [ ] 按钮是否完整可点击
- [ ] 可点击区域是否足够大

### 4. 响应式适配问题
- [ ] 布局是否适应当前屏幕尺寸
- [ ] 横竖屏切换时布局是否正常
- [ ] 不同设备上显示是否一致

### 5. 视觉一致性问题
- [ ] 颜色是否一致
- [ ] 字体是否统一
- [ ] 图标是否对齐
- [ ] 圆角、边框是否一致

## 输出要求

请按以下格式输出：

### 布局问题报告
**发现的布局问题：**
1. [严重/中等/轻微] 问题描述
   - 位置：具体坐标或元素名称
   - 影响：对用户体验的影响
   - 建议修复：具体的修复建议

2. [严重/中等/轻微] 问题描述
   - ...

**无布局问题：**
如果所有检查项都正常，明确说明："✅ 未发现布局问题"

### 界面状态
- 当前页面：[页面名称]
- 主要元素：[列出主要 UI 元素]
- 焦点位置：[当前焦点的元素]
- 整体评估：[正常/需要改进]

### 截图有效性
- 截图是否清晰可见
- 关键元素是否完整显示
- 是否可以用于后续分析

**重要：如果发现文字被遮挡或截断，必须明确指出具体位置和修复建议！**
''';
}
```

### 7.3 布局验证流程

```dart
class LayoutValidator {
  static Future<LayoutValidationResult> validateScreenshot(
    String screenshotPath,
    String context,
  ) async {
    // 构建布局分析提示词
    final prompt = buildLayoutAnalysisPrompt(context);
    
    // 使用图片分析工具
    final analysis = await imageRead(
      imageInput: screenshotPath,
      inputType: 'file_path',
      prompt: prompt,
      taskBrief: '布局验证: $context',
    );
    
    // 解析分析结果
    final result = parseAnalysisResult(analysis);
    
    // 如果发现布局问题，记录详细信息
    if (result.hasIssues) {
      TestLogger.warning('发现布局问题: ${context}');
      for (var issue in result.issues) {
        TestLogger.warning('  - ${issue.severity}: ${issue.description}');
        TestLogger.warning('    位置: ${issue.location}');
        TestLogger.warning('    建议: ${issue.suggestion}');
      }
      
      // 保存带有问题标记的截图
      await screenshot(
        '${context}_layout_issues.png',
        annotate: true,
        issues: result.issues,
      );
    } else {
      TestLogger.info('布局验证通过: $context');
    }
    
    return result;
  }
}
```

### 7.4 常见布局问题及修复建议

| 问题类型 | 表现 | 严重性 | 修复建议 |
|---------|------|--------|---------|
| 文字溢出 | 文字下半身被遮挡 | 严重 | 增加 Text 组件的 maxLines，使用 Expanded/Flexible 包裹 |
| 元素重叠 | 按钮或图标重叠在一起 | 严重 | 调整布局约束，使用 Stack 的 Positioned |
| 容器溢出 | 内容超出容器边界 | 严重 | 添加 OverflowBox 或调整容器大小 |
| 间距不当 | 元素太密或太疏 | 中等 | 使用 SizedBox 或 EdgeInsets 调整间距 |
| 对齐错误 | 元素未对齐 | 中等 | 使用 Align 或 CrossAxisAlignment 调整 |
| 响应式失效 | 不同设备显示不一致 | 严重 | 使用 MediaQuery、LayoutBuilder 或响应式组件 |
| 焦点遮挡 | 焦点边框被遮挡 | 中等 | 调整 FocusIndicator 的 decoration |
| 字体异常 | 字体大小不统一 | 轻微 | 统一使用 TextTheme 或定义字体常量 |

### 7.5 布局验证在测试流程中的位置

```dart
class PageTester {
  Future<void> testHomePage() async {
    TestLogger.info('测试首页: ${device.name}');
    
    // 1. 启动应用并等待加载
    await startApp();
    await waitForLoad(expectedElements: ['热门', '最新', '经典']);
    
    // 2. 截图
    final screenshotPath = await screenshot('${device.name}_home.png');
    
    // 3. 布局验证（重要！）
    final layoutResult = await LayoutValidator.validateScreenshot(
      screenshotPath,
      '首页',
    );
    
    // 4. 如果发现严重布局问题，停止测试
    if (layoutResult.hasCriticalIssues) {
      throw TestException(
        '首页发现严重布局问题: ${layoutResult.criticalIssue}',
      );
    }
    
    // 5. 继续其他验证
    final widgetTree = await getWidgetTree();
    final errors = await getRuntimeErrors();
    
    // 6. 记录测试结果
    assert(errors.isEmpty, '首页存在运行时错误');
    assert(widgetTree.contains('热门'), '首页缺少热门标签');
  }
}
```

### 7.6 布局问题追踪

```dart
class LayoutIssueTracker {
  static final List<LayoutIssue> _issues = [];
  
  static void recordIssue(LayoutIssue issue) {
    _issues.add(issue);
    
    // 写入到布局问题日志
    final logFile = File('logs/layout_issues.log');
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] ${issue.severity}: ${issue.description}\n';
    logFile.writeAsStringSync(logEntry, mode: FileMode.append);
  }
  
  static List<LayoutIssue> getIssues() => List.unmodifiable(_issues);
  
  static List<LayoutIssue> getCriticalIssues() {
    return _issues.where((issue) => issue.severity == IssueSeverity.critical).toList();
  }
  
  static void clear() {
    _issues.clear();
  }
}

class LayoutIssue {
  final String description;
  final IssueSeverity severity;
  final String location;
  final String suggestion;
  final String screenshotPath;
  final DateTime timestamp;
  
  LayoutIssue({
    required this.description,
    required this.severity,
    required this.location,
    required this.suggestion,
    required this.screenshotPath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

enum IssueSeverity {
  critical,  // 严重，必须立即修复
  high,      // 高，应该尽快修复
  medium,    // 中等，可以延后修复
  low,       // 轻微，可以忽略
}
```

### 7.7 布局验证的自动化检查清单

每个页面测试时，自动检查以下内容：

```dart
final layoutChecklist = [
  '文字是否完整显示',
  '文字是否被遮挡',
  '元素是否超出边界',
  '元素是否重叠',
  '焦点指示器是否完整',
  '按钮是否可点击',
  '布局是否适应屏幕',
  '间距是否合理',
  '对齐是否正确',
  '颜色是否一致',
];
```

## 8. 日志记录策略

### 7.1 应用日志
```bash
# 在测试开始前清空 logcat
adb -s {device_id} logcat -c

# 持续记录日志到文件
adb -s {device_id} logcat -v time > logs/{device_id}_{timestamp}.log &
```

### 7.2 路由日志
在应用中添加路由日志记录：
```dart
class MyRouterDelegate extends RouterDelegate<AppRouteState> {
  @override
  Future<void> setNewRoutePath(AppRouteState configuration) async {
    // 记录路由变化
    Log.d('Router')('路由变化: ${configuration.uri}');
    
    // 继续原有逻辑
    // ...
  }
}
```

### 7.3 测试日志
```dart
class TestLogger {
  static void log(String level, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final logEntry = '[$timestamp] [$level] $message\n';
    
    // 写入测试日志文件
    File('logs/test.log').writeAsStringSync(logEntry, mode: FileMode.append);
    
    // 同时输出到控制台
    print(logEntry);
  }
  
  static void info(String message) => log('INFO', message);
  static void warning(String message) => log('WARNING', message);
  static void error(String message) => log('ERROR', message);
}
```


### 7.4 ADB MCP 日志过滤功能

ADB MCP 提供了强大的日志过滤功能，可以精确捕获和分析应用日志。

#### 7.4.1 基本用法

```dart
// 获取指定标签的日志
final flutterLogs = await get_logcat(
  device_id: '192.168.3.158:5555',
  tag: 'flutter',
  lines: 100,
);

// 获取错误级别的日志
final errorLogs = await get_logcat(
  device_id: '192.168.3.158:5555',
  level: 'E',
  lines: 50,
);

// 获取应用日志
final logs = await get_logcat(
  device_id: '192.168.3.158:5555',
  tag: 'sjgtv',
  lines: 200,
);
```

#### 7.4.2 日志级别说明

- `V` (Verbose): 详细的调试信息
- `D` (Debug): 调试信息
- `I` (Info): 一般信息
- `W` (Warning): 警告信息
- `E` (Error): 错误信息

#### 7.4.3 测试中的日志过滤策略

```dart
class LogCollector {
  final String deviceId;
  
  LogCollector(this.deviceId);
  
  /// 收集所有错误日志
  Future<List<String>> collectErrorLogs() async {
    return await get_logcat(
      device_id: deviceId,
      level: 'E',
      lines: 100,
    );
  }
  
  /// 收集应用特定日志
  Future<List<String>> collectAppLogs() async {
    return await get_logcat(
      device_id: deviceId,
      tag: 'sjgtv',
      lines: 200,
    );
  }
  
  /// 清空日志缓冲区
  Future<void> clearLogs() async {
    await run_shell_command(
      command: 'adb -s $deviceId logcat -c',
      description: '清空 logcat 日志',
    );
  }
}
```

#### 7.4.4 测试流程中的日志收集

```dart
class TestLogManager {
  final String deviceId;
  final LogCollector collector;
  
  TestLogManager(this.deviceId) : collector = LogCollector(deviceId);
  
  /// 开始测试前清空日志
  Future<void> startTest() async {
    await collector.clearLogs();
    TestLogger.info('已清空设备 $deviceId 的日志缓冲区');
  }
  
  /// 测试后收集日志
  Future<void> collectLogs(String testName) async {
    // 收集错误日志
    final errorLogs = await collector.collectErrorLogs();
    if (errorLogs.isNotEmpty) {
      TestLogger.error('$testName 发现 ${errorLogs.length} 条错误日志');
      _saveLogs(errorLogs, 'logs/${deviceId}_${testName}_errors.log');
    }
    
    // 收集应用日志
    final appLogs = await collector.collectAppLogs();
    _saveLogs(appLogs, 'logs/${deviceId}_${testName}_app.log');
  }
  
  void _saveLogs(List<String> logs, String filename) {
    final file = File(filename);
    file.writeAsStringSync(logs.join(\n'));
  }
}
```

#### 7.4.5 常见日志过滤模式

| 用途 | 参数 | 说明 |
|------|------|------|
| 清空日志 | `logcat -c` | 测试前清空缓冲区 |
| 捕获所有错误 | `level: 'E'` | 获取所有错误级别日志 |
| 捕获应用日志 | `tag: 'sjgtv'` | 只获取应用相关日志 |
| 捕获特定错误 | `tag: 'flutter', level: 'E'` | 捕获 Flutter 框架错误 |
| 保存到文件 | 写入 `.log` 文件 | 用于后续分析 |

#### 7.4.6 最佳实践

1. **测试前清空日志**：避免历史日志干扰
2. **按标签过滤**：只捕获应用相关日志
3. **优先捕获错误**：使用 `level: 'E'` 快速定位问题
4. **分类保存日志**：错误日志、应用日志分开存储
5. **自动分析日志**：在测试报告中包含日志分析结果

## 8. 测试脚本结构

### 8.1 主测试脚本
```dart
void main() async {
  final tester = AutomatedTester();
  
  try {
    // 准备阶段
    await tester.prepare();
    
    // 测试 TV 设备
    await tester.testDevice(Device.tv);
    
    // 测试平板设备
    await tester.testDevice(Device.tablet);
    
    // 生成报告
    await tester.generateReport();
    
  } catch (e) {
    TestLogger.error('测试失败: $e');
    rethrow;
  } finally {
    // 清理
    await tester.cleanup();
  }
}
```

### 8.2 页面测试类
```dart
class PageTester {
  final Device device;
  
  PageTester(this.device);
  
  Future<void> testHomePage() async {
    TestLogger.info('测试首页: ${device.name}');
    
    // 启动应用
    await startApp();
    await waitForLoad(expectedElements: ['热门', '最新', '经典']);
    
    // 验证 UI 状态
    final widgetTree = await getWidgetTree();
    final errors = await getRuntimeErrors();
    
    // 截图
    await screenshot('${device.name}_home_loaded.png');
    
    // 验证结果
    assert(errors.isEmpty, '首页存在运行时错误');
    assert(widgetTree.contains('热门'), '首页缺少热门标签');
  }
  
  Future<void> testSearchPage() async {
    TestLogger.info('测试搜索页面: ${device.name}');
    
    // 导航到搜索
    await navigateToSearch();
    await waitForLoad(expectedElements: ['搜索电影、电视剧']);
    
    // 输入关键词
    await inputText('movie');
    await waitForLoad(expectedElements: ['搜索结果']);
    
    // 获取 UI 状态
    final widgetTree = await getWidgetTree();
    final errors = await getRuntimeErrors();
    
    // 验证搜索结果
    final hasResults = widgetTree.contains('搜索结果 (');
    if (hasResults) {
      await screenshot('${device.name}_search_results_valid.png');
    } else {
      await deleteScreenshot('${device.name}_search_results_invalid.png');
      throw TestException('搜索结果页面验证失败');
    }
  }
}
```

## 9. 错误处理

### 9.1 常见错误类型
- 应用启动失败
- 页面加载超时
- 找不到 UI 元素
- 运行时错误（类型转换、空指针等）
- 网络请求失败
- 截图失败

### 9.2 错误恢复策略
```dart
try {
  await performAction();
} on TimeoutException {
  TestLogger.warning('操作超时，重试...');
  await retryAction(maxRetries: 3);
} on NotFoundException {
  TestLogger.error('找不到 UI 元素');
  await screenshot('error_element_not_found.png');
  throw;
} on RuntimeException catch (e) {
  TestLogger.error('运行时错误: ${e.message}');
  await getRuntimeErrors();
  await screenshot('error_runtime.png');
  throw;
}
```

## 10. 测试报告

### 10.1 报告内容
- 测试概览（设备、时间、结果）
- 每个页面的测试详情
- 截图列表
- 错误日志
- 性能指标（加载时间、响应时间）

### 10.2 报告格式
```markdown
# 自动化测试报告

## 测试概览
- 测试时间: 2026-02-10 03:00:00
- 测试设备: TV, 平板, Linux
- 总测试用例: 15
- 通过: 14
- 失败: 1

## 设备测试详情

### TV 设备 (HK1 RBOX K8)
- 首页: ✅ 通过
- 搜索页面: ✅ 通过
- 设置页面: ✅ 通过

### 平板设备 (Samsung Tab A8)
- 首页: ✅ 通过
- 搜索页面: ❌ 失败（无法点击搜索图标）

## 错误日志
[详细错误信息]

## 截图列表
[截图文件列表]
```

## 11. 持续集成

### 11.1 自动化触发
- 每次提交后自动运行
- 定时任务（每天凌晨）
- 手动触发

### 11.2 CI/CD 配置
```yaml
# .github/workflows/test.yml
name: 自动化测试

on:
  push:
    branches: [dev, main]
  schedule:
    - cron: '0 2 * * *'  # 每天凌晨 2 点

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: 设置 Flutter
        uses: subosito/flutter-action@v2
      - name: 安装依赖
        run: flutter pub get
      - name: 编译 APK
        run: flutter build apk --debug
      - name: 运行自动化测试
        run: dart script/automated_test.dart
      - name: 上传测试报告
        uses: actions/upload-artifact@v2
        with:
          name: test-report
          path: reports/
```

## 12. 改进建议

### 12.1 短期改进
1. 实现动态等待机制
2. 添加截图验证
3. 完善日志记录
4. 自动清理无效截图

### 12.2 长期改进
1. 集成测试框架（如 Patrol、Appium）
2. 添加性能监控
3. 实现回归测试
4. 自动化报告生成
5. CI/CD 集成

## 13. 附录

### 13.1 工具和命令
```bash
# 检查设备连接
adb devices

# 启动应用
adb -s {device_id} shell am start -n com.sjg.tv/.MainActivity

# 截图
adb -s {device_id} shell screencap -p > screenshot.png

# 获取日志
adb -s {device_id} logcat -v time

# 安装 APK
adb -s {device_id} install -r app-debug.apk

# 卸载应用
adb -s {device_id} uninstall com.sjg.tv
```

### 13.2 Dart MCP 工具
- `get_widget_tree`: 获取 Widget 树
- `get_active_location`: 获取当前焦点位置
- `get_runtime_errors`: 获取运行时错误
- `hot_reload`: 热重载
- `hot_restart`: 热重启

### 13.3 参考资源
- Flutter Testing: https://flutter.dev/docs/testing
- Android ADB: https://developer.android.com/studio/command-line/adb
- Dart MCP Documentation