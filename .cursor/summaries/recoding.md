**会话概要**
- 将 `lib/src/mixin/` 下的 `CancelTokenMixin` 迁移到 `lib/src/api/mixin/` 目录
- 在 `api.dart` 中统一导出，删除原 `mixin.dart` 入口
- 决定重新来：之前直接复制 base 项目导致大量依赖错误，项目过于复杂
- 新思路：采用模块化方案，循序渐进开发
- 执行模块化重构：删除 Flutter 工程、建 base/app、迁移 root/base 与配置、对齐 script/tasks/launch（仅 base）
- API 层拟用 Retrofit 方式重构
- 项目名 / 包名改为 sjgtv、com.sjg.tv（Android、iOS、macOS、Windows、Web）；集成 flutter_launcher_icons、删除 app/linux；README 按依赖更新技术栈并新增「开发中、未发布」说明
- 精简 base 中许多用不到的模块（尚未精简完）；下一步继续精简 base，完成后进行 app 模块重构
- 讨论 SSH 远程 + Cursor、Cursor CLI：本机关机则断连，无法继续干活；计划在服务器 macOS 上跑 Cursor、拉项目，用该环境推进 recoding（本机关机不影响）
- 分析 base 用不到的模块与依赖：列出可删 pubspec、可选模块（viewer/debug/isar/l10n）及建议精简顺序
- 执行 base 精简：删 pubspec 未使用依赖（A-E）、删 debug 模块；viewer 先保留；下一步为阶段三
- 配置 Cursor 收尾流程：讨论用 skill 还是 subagent 实现「skill 完成后 → 检查修复 → 优化 → 摘要 → 提交推送」；结论用 subagent，创建 wrap-up subagent，删除 summary skill

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
- [base] 完成 base 用不到项分析：pubspec 未使用依赖（barcode_widget、mobile_scanner、jose、openid_client、pdfx）；可选模块 viewer、debug、isar、l10n 及建议精简顺序
- [base] 删 pubspec 未使用依赖（barcode_widget、mobile_scanner、jose、openid_client、pdfx 及 dependency_overrides 中 pdfx、device_info_plus）
- [base] 删 debug 模块及 flutter_colorpicker，移除 api_client_provider、json_adapter、app_runner、l10n_key_tips 对 debug 的引用；viewer 保留
- base 与 app 的 `flutter pub get`、`dart analyze`、build_runner 通过
- [cursor] 收尾流程改为 subagent：新建 `.cursor/agents/wrap-up.md`（按序执行检查修复 → 优化 → 摘要 command → 提交推送）；删除 `.cursor/skills/summary/`

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
- [x] 按分析清单执行 base 精简：已删 pubspec 未使用依赖（A-E）与 debug 模块；viewer 先保留；每步 `flutter pub get`、`dart analyze` 通过

阶段三：应用代码迁移与 app 重构
- [x] 从 DTV 项目复制应用代码到 app 模块
- [ ] 逐步集成 base 模块与 app 模块
- [ ] app 模块重构：先分析重构方向（状态管理 vs API），再执行
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

**接下来要做的步骤**（依 recoding 为准；DAILY_WORK_LOG、PROJECT_SUMMARY 仅作背景，勿按其中旧计划执行）

1. **阶段二补充：base 精简**（已完成：pubspec 未使用依赖已删、debug 已删、viewer 保留）
   - 若后续再精简：可按需删 viewer（含 webview_flutter）或 Isar（需改 app_config、l10n 存储）；每步 `flutter pub get`、`dart analyze` 通过后再继续。

2. **阶段三：应用代码迁移与 app 重构**（当前下一步）
   - ~~从 DTV 复制应用代码到 `app` 模块~~（已完成）
   - 逐步集成 base 与 app（依赖、导出、引用），每步检查并修复错误。
   - **app 模块重构**：先分析重构方向（**状态管理** vs **API**，或两者），再按方向分步重构（结构、命名、与 base 的边界等），每步检查并修复。

3. **阶段四：核心功能实现**（阶段三稳定后）
   - 按 recoding 待办顺序推进：API 层 Retrofit 重构 → 源管理（Riverpod 生成）→ 视频播放（MediaKit）→ TV 优化 UI → 搜索 → 广告过滤 → 代理管理 → 标签管理。
   - 每项完成后构建/分析通过再进入下一项。

**原则**：循序渐进，每步检查修复错误；只复制必要代码；只在本项目内修改，不修改 root、DTV。

**项目与参考**
- 项目均放在 `~/projects` 下；当前项目为 sjgtv。
- 本项目中需**参考** `~/projects/root/base` 与 `~/projects/DTV`（或 `root/base`、`DTV`）的实现与配置。
- **可参考，但不得修改** root/base、DTV 里的任何文件；只在本项目内新增或修改。

**备注（想法，非待办；优先级最低）**
- 在服务器 macOS 上拉取项目、配置 Cursor，用该环境推进 recoding（本机关机不影响；Agent 需人工逐步驱动，不会自动跑完）。

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
- 本次：无代码变更，仅讨论 SSH/CLI、macOS Cursor 计划
- 本次：无代码变更；分析涉及 `base/` 目录、`base/pubspec.yaml`、`base/lib` 各模块导出与引用
- 本次：`base/pubspec.yaml`；`base/lib/base.dart`；删除 `base/lib/debug.dart`、`base/lib/src/debug/` 全部；修改 `base/lib/src/api/provider/api_client_provider.dart`、`base/lib/src/converter/provider/json_adapter_provider.dart`、`base/lib/src/app/app_runner.dart`、`base/lib/src/app/theme/extension/color_ext.dart`、`base/lib/src/l10n/widget/l10n_key_tips.dart`；相关 `.g.dart` 由 build_runner 重新生成
- 本次：新建 `.cursor/agents/`、`.cursor/agents/wrap-up.md`（收尾 subagent）；删除 `.cursor/skills/summary/`（含 SKILL.md）

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

### 2026-01-30 08:51（SSH/CLI、macOS Cursor 计划）
- 讨论：SSH 远程 + Cursor、Cursor CLI 均依赖本机；本机关机则断连，Cursor 不继续干活
- 计划：在服务器 macOS 上跑 Cursor、拉项目，用该环境推进 recoding；本机关机不影响那边 Cursor，但 Agent 不会自动按 recoding 一直跑，需人工逐步驱动
- 待办：在服务器 macOS 上拉取项目、配置 Cursor，用该环境推进 recoding

### 2026-01-30（base 用不到项分析）
- 分析了 base 用不到的模块与依赖，产出可执行清单
- 可删 pubspec（代码无引用）：barcode_widget、mobile_scanner、jose、openid_client、pdfx 及 dependency_overrides 中的 pdfx
- 可选模块（按产品需求）：viewer（含 webview_flutter）、debug（含 flutter_colorpicker）、isar（需改 app_config/l10n 存储）、l10n（牵涉多，建议阶段三再评估）；另 dynamic_app_icon_flutter、timeago 仅单点使用
- 建议顺序：先删未使用依赖 → 再按需删 viewer/debug 等；Isar 替换为 Hive/SP 可单独排期
- 待办：按分析清单执行 base 精简，每步 `flutter pub get`、`dart analyze` 通过后再继续

### 2026-01-30（base 精简执行：A-E、debug 删；viewer 保留）
- 删 pubspec 未使用依赖：barcode_widget、mobile_scanner、jose、openid_client、pdfx 及 dependency_overrides 中 pdfx、device_info_plus
- 删 debug 模块：移除 api_client_provider、json_adapter、app_runner、l10n_key_tips 对 debug 的引用；删除 lib/debug.dart、lib/src/debug/ 全部；移除 base 导出、color_ext 对 flutter_colorpicker 的 re-export、pubspec 中 flutter_colorpicker；build_runner、dart analyze 通过
- viewer 先保留（用户选择）
- 阶段二补充 base 精简视为完成，下一步为阶段三（应用代码迁移与 app 重构）

### 2026-01-30 16:39（Cursor 收尾流程改为 subagent）
- 收尾流程由 skill 改为 subagent：新建 `.cursor/agents/wrap-up.md`（wrap-up），按序执行检查修复 → 优化 → 摘要 command → 提交推送；skill 完成后或用户说「收尾」时使用
- 删除 `.cursor/skills/summary/`；规则 `.cursor/rules/project-skill-workflow.mdc` 保留

### 2026-01-30 16:41（wrap-up 补充与执行收尾）
- wrap-up.md 补充：若没有文件修改则不执行收尾流程
- 执行收尾：dart analyze（base、app）通过，无优化，更新摘要后提交并推送

### 2026-01-30 16:45（收尾 subagent 改名为 check）
- wrap-up → checkpoint → check；保留 `.cursor/agents/check.md`，删除 wrap-up.md、checkpoint.md；名称越短越好

### 2026-01-30 16:47（check.md 精简表述）
- description 精简为「变更后收尾：检查修复 → 优化 → 摘要 → 提交推送。说收尾时用。」
- 正文开头、步骤 3/4、约束段略作精简

### 2026-01-30 16:55（收尾 subagent 改名为 next，补充下一轮循环）
- end → next；保留 `.cursor/agents/next.md`，删除 end.md
- next 步骤 1：仅当变更涉及 `*.dart` 或 `pubspec.yaml` 时才执行代码分析
- next 步骤 5：根据摘要分析最适合先做的一步（只做一步），执行完后再次从 next 的步骤 1 开始，循环直至摘要无待办

### 2026-01-30 17:00（next 步骤 3 补充摘要新建/更新判断、支持 @ 摘要文件）
- 步骤 3：摘要文件可能是本会话已 @ 或未导入，根据关联判断新建或更新；若用户调用 next 时 @ 了某摘要文件，则步骤 3、5 以该文件为准

### 2026-01-30 17:04（阶段三：复制已完成，下一步 app 重构）
- 从 DTV 复制应用代码到 app 模块 已视为完成；下一步为 **app 模块重构**
- 重构前先分析方向：**状态管理** vs **API**（或两者），再按方向分步执行

### 2026-01-30 17:05（next 执行：提交摘要变更）
- 提交阶段三更新（复制已完成、下一步 app 重构）至 recoding.md

### 2026-01-30 17:06（app 重构方向分析：状态管理 vs API）
- **现状**：状态管理 = 全用 StatefulWidget + setState，pubspec 有 provider/flutter_riverpod 但未用；API = Dio 分散在各处（main、category_page、search_page 等）+ shelf 本地服务（api.dart 里 /api/sources|proxies|tags）+ Hive 直读。
- **建议**：**先 API、后状态管理**。先统一 API 层（Dio + shelf → 一层 API 服务/Retrofit），页面只调 API；再上 Riverpod 时只换数据源，避免先上状态管理时数据来源仍分散。

### 2026-01-30 17:37（Retrofit API 声明、final 显式类型、next 收尾）
- app 接入 Retrofit：新增 retrofit/json_annotation 依赖，dev 新增 retrofit_generator、json_serializable；新建 `app/lib/services/api_client.dart` 声明本地 shelf 接口（sources/proxies/tags/search），生成 `api_client.g.dart`（生成器对 Map 转换有误已手动修正）
- final 变量显式声明类型：app/lib（main、api、m3u8_ad_remover、各 widget）、base/lib/src/l10n/provider/l10n_translation_provider.dart、.vscode/dart.code-snippets 中 final 均补全类型；full_screen_player 漏网两处与片段中 key/controller 已补
