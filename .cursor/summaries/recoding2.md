**项目概要**

sjgtv 是一个模块化的 Flutter TV 应用项目，采用 base（基础库）+ app（应用层）的结构。当前处于**阶段三：app 模块重构**阶段，重构方向为**先统一 API 层，后引入状态管理**。

**当前状态**

- **阶段一**（项目结构搭建）✅ 已完成
- **阶段二**（基础库迁移 + base 精简）✅ 已完成
- **阶段三**（应用代码迁移与 app 重构）🔄 进行中
  - ✅ 从 DTV 复制应用代码到 app 模块
  - ✅ app 重构方向分析：先 API、后状态管理
  - ✅ 接入 Retrofit：新建 `api_client.dart` 声明本地 shelf 接口
  - 🔄 逐步集成 base 与 app
  - 🔄 API 层重构（Dio + shelf → 统一 API 服务）
  - ⏳ 引入 Riverpod 状态管理

**未完成的待办**

阶段三：应用代码迁移与 app 重构
- [ ] 逐步集成 base 模块与 app 模块（依赖、导出、引用）
- [ ] 完成 API 层重构：
  - [ ] 统一 Dio 分散调用（main、category_page、search_page 等）
  - [ ] 整合 shelf 本地服务（/api/sources|proxies|tags）
  - [ ] 统一 Hive 数据访问
  - [ ] 页面改为调用统一 API 服务
- [ ] 引入 Riverpod 状态管理（API 层统一后）
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

可选精简（优先级低）
- [ ] 删除 viewer 模块（含 webview_flutter）
- [ ] 替换 Isar 为 Hive/SP（需改 app_config、l10n 存储）

**下一步行动**

1. **API 层统一重构**（当前优先级最高）
   - 分析当前 Dio 调用分布（main.dart、各 page）
   - 分析 shelf 本地服务实现（api.dart）
   - 设计统一 API 服务层结构
   - 逐步迁移 Dio 调用到 Retrofit API
   - 整合 shelf 服务与 Hive 数据访问

2. **状态管理集成**（API 层统一后）
   - 引入 Riverpod 生成代码模式
   - 页面改为使用 Provider 获取数据

3. **阶段四核心功能**（阶段三稳定后）
   - 按待办顺序逐项实现

**开发原则**

- 循序渐进，每步检查修复错误
- 只复制必要代码，避免过度复杂
- 只在本项目（sjgtv）内修改，不修改 root、DTV
- 每项完成后 `flutter pub get`、`dart analyze` 通过再继续

**项目与参考**

- 当前项目：`~/projects/sjgtv`
- 参考项目：`~/projects/root/base`、`~/projects/DTV`（只读参考，不修改）

**技术栈**

- Flutter SDK ≥3.10
- 基础库（base）：Dio、Isar、Riverpod、flutter_hooks 等
- 应用层（app）：MediaKit（播放）、Retrofit（API）、Riverpod（状态管理）

**备注**

- 旧摘要：`.cursor/summaries/recoding1.md`（含完整历史记录）
- 旧开发日志：`.qwen/DAILY_WORK_LOG.md`
