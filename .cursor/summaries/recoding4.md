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
- [ ] **go_route**：计划使用 go_route 做应用路由。
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

## 项目结构（app，业务 > 职责）

```
app/lib/src/
├── source/       # 数据源业务
│   ├── model/
│   ├── provider/
│   ├── l10n/
│   └── page/
├── proxy/        # 代理业务
│   ├── model/
│   └── provider/
├── tag/          # 标签业务
│   ├── model/
│   └── provider/
├── movie/        # 电影业务
│   ├── model/
│   ├── page/     # category、search、detail、full_screen_player、player_intents
│   ├── service/  # m3u8_ad_remover
│   └── widget/   # focusable_movie_card、network_image_placeholders
├── app/api/      # 远程 API：ConfigApi（config.json）
├── shelf/        # 独立业务：ShelfApi 单例，混入 ShelfApiL10nMixin；HTTP 服务，调用 provider 读写数据
│   ├── api.dart  # ShelfApi 路由与 handler
│   └── l10n/     # api_l10n（shelf API 消息）、web_l10n（index.html 网页专属）
└── app/          # 应用级
    ├── api/      # ConfigApi（远程配置）
    ├── provider/ # config_api_provider、json_adapter_provider
    ├── runner/   # sjgtv_runner
    ├── theme/
    └── widget/   # update_checker
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

- shelf 提供 `GET /api/l10n`，过滤 `web_` 前缀返回翻译 JSON；语言跟随 Flutter 当前语言。
- **web_l10n**（keysPrefix: web）：index.html 专属，与 **source_l10n**（Flutter 源管理页）分离，避免共用。
- 网页对需翻译节点加 `data-i18n` / `data-i18n-placeholder` / `data-i18n-title`，加载时 `await applyL10n()` 后请求 `/api/l10n`，替换文案与 document.title；JS 动态消息用 `t(key)`、`tReplace(key, {name})`。

**待补翻译**：已补全。

---

## 老项目 DTV 的 AI 索引（参考用）

- **来源**：https://zread.ai/laopaoer-wallet/DTV/1-overview（zread.ai 上的 DTV 项目 AI 索引，1-overview 为概览页）。
- **用途**：供会话中查阅 DTV 老项目结构、逻辑时参考；仅读参考，不修改 DTV。

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

### 2026-02-01（计划使用 go_route）
- 未完成的计划：补充 **go_route**（计划使用 go_route 做应用路由）。

### 2026-02-01（app 按业务分类重构）
- app 结构改为按业务分类：source/（model、provider、storage、count、l10n、page）、proxy/、tag/、movie/ 各自包含其 model、provider、count 等；api/ 保留跨业务层；删除 model/、provider/、sources/、proxies/、tags/、count/、l10n/ 等按功能分类的目录。

### 2026-02-01（业务下按职责分子目录）
- 业务下再按职责分：source/model/、source/provider/、source/l10n/、source/page/；proxy/model/、proxy/provider/；tag/model/、tag/provider/；movie/model/、movie/page/、movie/widget/。

### 2026-02-01（移除 api 层、ConfigApi、AppWrapper）
- **移除 api/**：Flutter UI 不再通过 HTTP 调用 localhost 获取源/代理/标签，直接使用 Riverpod provider。
- **ConfigApi**：app/api/config_api.dart，Retrofit 单例，调用远程 config.json；configApiProvider 返回请求结果 Map。
- **AppWrapper 逻辑**：移至 MovieHomePage（category_page.dart），删除 app_wrapper.dart。

### 2026-02-01（shelf/网页/源 l10n 调整）
- **ShelfApi 单例**：shelf api.dart 定义 ShelfApi 类，混入 ShelfApiL10nMixin，全部方法入类，方法内用 this.xxxL10n 获取翻译。
- **web_l10n**：新建 keysPrefix: web，index.html 专属；handleGetL10n 过滤 web_ 前缀；补全网页全部文案 data-i18n、JS 用 t()/tReplace()。
- **source_l10n**：去除方法名冗余前缀（manageTitleL10n、listTitleL10n、addTitleL10n、nameL10n、urlHintL10n），避免 source_source_xxx 叠加。

### 2026-02-01 13:56（记录 DTV 老项目 AI 索引来源）
- 补充 **老项目 DTV 的 AI 索引** 小节：来源 https://zread.ai/laopaoer-wallet/DTV，供会话中参考 DTV 结构/逻辑；本次拉取该 URL 超时未获取到正文，仅记录 URL 与待补充说明。

### 2026-02-01（补全网页待翻译项）
- index.html：`throw new Error('获取源列表失败')`、`throw new Error('获取标签列表失败')` 改为 `t('web_msg_xxx')`；`aria-label="关闭"` 改为 `t('web_close')`；`title="权重: ${...}"` 改为 `t('web_weight'): ${...}`。web_l10n 新增 closeL10n。待补翻译已全部完成。
