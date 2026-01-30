**会话概要**
- 将 `lib/src/mixin/` 下的 `CancelTokenMixin` 迁移到 `lib/src/api/mixin/` 目录
- 在 `api.dart` 中统一导出，删除原 `mixin.dart` 入口
- 决定重新来：之前直接复制 base 项目导致大量依赖错误，项目过于复杂
- 新思路：采用模块化方案，循序渐进开发
- 执行模块化重构：删除 Flutter 工程、建 base/app、迁移 root/base 与配置、对齐 script/tasks/launch（仅 base）
- API 层拟用 Retrofit 方式重构
- 项目名 / 包名改为 sjgtv、com.sjg.tv（Android、iOS、macOS、Windows、Web）；集成 flutter_launcher_icons、删除 app/linux；README 按依赖更新技术栈并新增「开发中、未发布」说明
- 精简 base 中许多用不到的模块（尚未精简完）；下一步继续精简 base，完成后进行 app 模块重构

**完成项**
- [api] 新建 `lib/src/api/mixin/cancel_token_mixin.dart`，内容与原文件一致
- [api] 在 `lib/api.dart` 中添加 `export 'src/api/mixin/cancel_token_mixin.dart';`
- [base] 从 `lib/base.dart` 中移除 `export 'mixin.dart';`
- [清理] 删除 `lib/mixin.dart`、`lib/src/mixin/cancel_token_mixin.dart` 及空目录 `lib/src/mixin/`
- Linter 检查通过，无错误
- [app] 项目名 libretv_app → sjgtv；Android 包名、iOS/macOS bundle id → com.sjg.tv；Windows/Web 应用名与身份更新；Dart 导入改为 `package:sjgtv`
- [app] 集成 flutter_launcher_icons（依赖、配置、`assets/icon/icon.png`、脚本），重新生成各平台应用图标
- [app] 删除 `app/linux` 及 `.metadata` 中 linux 平台
- [doc] README.md：技术栈按 base/app 依赖更新，SDK ≥3.10，新增「开发中、未发布」说明
- [base] 精简部分用不到的模块（进行中，未完成）

**未完成的计划（模块化重构）**

阶段一：项目结构搭建
- [x] 创建新的主项目目录结构
- [x] 创建 `base` 模块目录（存放基础库）
- [x] 创建 `app` 模块目录（存放 sjgtv 应用）

阶段二：基础库迁移
- [x] 从 root/base 复制基础库代码到 base 模块
- [x] 复制配置文件（`.cursor`, `.vscode`, `.qwen`, `.gemini`）到 base 模块
- [x] 检查并修复 base 模块的依赖错误

阶段二补充：base 精简
- [ ] 继续精简 base 中用不到的模块

阶段三：应用代码迁移与 app 重构
- [ ] 从 DTV 项目复制应用代码到 app 模块
- [ ] 逐步集成 base 模块与 app 模块
- [ ] app 模块重构（base 精简完成后进行）
- [ ] 每步检查并修复错误

阶段四：核心功能实现
- [ ] API 层用 Retrofit 方式重构
- [ ] 源管理功能（Riverpod 生成代码模式）
- [ ] 视频播放（MediaKit）
- [ ] TV 优化 UI 组件
- [ ] 搜索功能
- [ ] 广告过滤
- [ ] 代理管理
- [ ] 标签管理

**项目与参考**
- 项目均放在 `~/projects` 下；当前项目为 sjgtv。
- 本项目中需**参考** `~/projects/root/base` 与 `~/projects/DTV`（或 `root/base`、`DTV`）的实现与配置。
- **可参考，但不得修改** root/base、DTV 里的任何文件；只在本项目内新增或修改。

**上一次开发的摘要**
- `.qwen/DAILY_WORK_LOG.md`

**原则**
- 循序渐进，每步都检查修复错误
- 只复制必要的代码，避免过度复杂
- 所有配置只复制到新项目，不修改 root、DTV 的任何内容

**涉及/修改的文件**
- （mixin 迁移）`lib/api.dart`、`lib/base.dart`、`lib/src/api/mixin/cancel_token_mixin.dart` 等，已随整体删除清空
- 删除：`lib/`、`android/`、`ios/`、`linux/`、`macos/`、`web/`、`windows/`、`test/`、`tool/`、`pubspec.yaml` 等 Flutter 工程；保留 `script/`、`.qwen/`、`.vscode/`、`.gemini/`、`.cursor/`
- 新建：`base/`（含 root/base 内容 + root 配置）、`app/`（空）
- 修改：`script/*.sh`（与 root 同风格，仅遍历 base；增 `check_super_calls.py`、`resize_images.py`，删 dart fix/watch/widget-preview）、`.vscode/tasks.json`（script + base/script + git/adb/python3）、`.vscode/launch.json`（仅保留 base 的 tool 运行配置）
- 本次：`README.md`；`app/pubspec.yaml`、`app/assets/icon/`、`app/script/dart run flutter_launcher_icons.sh`、`app/README.md`；`app/android/`、`app/ios/`、`app/macos/`、`app/windows/`、`app/web/` 等平台配置（包名、应用名）；删除 `app/linux/`；`app/.metadata`
- base 精简：`base/` 下部分模块/目录（具体视精简进度而定）

## 历史

### 2026-01-30 (初始)
- [api] 新建 `lib/src/api/mixin/cancel_token_mixin.dart`
- [api] 在 `lib/api.dart` 中添加导出
- [base] 从 `lib/base.dart` 中移除 `export 'mixin.dart';`
- [清理] 删除 `lib/mixin.dart`、`lib/src/mixin/` 及相关文件

### 2026-01-30 (补充计划)
- 根据 .qwen 目录下的 PROJECT_SUMMARY.md 和 DAILY_WORK_LOG.md 补充了接下来的计划

### 2026-01-30 (重新规划)
- 决定重新来：之前直接复制 base 项目思路有问题，导致大量依赖错误
- 已取消：原功能计划（源管理、播放、UI、搜索、广告、代理、标签）暂时搁置
- 新增：模块化重构计划（阶段一~四），采用循序渐进方式开发

### 2026-01-30 (模块化执行)
- 删除全部 Flutter 代码，仅保留 script、.qwen、.vscode、.gemini、.cursor
- 创建 base、app 目录；从 root/base 复制基础库到 base，从 root 复制配置到 base；base 模块 `flutter pub get`、`dart analyze` 通过
- script/ 与 root 同文件、同风格，仅遍历 base（app 暂不检查，待创建 Flutter 项目后再加）
- tasks.json 保留 script、base/script、git、adb、python3；launch.json 仅保留 base 的 tool 运行配置
- 阶段一、阶段二已完成

### 2026-01-30 (补充计划)
- 补充：API 层拟用 Retrofit 方式重构，已加入阶段四待办

### 2026-01-30（补充）
- 补充：上一次开发的摘要为 `.qwen/DAILY_WORK_LOG.md`（仅引用路径）

### 2026-01-30 08:30（项目名、图标、Linux、README）
- 项目名 libretv_app → sjgtv；Android 包名、iOS/macOS bundle id → com.sjg.tv；Windows/Web 应用名与身份更新；Dart 导入 `package:sjgtv`
- 集成 flutter_launcher_icons（依赖、配置、assets/icon、脚本），重新生成各平台应用图标
- 删除 app/linux 及 .metadata 中 linux 平台
- README.md：技术栈按 base/app 依赖更新，SDK ≥3.10，新增「开发中、未发布」说明

### 2026-01-30 08:35（base 精简与下一步）
- 精简 base 中许多用不到的模块（进行中，未精简完）
- 下一步：继续精简 base → 完成后进行 app 模块重构；已加入阶段二补充、阶段三待办
