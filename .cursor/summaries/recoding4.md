**会话概要**
- 根据 [recoding1](.cursor/summaries/recoding1.md)、[recoding2](.cursor/summaries/recoding2.md)、[recoding3](.cursor/summaries/recoding3.md) 三份摘要整理出本摘要，作为项目级整合概览；详细历史与单点完成项见前三份。

**引用摘要**（再次会话时先读以延续上下文）
- [recoding1](.cursor/summaries/recoding1.md)：阶段一/二（项目结构、base 迁移与精简）、模块化与收尾流程、阶段三起步。
- [recoding2](.cursor/summaries/recoding2.md)：阶段三 app 重构（AppRunner、Retrofit、Riverpod、主题、Isar 同实例、实体 JSON、SourceStorage）。
- [recoding3](.cursor/summaries/recoding3.md)：源管理删除/编辑、网页国际化、app 结构重组、项目分析、文档一致性。

**后续摘要**
- 无（本摘要为整合概览；新会话可继续在 recoding3/recoding4 上追加待办或新建专题摘要）。

---

## 项目概要

sjgtv 为模块化 Flutter TV 应用：**base**（公共库）+ **app**（应用层）。参考 DTV，支持多格式与网络流播放、电视遥控器优化；初始化配置从 `https://ktv.aini.us.kg/config.json` 加载。当前阶段三（app 重构）已基本完成，阶段四（核心功能）部分完成，待办以 TV/播放体验、代理/标签、代码质量为主。

---

## 阶段与当前状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| **阶段一** 项目结构搭建 | ✅ 完成 | base / app 目录、模块化结构 |
| **阶段二** 基础库迁移 + base 精简 | ✅ 完成 | 从 root/base 迁移、删未使用依赖与 debug 模块、viewer 保留 |
| **阶段三** 应用代码迁移与 app 重构 | ✅ 完成 | DTV 代码迁入、先 API 后状态管理、AppRunner/Retrofit/ApiService/Riverpod、主题统一、Isar 同实例、实体 JSON、源管理增删改、app 结构扁平化（移除 src/app 嵌套）、L10n 与网页国际化 |
| **阶段四** 核心功能 | 🔄 进行中 | 源管理（含删除/编辑）✅；视频播放（MediaKit）已有基础；TV 优化/搜索/广告过滤/代理/标签待推进 |

---

## 未完成的计划（合并自三份摘要）

**功能与体验**
- [ ] **Flutter 代理/标签**（若需要）：网页已有代理/标签管理；是否在 app 内做代理管理页、标签管理页，待定。
- [ ] **TV 与播放**：继续优化 TV 焦点、遥控、播放器 UI/交互；视频播放（MediaKit）已有基础，待优化/完善。
- [ ] **搜索功能**：已有基础实现，待优化体验。
- [ ] **广告过滤**：已有 m3u8_ad_remover，待完善或扩展。

**质量与精简**
- [ ] **代码质量**：再跑一遍 `dart analyze` / `dart fix`，查未使用导入与死代码。
- [ ] **测试**（可选）：业务逻辑与 API 契约暂无单元测试，可后续补充。
- [ ] **精简**（可选）：base 的 viewer 模块、Isar 换 Hive/SP 等，按需排期。

**建议优先级**（来自 recoding3 项目分析结论）
- 优先：TV 与播放体验优化。
- 按需：若需在 app 内管理代理/标签再补页。
- 顺手：代码质量与测试可在日常迭代中做。

**已完成（仅列关键，细节见 recoding1/2/3）**
- [x] 阶段一/二/三全部项；Flutter 源管理增删改与 sourcesProvider；网页国际化（GET /api/l10n + data-i18n）；app 文件结构重组；重新分析项目；文档一致性（app/README 技术栈按 pubspec 更新）。

---

## 项目结构（app，当前）

```
app/lib/src/
├── api/          # API：client（Retrofit）、service（ApiService）、shelf（本地服务 + web_l10n）
├── l10n/          # 应用与网页 L10n（app_api_l10n、app_web_l10n）
├── model/         # 数据模型与实体（source、proxy、tag、movie 等）
├── page/          # 页面：home、player、search、source
├── provider/      # Riverpod 提供者（api_service、sources、json_adapter）
├── service/       # 通用服务（m3u8_ad_remover）
├── storage/       # 存储（SourceStorage，用 base $isar）
├── theme/         # 主题（app_colors、app_theme）
├── widget/        # 通用组件（focusable_movie_card、network_image_placeholders、update_checker）
└── sjgtv_runner.dart  # 应用启动器（继承 base AppRunner）
```

---

## 源管理 / 代理 / 标签：网页 vs Flutter

- **网页**：`app/assets/web/index.html`，shelf 端口 8023；TV/平板扫码打开；源/代理/标签增删改查与排序均已实现；已接入 GET /api/l10n 与 data-i18n 国际化。
- **Flutter**：SourceManagePage（源列表、启用/禁用、删除、编辑、进 AddSourcePage）、AddSourcePage（添加/编辑源）；代理/标签暂无 Flutter 页。

---

## 项目分析结论（2026-01-31，摘要）

- **架构**：base + app 模块化清晰；SjgtvRunner 注入 L10n、Isar schema、API 客户端与 JSON 适配器，结构合理。
- **代码质量**：base 与 app 均 `dart analyze` 无错误；`dart fix --dry-run` 无待修复项。
- **依赖**：app 与 base 版本已对齐；retrofit 4.9.0 通过 dependency_overrides 固定。
- **测试**：app 仅有 api_server_test（shelf + Provider）；无业务/API 单元测试，可后续补充。
- **文档**：根 README 与 app/README 已按依赖更新（含 media_kit、riverpod、shelf 等）。

---

## 网页国际化（已实现摘要）

- shelf 提供 `GET /api/l10n`，返回 `getWebL10nMap()` 的 JSON；语言跟随 Flutter 当前语言。
- 网页对需翻译节点加 `data-i18n` / `data-i18n-placeholder`，加载时请求 `/api/l10n` 并执行 `applyL10n()` 替换文案与 document.title。
- 详细约定与扩展见 recoding3「网页国际化（建议）」。

---

## 开发原则与参考

- 循序渐进，每步检查修复错误；只复制必要代码；只在本项目（sjgtv）内修改，不修改 root、DTV。
- 当前项目：`~/projects/sjgtv`。参考项目：`~/projects/root/base`、`~/projects/DTV`（只读参考）。
- 技术栈：Flutter SDK ≥3.10；base（Dio、Isar、Riverpod、L10n 等）；app（MediaKit、Retrofit、Riverpod、shelf）。

---

## 摘要链说明

- **recoding1** → **recoding2** → **recoding3** → **recoding4**：按时间推进；recoding4 为根据前三份整理的整合概览，不替代前三份；详细历史与单次变更见 recoding1/2/3。
- 新会话建议：先读 recoding3 或 recoding4 获取当前待办与结论；若需更早上下文再读 recoding2、recoding1。

---

## 历史

（每条须为「YYYY-MM-DD HH:mm」或「YYYY-MM-DD HH:mm（说明）」格式。）

### 2026-01-31 22:00（创建 recoding4，根据三份摘要整理）
- 根据 recoding1、recoding2、recoding3 整理第四份摘要 recoding4.md，作为项目级整合概览。
- 内容包含：引用/后续摘要、项目概要、阶段与当前状态、未完成的计划（合并去重）、项目结构、源管理/代理/标签对比、项目分析结论摘要、网页国际化已实现摘要、开发原则与参考、摘要链说明。

### 2026-01-31 22:10（待办与建议补全，无遗漏）
- 对照 recoding2 阶段四与 recoding3 待办核查：补入**搜索功能**（已有基础，待优化）、**广告过滤**（已有 m3u8_ad_remover，待完善）；在「TV 与播放」中注明视频播放（MediaKit）已有基础、待优化。
- 新增**建议优先级**小节（来自 recoding3 项目分析结论）：优先 TV 与播放；按需代理/标签；顺手代码质量与测试。
