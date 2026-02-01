# sjgtv 项目摘要 5

**说明**：本摘要为重置后的当前状态概览，可独立使用。更早历史与单点细节见 [recoding1](.cursor/summaries/recoding1.md)～[recoding4](.cursor/summaries/recoding4.md)。

---

## 项目概要

- **定位**：模块化 Flutter TV 应用，**base**（公共库）+ **app**（应用层）。
- **参考**：DTV；支持多格式与网络流播放、电视遥控器优化。
- **配置**：初始化从 `https://ktv.aini.us.kg/config.json` 加载。
- **当前**：阶段三（app 重构）已完成，阶段四（核心功能）进行中。

---

## 阶段与当前状态

| 阶段 | 状态 | 说明 |
|------|------|------|
| 阶段一 项目结构 | ✅ | base / app 目录、模块化结构 |
| 阶段二 基础库迁移与 base 精简 | ✅ | 从 root/base 迁移、删未使用依赖与模块、viewer 保留 |
| 阶段三 应用迁移与 app 重构 | ✅ | DTV 迁入、AppRunner/Retrofit/Riverpod、主题、Isar 同实例、源管理增删改、L10n 与网页国际化、按业务分类目录 |
| 阶段四 核心功能 | 🔄 | 源管理 ✅；MediaKit 播放有基础；TV 优化/搜索/广告过滤/代理/标签待推进 |

---

## 项目结构

**base**（公共库）

- `api/`、`app/`（runner、config、theme 扩展）、`cache/`、`converter/`、`extension/`（平台、时长、字符串等）、`isar/`、`l10n/`、`log/`、`provider/` 等。
- 扩展方法集中在 `src/extension/` 与 `app/theme/extension/`（如 `context_ext`、`media_query_ext`、`target_platform_ext`）。

**app**（应用层，按业务）

```
app/lib/src/
├── source/     # 数据源：model、provider、l10n、page（SourceManagePage、AddSourcePage）
├── proxy/      # 代理：model、provider
├── tag/        # 标签：model、provider
├── movie/      # 电影：model、page（category、search、detail、full_screen_player）、service（m3u8_ad_remover）、widget
├── shelf/      # ShelfApi 单例、HTTP 服务、web_l10n / api_l10n
└── app/        # 应用级：api（ConfigApi）、provider、runner（sjgtv_runner）、theme、widget（update_checker）
```

- **横屏**：SjgtvRunner 覆写 `preferredOrientations` 仅横屏；当前为**先开发 TV 版**，后续若支持手机/平板可再按设备类型放开方向。
- **PC 窗口**：Windows/macOS 初始 800×600、启动居中、最小尺寸 800×600。
- **二维码**：category_page 仅在 Android/iOS 且设备类型为 TV 时显示二维码按钮（业务内用 `$platform.isMobileNative && context.mediaQuery.deviceType == DeviceType.tv` 判断）。

---

## 待办

**功能与体验**

- [ ] **go_route**：计划用 go_route 做应用路由。
- [ ] **TV 与播放**：优化 TV 焦点、遥控、播放器 UI/交互；完善 MediaKit 播放。
- [ ] **搜索**：已有基础，待优化体验。
- [ ] **广告过滤**：完善 m3u8_ad_remover。
- [ ] **Flutter 代理/标签**（按需）：网页已有管理；是否在 app 内做页待定。

**质量与其它**

- [ ] **代码质量**：`dart analyze` / `dart fix`，清理未使用导入与死代码。
- [ ] **测试**（可选）：业务/API 单元测试可后续补充。
- [ ] **精简**（可选）：base viewer、Isar 换 Hive/SP 等按需排期。

**建议优先级**：优先 TV 与播放 → 按需代理/标签 → 顺手代码质量与测试。

---

## 源管理 / 代理 / 标签：网页 vs Flutter

- **网页**：`app/assets/web/index.html`，shelf 端口 8023；TV/平板扫码；源/代理/标签增删改查与排序已实现；GET /api/l10n + data-i18n 国际化。
- **Flutter**：SourceManagePage、AddSourcePage 已实现；代理/标签暂无 Flutter 页。

---

## 技术栈与原则

- **技术栈**：Flutter SDK ≥3.10；base（Dio、Isar、Riverpod、L10n 等）；app（MediaKit、Retrofit、Riverpod、shelf）。
- **原则**：只在本项目（sjgtv）内修改；参考 root/base、DTV 仅读；循序渐进，每步检查。

---

## 摘要链

- **recoding5**：当前主摘要（本文件），重置后独立使用。
- **recoding1～4**：历史与细节可追溯。

---

## 历史（recoding5）

### 2026-02-01（新建 recoding5，重置摘要）
- 新建 recoding5.md，基于当前项目状态重写一份独立摘要。
- 内容：项目概要、阶段与结构、待办、源管理对比、技术栈与原则、摘要链。

### 2026-02-02（主题仅暗黑 + L10n title + update_checker 主题）
- **主题**：仅支持暗黑，使用原生 `ThemeData.dark()`；删除 app_colors、app_theme，移除 google_fonts；页面与组件改用 `context.theme.colorScheme`、`theme.textTheme`；仅传暗黑主题故不再指定 themeMode。
- **MaterialApp title**：新增 app_l10n（app_title），buildApp 从 l10nTranslationProvider 取 `app_title` 作为 title。
- **update_checker**：对话框颜色与文字样式改为从 Theme.of(context) 的 colorScheme、textTheme 获取。
