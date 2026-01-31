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

**项目结构**

```
app/lib/src/
├── api/          # API 相关
│   ├── client/   # Retrofit 客户端（api_client.dart）
│   ├── service/  # API 服务层（api_service.dart）
│   └── shelf/    # shelf 本地服务（api.dart）
├── app/          # 应用启动
│   ├── provider/ # 应用级 Provider（json_adapter_provider.dart, api_service_provider.dart）
│   └── sjgtv_runner.dart
├── model/        # 数据模型（source, proxy, tag, movie）
├── page/         # 页面
│   ├── home/     # 首页（app_wrapper, category_page）
│   ├── player/   # 播放器（full_screen_player_page, player_intents）
│   └── search/   # 搜索（search_page, movie_detail_page）
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
- [ ] 源管理功能（Riverpod 生成代码模式）
- [ ] 视频播放（MediaKit）- 已有基础实现
- [ ] TV 优化 UI 组件
- [ ] 搜索功能 - 已有基础实现
- [ ] 广告过滤 - 已有 m3u8_ad_remover
- [ ] 代理管理
- [ ] 标签管理

可选精简（优先级低）
- [ ] 删除 viewer 模块（含 webview_flutter）
- [ ] 替换 Isar 为 Hive/SP（需改 app_config、l10n 存储）

**下一步行动**

1. **完善功能页面**
   - 源管理页面
   - 代理管理页面
   - 标签管理页面

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
