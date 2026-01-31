**项目概要**

sjgtv 是一个模块化的 Flutter TV 应用项目，采用 base（基础库）+ app（应用层）的结构。当前处于**阶段三：app 模块重构**阶段，已完成 AppRunner 架构接入和项目结构重构。

**当前状态**

- **阶段一**（项目结构搭建）✅ 已完成
- **阶段二**（基础库迁移 + base 精简）✅ 已完成
- **阶段三**（应用代码迁移与 app 重构）🔄 进行中
  - ✅ 从 DTV 复制应用代码到 app 模块
  - ✅ app 重构方向分析：先 API、后状态管理
  - ✅ 接入 Retrofit：新建 `api_client.dart` 声明本地 shelf 接口
  - ✅ 接入 base AppRunner 架构（SjgtvRunner + JsonAdapterImpl）
  - ✅ 创建 ApiService 服务层封装
  - ✅ 迁移页面使用 ApiService（category_page, search_page）
  - ✅ 项目结构重构（按 base 风格组织）
  - 🔄 逐步集成 base 与 app
  - ✅ 引入 Riverpod 状态管理（ApiService Provider + 页面改 Consumer）
  - ✅ 主题色统一（AppColors：app/theme/app_colors.dart，多页/组件改用）

**项目结构**

```
app/lib/src/
├── api/          # API 相关
│   ├── client/   # Retrofit 客户端（api_client.dart）
│   ├── service/  # API 服务层（api_service.dart）
│   └── shelf/    # shelf 本地服务（api.dart）
├── app/          # 应用启动
│   ├── provider/ # 应用级 Provider（json_adapter_provider.dart, api_service_provider.dart）
│   ├── theme/    # 主题（app_colors.dart）
│   └── sjgtv_runner.dart
├── model/        # 数据模型（source, proxy, tag, movie）
├── page/         # 页面
│   ├── home/     # 首页（app_wrapper, category_page）
│   ├── player/   # 播放器（full_screen_player_page, player_intents）
│   ├── search/   # 搜索（search_page, movie_detail_page）
│   └── source/   # 源管理（source_manage_page, add_source_page）
├── service/      # 通用服务（m3u8_ad_remover）
└── widget/       # 通用组件（focusable_movie_card, update_checker）
```

**未完成的待办**

阶段三：应用代码迁移与 app 重构
- [x] 接入 base AppRunner 架构
- [x] 创建 ApiService 服务层
- [x] 迁移页面使用 ApiService
- [x] 项目结构重构
- [x] 引入 Riverpod 状态管理（创建 ApiService Provider）
- [x] 页面改为通过 Provider 获取 ApiService

阶段四：核心功能实现
- [x] 源管理：添加新源（AddSourcePage + 源管理页入口）
- [ ] 源管理：删除/编辑
- [ ] 视频播放（MediaKit）- 已有基础实现
- [ ] TV 优化 UI 组件
- [ ] 搜索功能 - 已有基础实现
- [ ] 广告过滤 - 已有 m3u8_ad_remover
- [ ] 代理管理
- [ ] 标签管理

可选精简（优先级低）
- [ ] 删除 viewer 模块（含 webview_flutter）
- [ ] 替换 Isar 为 Hive/SP（需改 app_config、l10n 存储）

**当前策略**

- **先做优化、不加新功能**，避免增加维护难度；新功能（源管理删除/编辑、代理、标签等）暂缓。

**优化待办**（无新功能，仅质量/性能/结构）

- [x] 代码：dart analyze / dart fix 全绿（已通过）；未使用导入与死代码可后续人工排查
- [x] 结构：重复 UI 模式抽组件或工具函数（网络图片占位/错误占位已抽为 network_image_placeholders）
- [x] 性能：页面/列表避免不必要的 rebuild、能 const 则 const（category_page、full_screen_player_page、movie_detail_page、search_page、source_manage_page 补 const）
- [x] 依赖：pub outdated 评估与保守升级（dart pub upgrade，app/base 已执行，分析通过）
- [x] 依赖：清理未使用依赖（app 移除 provider、shared_preferences、flutter_secure_storage、logger、network_info_plus）
- [x] 规范：app 复用 base 能力；通过扩展获取的值多处用时用局部变量复用，只用到一次则不设局部变量

**下一步行动**（功能类暂缓）

1. **优化**：按上面优化待办逐项做
2. **功能页面**（后续再做）：源管理删除/编辑、代理管理、标签管理

---

## 项目分析（2026-01-31 20:25）

**静态分析**：`dart analyze app base` 全绿，无错误、无警告。

**结构概览**
- **app**：api（client/service/shelf）、app（provider/theme/sjgtv_runner）、model、page（home/player/search/source）、service、widget；职责清晰，依赖 base。
- **base**：api、app、cache、converter、extension、isar、l10n、log、permission、provider、search、snake_bar、viewer、widget 等；能力完整，app 已复用 theme/extension/cache/api/converter/log 等。

**代码质量**
- 优化待办已全部完成（代码、结构、性能、依赖、规范）。
- app 内仅 1 处 TODO：`json_adapter_provider.dart`「后续添加更多实体类的 fromJson 注册」，属扩展点，非缺陷。

**可选后续方向**
- **功能**：源管理删除/编辑、代理、标签、TV UI 与搜索体验等（按当前策略暂缓）。
- **精简**：base 的 viewer 模块（webview_flutter）若 app 不用可考虑移除或独立；Isar 换 Hive/SP 为可选。
- **扩展**：新实体类时在 JsonAdapterImpl 中补充 fromJson 注册。

**开发原则**

- 循序渐进，每步检查修复错误
- 只复制必要代码，避免过度复杂
- 只在本项目（sjgtv）内修改，不修改 root、DTV
- 每项完成后 `flutter pub get`、`dart analyze` 通过再继续

**项目与参考**

- 当前项目：`~/projects/sjgtv`
- 参考项目：`~/projects/root/base`、`~/projects/root/essence`、`~/projects/root/purtato`（只读参考）

**技术栈**

- Flutter SDK ≥3.10
- 基础库（base）：Dio、Isar、Riverpod、flutter_hooks 等
- 应用层（app）：MediaKit（播放）、Retrofit（API）、Riverpod（状态管理）

**备注**

- 旧摘要：`.cursor/summaries/recoding1.md`（含完整历史记录）
- 测试入口：`flutter run -t test/api_server_test.dart`（shelf 服务测试）

---

## 历史

### 2026-01-30 19:07（接入 AppRunner 架构与项目结构重构）

**接入 base AppRunner 架构**
- 创建 `SjgtvRunner` 继承 base 的 `AppRunner`
- 创建 `JsonAdapterImpl` 注册实体类 fromJson（Source, Proxy, Tag）
- 重构 `main.dart` 为一行启动代码：`SjgtvRunner().launchApp()`
- SjgtvRunner 整合初始化逻辑：Hive 初始化、配置加载、shelf 服务启动、主题配置

**API 层重构**
- 创建 `ApiClient`（Retrofit 声明）和 `ApiService`（服务层封装）
- 迁移页面使用 ApiService（category_page, search_page）
- 删除 api.dart 中重复的 Source/Proxy/Tag 类，改用 models/ 目录
- 修改 shelf 服务响应格式为统一的 `{ code, data, msg }`

**代码分离**
- 把测试 main() 和 MyApp 移到 `test/api_server_test.dart`
- 分离 `Movie` 类到 `models/movie.dart`
- 分离 `FocusableMovieCard` 到 `widgets/focusable_movie_card.dart`
- 分离 6 个 Intent 类到 `widgets/player_intents.dart`

**项目结构重构（按 base 风格）**
- 旧结构：`services/`, `widgets/`, `models/`（扁平）
- 新结构（按功能模块组织）：
  - `api/` - API 相关（client/, service/, shelf/）
  - `app/` - 应用启动（provider/, sjgtv_runner.dart）
  - `model/` - 数据模型
  - `page/` - 页面（home/, player/, search/）
  - `service/` - 通用服务
  - `widget/` - 通用组件
- 更新所有 import 路径
- 重新运行 build_runner 生成代码

**涉及/修改的文件**
- 新增：`app/lib/src/api/`（client/, service/, shelf/）
- 新增：`app/lib/src/app/`（provider/, sjgtv_runner.dart）
- 新增：`app/lib/src/model/`（movie.dart）
- 新增：`app/lib/src/page/`（home/, player/, search/）
- 新增：`app/lib/src/service/`（m3u8_ad_remover.dart）
- 新增：`app/lib/src/widget/`（focusable_movie_card.dart, update_checker.dart）
- 新增：`app/test/api_server_test.dart`
- 修改：`app/lib/main.dart`（精简为一行）
- 删除：`app/lib/src/services/`、`app/lib/src/widgets/`、`app/lib/src/models/`（内容已迁移）

**提交**：`b92d51e` - refactor: 接入 AppRunner 架构并重构项目结构

### 2026-01-30 19:12（摘要历史补充 + shelf 启动修复）

- 补充 recoding2.md 历史记录（格式与 recoding1.md 一致）
- 历史记录补充时间（如 `2026-01-30 19:07`）
- 修复 shelf 服务启动阻塞问题：`await startServer()` 改为 `.then()` 方式，不阻塞 `init()` 流程

**涉及/修改的文件**
- 修改：`app/lib/src/app/sjgtv_runner.dart`（startServer 改用 then）
- 修改：`.cursor/summaries/recoding2.md`（补充历史）

**提交**：
- `f17bb4a` - docs: 补充 recoding2.md 历史记录
- `caa035a` - docs: 历史记录补充时间
- `d6c7d9f` - fix: shelf 服务启动改用 then 避免阻塞

### 2026-01-30 19:25（代码规范与注释补充）

**注释补充**
- 为页面和组件补充类注释（app_wrapper, category_page, update_checker, search_page, movie_detail_page, full_screen_player_page）

**更新检查修复**
- GitHub releases URL 改为 `dovecheng/sjgtv`
- 404 时静默处理，不弹出错误提示（仓库暂无发布版本时不报错）

**日志规范**
- 全局 `debugPrint` 替换为 `log.d` / `log.e`
- 涉及文件：update_checker.dart, full_screen_player_page.dart, category_page.dart

**代码规范**
- 纯静态类改为 `abstract final class`（AppUpdater, M3U8AdRemover, SourceStorage）

**涉及/修改的文件**
- 修改：`app/lib/src/widget/update_checker.dart`
- 修改：`app/lib/src/page/player/full_screen_player_page.dart`
- 修改：`app/lib/src/page/home/category_page.dart`
- 修改：`app/lib/src/page/home/app_wrapper.dart`
- 修改：`app/lib/src/page/search/search_page.dart`
- 修改：`app/lib/src/page/search/movie_detail_page.dart`
- 修改：`app/lib/src/service/m3u8_ad_remover.dart`
- 修改：`app/lib/src/api/shelf/api.dart`

**提交**：
- `ebaaa00` - docs: 补充页面和组件的类注释
- `a7a1646` - fix: 更新检查地址改为 dovecheng/sjgtv
- `c574755` - fix: 更新检查 404 时静默处理，不弹出错误提示
- `5581325` - refactor: debugPrint 替换为 log.d/log.e
- `ced018c` - refactor: 纯静态类改为 abstract final class

### 2026-01-31 18:44（Riverpod 接入与配置）

**app 依赖与 Riverpod 消费者**
- app 增加依赖：`flutter_hooks`、`hooks_riverpod`
- 新增 `api_service_provider.dart`：用 base 的 `apiClientProvider`（Dio）创建 ApiService，供页面通过 ref 获取
- `category_page`（MovieHomePage）、`search_page`（SearchPage）改为 `ConsumerStatefulWidget`，通过 `ref.read(apiServiceProvider)` 获取 ApiService，移除 `ApiService.standalone()` 调用
- 修复 dart 分析：补全 `ApiService`、`Dio` 类型导入（search_page、category_page、api_service_provider）

**其它配置**
- `.cursorrules` 增加「Agent 响应语言（最高优先级）」：Cursor Agent 必须始终使用简体中文回复
- base `l10n_language_provider.dart`：为 zh-CN 预设项设置 `isDefault: true`，新用户默认简体中文

**涉及/修改的文件**
- 新增：`app/lib/src/app/provider/api_service_provider.dart`
- 修改：`app/pubspec.yaml`（flutter_hooks、hooks_riverpod）
- 修改：`app/lib/src/page/home/category_page.dart`（Consumer + ref）
- 修改：`app/lib/src/page/search/search_page.dart`（Consumer + ref）
- 修改：`.cursorrules`（Agent 中文规则）
- 修改：`base/lib/src/l10n/provider/l10n_language_provider.dart`（zh-CN 默认）

### 2026-01-31 18:44（源管理页面）

**源管理页与首页入口**
- 新增 `app/lib/src/page/source/source_manage_page.dart`：ConsumerStatefulWidget，通过 apiServiceProvider 拉取源列表，展示名称/地址/启用状态，支持点击或遥控器切换启用/禁用
- 首页 category_page AppBar 增加「源管理」图标入口，点击进入 SourceManagePage

**涉及/修改的文件**
- 新增：`app/lib/src/page/source/source_manage_page.dart`
- 修改：`app/lib/src/page/home/category_page.dart`（源管理入口 + const 等）

### 2026-01-31 18:54（运行时安全与 base converter）

**异步与 context 安全**
- source_manage_page：_loadSources 在每次 await 后 setState 前检查 mounted，catch 里同样检查
- category_page：_loadInitialData、_fetchTags、_fetchMovies、_handleRefresh 中异步后 setState 前加 mounted；_onScroll 开头加 hasClients 与 mounted 检查；_fetchMovies 在 await _dio.get 后、使用 response 前检查 mounted
- search_page：成功分支 setState 与两处 _showError 调用前加 mounted；catch 里 _showError 前加 mounted

**豆瓣 API 解析**
- category_page：构造 Movie 时改用 base 的 converter（StringConverter、DoubleConverter、BoolConverter），避免接口字段为 null 或类型不符时强转异常

**Lint**
- search_page：单行 if 补全大括号，满足 curly_braces_in_flow_control_structures

**涉及/修改的文件**
- 修改：`app/lib/src/page/source/source_manage_page.dart`（mounted 检查）
- 修改：`app/lib/src/page/home/category_page.dart`（mounted/hasClients、base converter）
- 修改：`app/lib/src/page/search/search_page.dart`（mounted 检查、if 大括号）

### 2026-01-31 19:10（主题色统一 AppColors）

**主题色抽取与统一**
- 新增 `app/lib/src/app/theme/app_colors.dart`：集中定义 background、cardBackground、cardSurface、surfaceVariant、primary、seedColor、error、hint 等常量
- SjgtvRunner：主题 seedColor 改用 AppColors.seedColor
- category_page：Tab 未选背景改用 AppColors.surfaceVariant
- full_screen_player_page：进度条主色改用 AppColors.seedColor
- focusable_movie_card：卡片背景/占位/错误区改用 AppColors.cardSurface、AppColors.surfaceVariant
- search_page：移除页面内颜色成员变量，全面改用 AppColors（cardBackground、primary、hint、error、background 等）
- source_manage_page：背景与卡片色改用 AppColors.background、AppColors.cardBackground、AppColors.primary

**涉及/修改的文件**
- 新增：`app/lib/src/app/theme/app_colors.dart`
- 修改：`app/lib/src/app/sjgtv_runner.dart`
- 修改：`app/lib/src/page/home/category_page.dart`
- 修改：`app/lib/src/page/player/full_screen_player_page.dart`
- 修改：`app/lib/src/page/search/search_page.dart`
- 修改：`app/lib/src/page/source/source_manage_page.dart`
- 修改：`app/lib/src/widget/focusable_movie_card.dart`

### 2026-01-31 19:12（源管理：添加新源）

**添加新源页面与入口**
- 新增 `app/lib/src/page/source/add_source_page.dart`：表单页（名称、地址），校验 URL 为 http(s)，提交调用 ApiService.addSource，成功后 pop(true)
- 源管理页 AppBar 增加「添加」图标入口，push AddSourcePage，返回后 _loadSources 刷新列表

**涉及/修改的文件**
- 新增：`app/lib/src/page/source/add_source_page.dart`
- 修改：`app/lib/src/page/source/source_manage_page.dart`（添加入口 + 返回后刷新）

### 2026-01-31 19:21（策略与 next 调整）

**当前策略与优化待办**
- 确定先做优化、不加新功能，避免增加维护难度；新功能（源管理删除/编辑、代理、标签等）暂缓
- 在摘要中增加「当前策略」「优化待办」（代码/结构/性能/依赖四类）、「下一步行动」改为优化优先、功能页面后续再做

**next 命令**
- 步骤五表述改为「执行完后**重新执行 next**……循环直至摘要无待办」；去掉「只执行这一步」与步骤编号（1→2→3→4→5）说明

**验证**
- app、base 已执行 dart analyze 与 dart fix：无错误、无自动修复项

**涉及/修改的文件**
- 修改：`.cursor/agents/next.md`（步骤五表述）
- 修改：`.cursor/summaries/recoding2.md`（当前策略、优化待办、下一步行动）

### 2026-01-31 19:40（依赖评估与保守升级）

**依赖优化**
- app、base 执行 `dart pub outdated` 评估
- app、base 执行 `dart pub upgrade`（保守升级，不跨 major）：app 47 项依赖更新，base 17 项更新
- `dart analyze`（app、base）通过

**涉及/修改的文件**
- 修改：`app/pubspec.lock`、`base/pubspec.lock`

### 2026-01-31 20:00（app 复用 base、主题与扩展规范）

**app 尽量不写 base 风格代码**
- base 新增 `lib/src/extension/duration_ext.dart`：`DurationClampExt`（Duration 的 clamp(min, max)），并在 `extension.dart` 导出
- app 移除 `full_screen_player_page.dart` 内本地 `extension DurationClamp`，改为 `import 'package:base/extension.dart'` 使用 base 能力

**主题与扩展统一用 base**
- app 中 `Theme.of(context)` 统一改为 `context.themeData`（base 的 BuildContextThemeExt）
- movie_detail_page：增加 `import 'package:base/app.dart'`，build 内用 `theme`、`colorScheme`、`textTheme` 局部变量复用，避免多处重复调用扩展

**扩展结果与局部变量约定**
- 同一作用域内多处用到扩展结果（如 themeData、appThemeColors）时，定义局部变量复用；只用到一次则直接调用，不设局部变量
- search_page 的 build 里仅一处 `context.appThemeColors.background`，保持直接调用

**涉及/修改的文件**
- 新增：`base/lib/src/extension/duration_ext.dart`
- 修改：`base/lib/extension.dart`（导出 duration_ext）
- 修改：`app/lib/src/page/player/full_screen_player_page.dart`（移除本地 DurationClamp，改用 base/extension）
- 修改：`app/lib/src/page/search/movie_detail_page.dart`（base/app 导入，theme/textTheme 局部变量复用）
- 修改：`app/lib/src/page/search/search_page.dart`（仅一处 appThemeColors 不设局部变量）

### 2026-01-31 20:05（收尾命令 next 改名为 ok 并优化）

**命令改名**
- 收尾命令由 `next` 改为 `ok`：`.cursor/agents/next.md` 删除，新增 `.cursor/agents/ok.md`
- 触发方式：说「收尾」或 `/ok`；可 @ 摘要文件，如 `/ok @.cursor/summaries/recoding2.md`

**内容优化**
- description 改为「再根据摘要给出下一步建议或询问是否重新分析」
- 步骤 3 摘要：合并为「写进摘要 + 若已 @ 则以该文件为准，否则新建/更新并建议路径」
- 步骤 5：建议选项表述精简为「列出若干条供用户选择」；无待办时询问是否重新分析，要分析则分析并整理摘要
- 步骤 1：read_lints 表述收紧；步骤 4 已含分次提交与 submodule 先子模块 push 再主仓 push

**涉及/修改的文件**
- 删除：`.cursor/agents/next.md`
- 新增：`.cursor/agents/ok.md`

### 2026-01-31 20:10（性能：能 const 则 const）

**优化内容**
- category_page：Tab/网格 padding、AnimatedContainer duration/padding/constraints、Border.all、加载中/空态 Center、TextStyle 等补 const
- full_screen_player_page：加载中 Column 内 CircularProgressIndicator、SizedBox、Text 补 const
- movie_detail_page：图片错误占位 Icon 补 const（const Center 内子节点不再重复 const，避免 unnecessary_const）
- search_page：搜索按钮区 Icon、Text 及 TextStyle 补 const
- source_manage_page：「暂无数据源」TextStyle 补 const

**涉及/修改的文件**
- 修改：`app/lib/src/page/home/category_page.dart`
- 修改：`app/lib/src/page/player/full_screen_player_page.dart`
- 修改：`app/lib/src/page/search/movie_detail_page.dart`
- 修改：`app/lib/src/page/search/search_page.dart`
- 修改：`app/lib/src/page/source/source_manage_page.dart`

### 2026-01-31 20:15（结构：重复 UI 抽网络图片占位组件）

**抽取共用占位**
- 新增 `app/lib/src/widget/network_image_placeholders.dart`：`networkImagePlaceholder(context)`、`networkImageErrorWidget(context)`，统一加载中/失败占位样式
- movie_detail_page、search_page、focusable_movie_card 三处 CachedImage 的 placeholder/errorWidget 改为调用上述函数
- movie_detail_page 移除未使用导入 app_theme；full_screen_player_page 加载列内移除多余 const 以通过 lint

**涉及/修改的文件**
- 新增：`app/lib/src/widget/network_image_placeholders.dart`
- 修改：`app/lib/src/page/search/movie_detail_page.dart`
- 修改：`app/lib/src/page/search/search_page.dart`
- 修改：`app/lib/src/widget/focusable_movie_card.dart`
- 修改：`app/lib/src/page/player/full_screen_player_page.dart`

### 2026-01-31 20:20（依赖：清理 app 未使用依赖）

**移除的 app 依赖**
- provider：app 已用 Riverpod，无 package:provider 引用
- shared_preferences：app/lib 无引用
- flutter_secure_storage：app/lib 无引用
- logger：app 使用 base/log，无 package:logger 引用
- network_info_plus：app/lib 无引用

**涉及/修改的文件**
- 修改：`app/pubspec.yaml`

### 2026-01-31 20:25（项目重新分析）

**分析结论**
- `dart analyze app base` 全绿。
- 结构：app 与 base 分工清晰，app 已复用 base 的 theme/extension/cache/api/converter/log 等。
- 代码质量：优化待办已全部完成；app 内仅 1 处 TODO（json_adapter_provider 扩展点）。
- 可选后续：功能待办暂缓；base viewer 精简、Isar 换 Hive/SP 为可选；新实体类时补充 JsonAdapter 注册。

**涉及/修改的文件**
- 修改：`.cursor/summaries/recoding2.md`（新增「项目分析」小节与本节历史）

### 2026-01-31（Isar 同实例、实体 JSON、Riverpod 收尾）

**Isar 用 base 同一实例**
- SjgtvRunner 覆盖 `isar` 返回 `IsarProvider(schemas: [SourceEntitySchema, ProxyEntitySchema, TagEntitySchema])`，与 base 同库 `isar_v5`
- SourceStorage 改用 base 的 `$isar`，移除 `app/lib/src/storage/sjgtv_isar.dart`
- 测试入口用 `configRef` + `isarProvider.overrideWith` 初始化 Isar

**实体 JSON 序列化**
- SourceEntity/ProxyEntity/TagEntity 增加 `@JsonSerializable()`，与 Isar 同写 `*.g.dart`（build_runner 合并）
- 实体提供 `factory fromJson`、`toJson()` 委托生成方法；JsonAdapterImpl 注册三实体 `fromJson`

**SourceStorage 与 lint**
- 查询链移除无意义的 `.anyId()`
- api_server_test、sjgtv_runner 移除多余 `import 'package:base/isar.dart'`（base.dart 已导出）

**Riverpod**
- apiServiceProvider 用 `ref.read(apiClientProvider)`，补充常驻（keepAlive）说明
- 不写 ref 扩展（避免 read/watch 混淆）；各页保留显式 `_apiService => ref.read(apiServiceProvider)`

**涉及/修改的文件**
- 修改：`app/lib/src/app/sjgtv_runner.dart`、`app/lib/src/storage/source_storage.dart`、`app/lib/src/app/provider/api_service_provider.dart`、`app/lib/src/app/provider/json_adapter_provider.dart`、`app/lib/src/model/*_entity.dart`、`app/lib/src/api/shelf/api.dart`、`app/lib/main.dart`、`app/pubspec.yaml`、`app/test/api_server_test.dart`
- 删除：`app/lib/src/storage/sjgtv_isar.dart`
- 新增：`app/lib/src/storage/source_storage.dart`（若此前未纳入）、实体 `*.g.dart` 合并 JSON 生成
