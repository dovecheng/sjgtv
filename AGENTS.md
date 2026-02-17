# AGENTS.md - SJGTV 开发指南

本文档为 AI Agent 提供开发规范和命令参考。

---

## 1. 快速命令

### 构建与运行
```bash
# 运行应用（默认调试模式）
flutter run

# 构建 APK
flutter build apk --debug
flutter build apk --release

# 构建 Web
flutter build web --release
```

### 代码分析
```bash
# 分析代码（推荐每次修改后运行）
flutter analyze

# 修复代码风格问题
dart fix --apply

# 检查代码格式
dart format --set-exit-if-changed .
```

### 测试
```bash
# 运行所有测试
flutter test

# 运行单个测试文件
flutter test test/domain/usecases/add_source_usecase_test.dart

# 运行单个测试用例（按名称过滤）
flutter test --name "AddSourceUseCase 应该成功添加视频源"

# 运行测试并显示详细输出
flutter test --reporter expanded

# 运行测试并生成覆盖率报告
flutter test --coverage
```

### 代码生成
```bash
# 运行 build_runner（当修改了需要生成的代码时）
dart run build_runner build --delete-conflicting-outputs

# 重新生成 Riverpod Provider
dart run riverpod_generator build

# 重新生成国际化
flutter gen-l10n
```

### 其他
```bash
# 获取依赖
flutter pub get

# 更新依赖（检查新版本）
flutter pub outdated

# 清理并重新构建
flutter clean && flutter pub get
```

---

## 2. 代码规范

### 语言要求（来自 .cursorrules）
- **必须使用简体中文**回复：对话、解释、错误提示、总结
- Git 提交消息必须使用中文
- 代码注释必须使用中文

### 类型声明（强制）
- 所有变量、方法参数、返回值、类字段**必须显式声明类型**
- 示例：
  ```dart
  // ✅ 正确
  final String name;
  Future<void> fetchData() async { ... }
  void onTap(BuildContext context) { ... }
  
  // ❌ 错误
  final name = 'test';
  fetchData() async { ... }
  onTap(context) { ... }
  ```

### const 使用
- 能加 `const` 的地方尽量加
- Widget 依赖运行时数据时不能使用 `const`

### 导入规范
- 使用包路径 `package:sjgtv/...` 而非相对路径
- 导入顺序：dart → package → relative
- 示例：
  ```dart
  import 'dart:io';
  import 'package:flutter/material.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:sjgtv/core/core.dart';
  import 'package:sjgtv/src/movie/model/movie_model.dart';
  ```

### 命名规范
- 类名：`UpperCamelCase`（如 `MovieDetailPage`）
- 方法/变量：`lowerCamelCase`（如 `movieList`）
- 常量：`kCamelCase`（如 `kDefaultPageSize`）
- 文件名：`snake_case.dart`（如 `movie_detail_page.dart`）

### 注释规范
- 使用中文注释
- 只写必要注释：复杂逻辑、非显而易见细节、重要业务规则
- 禁止：修改原因、重复代码含义、解释修改过程

### 错误处理
- 使用 `Result` 类型封装业务逻辑返回值
- 使用 `try-catch` 捕获异常并记录日志
- 示例：
  ```dart
  final Result<Movie> result = await _repository.getMovie(id);
  return result.fold(
    onSuccess: (movie) => Success(movie),
    onFailure: (failure) => Failure(failure.message),
  );
  ```

---

## 3. 项目架构

### 目录结构
```
lib/
├── core/           # 公共工具和扩展
├── data/           # 数据层（Repository 实现）
├── di/             # 依赖注入
├── domain/         # 领域层（Use Case、Entity）
├── gen/            # 生成的文件（勿手动修改）
├── l10n_arb/       # 国际化 ARB 源文件
├── l10n_gen/       # 生成的国际化代码
├── src/            # 应用代码
│   ├── app/        # 应用级（配置、路由、主题）
│   ├── source/     # 视频源管理
│   ├── movie/      # 电影业务
│   ├── favorite/   # 收藏功能
│   ├── watch_history/ # 观看历史
│   ├── settings/   # 设置页面
│   ├── proxy/      # 代理管理
│   ├── tag/        # 标签管理
│   └── shelf/      # 本地 HTTP 服务
└── main.dart       # 应用入口
```

### 模块分层
- **page/** - UI 页面
- **provider/** - Riverpod 状态管理
- **model/** - 数据模型
- **service/** - 业务服务
- **widget/** - 可复用组件
- **l10n/** - 国际化文本

### Riverpod 使用
- 使用 `@riverpod` 注解 + `riverpod_generator` 生成代码
- 手写 Provider 时使用 `StateNotifierProvider` 或 `FutureProvider`

---

## 4. 注意事项

### 不主动使用代码生成器
除非用户明确要求，否则不主动使用：
- Freezed
- Retrofit（手写 Dio 请求）
- json_serializable（手写 model）
- riverpod_generator（如需可询问用户）
- flutter_gen_runner

### 需求审查
- 执行前评估需求合理性、方案风险、替代方案
- 发现问题时先停止执行并指正问题
- 不盲目执行用户方案，主动评估是否有更好方案

### 完成后必做
1. 运行 `flutter analyze` 确保无警告
2. 运行 `flutter test` 确保测试通过
3. 确认用户是否需要执行代码生成

---

## 5. 现有 TODO/FIXME（代码标记）

- `lib/src/movie/page/category_page.dart:325` - FIXME: TV 设备二维码显示判断逻辑
- `lib/src/watch_history_page.dart:133` - TODO: 跳转到播放器继续播放

---

## 6. 规划待办（功能增强）

### 功能类
- [ ] 字幕支持（srt/vtt 解析、样式调整）
- [ ] Flutter 代理/标签管理页（网页已有）
- [ ] 离线缓存降级
- [ ] 收藏云端同步

### 体验优化
- [ ] TV 播放体验优化
- [ ] 首页布局（卡片间距、焦点指示器）
- [ ] 搜索功能优化
- [ ] 广告过滤完善

### 质量类
- [ ] 更多测试（Providers、集成测试）
- [ ] HTTPS 证书锁定（生产环境）
- [ ] 主线程阻塞优化

### 可选/低优先
- [ ] base viewer 模块精简
- [ ] Isar 换 Hive/SP

---

## 7. 相关文件

- `.cursorrules` - Cursor AI 规则配置
- `analysis_options.yaml` - Dart 分析器配置
- `pubspec.yaml` - 项目依赖配置
