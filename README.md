# sjgtv

基于 **Flutter** 的模块化智能电视/机顶盒视频应用工程：`base` 公共库 + `app` 应用（参考 [LibreTV](https://github.com/LibreSpark/LibreTV) / DTV）。应用层支持多格式与网络流播放，面向电视遥控器操作优化。

---

## 📌 项目由来

**本项目由 [LibreTV](https://github.com/LibreSpark/LibreTV)（DTV）作者提议并授意重写的新项目。**

原项目链接：[LibreSpark/LibreTV](https://github.com/LibreSpark/LibreTV)
在此向原作者致谢，并说明本仓库为在其建议下重写、独立维护的新工程。

---

## 📁 工程结构

| 目录   | 说明                         |
|--------|------------------------------|
| `base/`| 公共 Flutter 库（API、缓存、调试、国际化等） |
| `app/` | 视频应用（入口、播放、分类、搜索等）       |

应用详情、配置与截图见 **[app/README.md](app/README.md)**。

---

## 📺 功能概览

- 🎬 **多格式播放**：MP4、HLS、MKV 等
- 📺 **遥控器优化**：专为电视/机顶盒操作设计
- 🔍 **导航与搜索**：分类、选集、搜索
- ⏯️ **播放控制**：播放/暂停、快进/快退、进度条
- 🔉 **音量与常亮**：系统音量、播放时防休眠
- 📡 **多源聚合**：多视频源 API、本地源与代理管理
- ⚙️ **远程配置**：支持通过配置文件初始化

---

## 🛠️ 技术栈

| 技术/组件 | 用途 |
|-----------|------|
| Flutter / Dart ≥3.10 | 跨平台应用框架与语言 |
| **base** | 公共库：Riverpod、Isar、L10n、缓存、调试等 |
| **app** | 视频应用，依赖 base |
| **状态与数据** | `flutter_riverpod`、`provider`、`hive` / `hive_flutter`、`isar_community`（base） |
| **网络与存储** | `dio`、`http`、`shelf` / `shelf_router`（本地 API）、`cached_network_image`、`shared_preferences`、`flutter_secure_storage` |
| **视频播放** | `media_kit`、`media_kit_video`、`media_kit_libs_video` |
| **UI 与资源** | `google_fonts`、`qr_flutter`、`flutter_gen`（资源生成）、`flutter_launcher_icons`（图标生成） |
| **系统能力** | `wakelock_plus`、`permission_handler`、`path_provider`、`url_launcher`、`package_info_plus`、`open_file`、`android_intent_plus`、`network_info_plus` |
| **工具与构建** | `build_runner`、`riverpod_generator`（base）、`retrofit` / `retrofit_generator`（base）等 |

---

## ⚙️ 系统初始化配置

应用启动时从以下地址加载默认配置：
`https://ktv.aini.us.kg/config.json`

格式示例与字段说明见 **[app/README.md](app/README.md)**。

---

## 📱 系统要求

- **Android**：最低 6.0 (API 23)，推荐 9.0+；建议 1GB+ RAM，支持硬件解码
- **开发**：Flutter SDK ≥ 3.10，Dart ≥ 3.10（`base` / `app` 均 `sdk: '>=3.10.0 <4.0.0'`）

---

## 🛠️ 开发与构建

```bash
# 1. 安装依赖（先 base 后 app）
cd base && flutter pub get && cd ..
cd app  && flutter pub get && cd ..

# 2. 运行应用（在 app 目录）
cd app && flutter run

# 3. 构建 Release APK
cd app && flutter build apk --release
```

---

## 📜 开源协议 (MIT)

见 [app/README.md](app/README.md) 中的 MIT License 条款。

---

## ⚠️ 免责声明

1. **技术演示**：本工程仅作 Flutter 技术演示，不提供任何视频内容。
2. **内容来源**：视频均来自第三方 API 或用户本地，开发者不控制内容合法性。
3. **无存储**：应用不存储、不缓存视频资源。
4. **用户责任**：使用者须遵守当地法律法规，禁止传播违法内容。
5. **责任豁免**：因使用本应用产生的法律纠纷，开发者不承担责任。

---

## 📚 参考

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
- [TV 应用设计规范](https://developer.android.com/design/tv)
- [LibreSpark/LibreTV](https://github.com/LibreSpark/LibreTV)（本项目的提议与参考来源）

---

## 🙏 鸣谢

感谢 [LibreTV](https://github.com/LibreSpark/LibreTV) 作者提议重写新项目并授权参考原实现，本仓库在此基础上独立演进。

---

> ✨ 欢迎贡献：请提交 PR 到 `main` 分支。
> 🐞 问题反馈：<laopaoer@protonmail.com>
