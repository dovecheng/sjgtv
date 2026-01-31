**会话概要**
- 用户要求将「可选下一步」记录到新摘要 recoding3
- 可选下一步来自 ok 收尾（recoding2 收尾后给出的下一步建议）

**引用摘要**（再次会话时先读旧摘要以延续上下文）
- [recoding2](.cursor/summaries/recoding2.md)：项目阶段三（app 重构）进行中；Isar 与 base 共用同一实例、实体 JSON 序列化（json_serializable 同 g 文件）、SourceStorage 用 `$isar`、Riverpod apiServiceProvider 用 ref.read 与 keepAlive 说明；收尾后给出本摘要中的「可选下一步」。
- 更早上下文：[recoding1](.cursor/summaries/recoding1.md)（阶段一/二、base 精简、模块化与收尾流程）。

**后续摘要**
- 无（本摘要为当前最新；新开摘要时可在此注明后续文件）。

**完成项**
- 新建摘要 `.cursor/summaries/recoding3.md`，将可选下一步整理为待办

**源管理 / 代理 / 标签：网页 vs Flutter**
- **网页**：`app/assets/web/index.html`，shelf 端口 8023 提供；TV/平板扫码打开，源/代理/标签的增删改查、排序均已实现。
- **Flutter**：SourceManagePage（源列表、启用禁用、进 AddSourcePage）、AddSourcePage（添加源）；缺源删除、源编辑；代理/标签暂无 Flutter 页。

**未完成的计划**
- [ ] **Flutter 源管理**：SourceManagePage 补**删除源**、**编辑源**（列表项操作 + 编辑页或弹窗，shelf API 已有；可参考**网页** index.html 的删除/编辑交互）
- [ ] **Flutter 代理/标签**（若需要）：网页已有代理/标签管理；是否在 app 内做代理管理页、标签管理页，待定
- [ ] **网页国际化**：见下方「网页国际化（建议）」方案，待实现
- [ ] TV 与播放：继续优化 TV 焦点、遥控、播放器 UI/交互
- [ ] 代码质量：再跑一遍 `dart analyze` / `dart fix`，查未使用导入与死代码
- [ ] 重新分析项目：若用户说「要分析」，则对项目做分析并整理、更新摘要

**网页国际化（建议）**

- **目标**：`app/assets/web/index.html`（shelf 8023 提供）与 Flutter app 共用同一套文案（en / zh-CN / zh-HK），语言可切换。
- **数据源**：与 Flutter 一致，以 app 的 `L10n.translations` + base 的 `L10n.translations` 合并后的 key-value 为准；网页只消费，不新增 key 定义。
- **推荐做法**：
  1. **shelf 提供翻译接口**：新增 `GET /api/l10n?lang=zh-CN`（或 `Accept-Language`），返回当前语言的 `{ "app_source_manage_title": "源管理", ... }` JSON。在 Dart 里用已合并的 `L10nTranslationModel`（与 l10nTranslationProvider 同源或同逻辑）按 `lang` 取对应语言的 `translations` 序列化即可。
  2. **页面约定**：在 HTML 上对需要翻译的节点加 `data-i18n="key"`（如 `data-i18n="app_source_manage_title"`），`<title>`、按钮、表头、提示语等全部用 key。
  3. **前端逻辑**：页面加载时先取当前语言（`localStorage.getItem('l10n_lang')` 或 `navigator.language` 规整为 zh-CN / zh-HK / en），请求 `GET /api/l10n?lang=xxx`，拿到 JSON 后遍历 `document.querySelectorAll('[data-i18n]')`，用 `key` 取文案填入 `textContent`；`<title>`、`placeholder` 等按需单独处理。
  4. **语言切换**：页面上提供语言切换控件（如下拉或按钮），选好后写 `localStorage.setItem('l10n_lang', lang)`，再请求一次 `/api/l10n?lang=xxx` 并重新执行一次替换，可选刷新整页。
- **可选**：若希望首屏无请求，可在构建或 shelf 启动时导出一份多语言 JSON（如 `l10n.json` 含 `{ "en": {...}, "zh-CN": {...}, "zh-HK": {...} }`）放到静态资源，页面加载该文件再按当前 lang 取一段；与 Flutter 的同步需通过脚本从 Dart 的 L10n 生成该 JSON。
- **实施顺序建议**：先做 shelf `/api/l10n` + 页面 data-i18n 与 JS 替换；再视需要做语言切换与 localStorage；最后如需再考虑静态 l10n.json 与构建脚本。

**本次完成（2026-01-31）**
- **app 模块 bug 修复**：full_screen_player_page 切换集数后 setState 前加 mounted 检查；movie_detail_page 选集焦点监听 setState 前加 mounted；full_screen_player 中 void async 改为 Future<void>
- **app 模块 l10n 接入**：定义 app_l10n 抽象类（@L10nKeys + @L10nKey），用 base 的 tool gen_l10n_mixin 生成 L10n 枚举与 AppL10nMixin；SjgtvRunner 注入 L10n.translations 到 l10nTranslationProvider；SourceManagePage、AddSourcePage 混入 AppL10nMixin 并替换文案；使用国际化的控件套上 L10nKeyTips（keyTips 用 xxxL10nKey）

**涉及/修改的文件**
- 新增：`.cursor/summaries/recoding3.md`
- 本次：app/lib/src/app/sjgtv_runner.dart；app/lib/src/page/source/source_manage_page.dart、add_source_page.dart；app/lib/src/page/player/full_screen_player_page.dart；app/lib/src/page/search/movie_detail_page.dart；app/lib/gen/l10n.gen.dart；app/lib/src/l10n/（app_l10n.dart、app_l10n.gen.dart）

## 历史

### 2026-01-31 21:32
- 创建 recoding3，将会话中 ok 收尾给出的「可选下一步」记录为未完成计划（5 条待办）

### 2026-01-31 21:32（补充引用）
- 新增「引用摘要」小节，引用 [recoding2](.cursor/summaries/recoding2.md)，便于再次会话时先读旧摘要以延续上下文

### 2026-01-31 21:32（一二三摘要关联）
- 确保 recoding1、recoding2、recoding3 相互关联：recoding1 增加「引用摘要/后续摘要」指向 recoding2 与 recoding3；recoding2 增加「引用摘要」指向 recoding1、「后续摘要」指向 recoding3；recoding3 在引用摘要中补充 recoding1，并增加「后续摘要」说明本摘要为当前最新

### 2026-01-31 21:32（待办补充）
- 待办补充：Flutter 源管理缺删除、编辑，已写入「未完成的计划」（SourceManagePage 补删除/编辑，可参考网页 index.html）

### 2026-01-31 21:32（区分网页与 Flutter）
- 新增「源管理/代理/标签：网页 vs Flutter」说明：网页 = index.html（扫码管理，功能完整）；Flutter = SourceManagePage/AddSourcePage（缺删除、编辑；代理/标签暂无）。待办中明确标注 **Flutter 源管理**、**Flutter 代理/标签**，避免与网页混淆

### 2026-01-31（ok 收尾：app bug 修复 + app l10n 接入）
- **app bug 修复**：full_screen_player_page 中 _changeEpisode 成功分支 setState 前加 if (mounted)；movie_detail_page 中 _episodesFocusNode.addListener 内 setState 前加 if (mounted)；_controlWakelock、_preloadNextEpisode、_changeEpisode 由 void async 改为 Future<void>
- **app l10n**：新增 app/lib/src/l10n/app_l10n.dart（@L10nKeys keysPrefix: app + 8 个 @L10nKey getter）；dart run tool/gen_l10n_mixin.dart 生成 app/lib/gen/l10n.gen.dart（L10n 枚举 + translations）、app/lib/src/l10n/app_l10n.gen.dart（AppL10nMixin）；SjgtvRunner override l10nTranslation => L10nTranslationProvider(L10n.translations)；SourceManagePage、AddSourcePage 混入 AppL10nMixin，文案用 xxxL10n，并用 L10nKeyTips(keyTips: xxxL10nKey, child: ...) 包裹

### 2026-01-31（网页国际化建议写入摘要）
- 用户要求网页（index.html）也做国际化，建议方案写入「网页国际化（建议）」：shelf 提供 GET /api/l10n?lang=xxx 返回合并后的 key-value JSON；页面用 data-i18n="key" 标记节点，加载时请求翻译并替换；语言可选 localStorage + 切换时重新请求；可选静态 l10n.json 与构建脚本。待办中增加「网页国际化」项。
