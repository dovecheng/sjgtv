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
  - ⏳ 引入 Riverpod 状态管理

**项目结构**

```
app/lib/src/
├── api/          # API 相关
│   ├── client/   # Retrofit 客户端（api_client.dart）
│   ├── service/  # API 服务层（api_service.dart）
│   └── shelf/    # shelf 本地服务（api.dart）
├── app/          # 应用启动
│   ├── provider/ # 应用级 Provider（json_adapter_provider.dart）
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
- [ ] 引入 Riverpod 状态管理（创建 ApiService Provider）
- [ ] 页面改为通过 Provider 获取 ApiService

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

1. **引入 Riverpod 状态管理**
   - 创建 ApiService 的 Provider
   - 页面通过 ref.read 获取服务实例
   - 替换当前的 ApiService.standalone() 调用

2. **完善功能页面**
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
