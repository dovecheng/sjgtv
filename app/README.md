```markdown
---

# LibreTV 应用

一个基于 **Flutter** 开发的智能电视/机顶盒视频播放应用，支持多种视频格式和网络流媒体播放，专为电视遥控器操作优化。

---

## 📺 功能特性

- 🎬 **多格式支持**：播放 MP4、HLS、MKV 等主流视频格式
- 📺 **遥控器优化**：专为电视/机顶盒遥控器操作设计
- 🔍 **快速导航**：支持选集、章节跳转
- ⏯️ **播放控制**：播放/暂停、快进/快退、进度条拖动
- 🔉 **音量调节**：支持系统音量控制
- 🌙 **屏幕常亮**：播放时防止设备休眠
- 📡 **API 聚合**：支持多视频源 API 接口
- 💾 **本地源管理**：支持通过Web界面管理本地视频源和代理设置
- ⚙️ **动态配置**：支持远程加载配置文件初始化系统

---

## 🛠️ 技术栈

| 技术/组件 | 用途 |
|----------|------|
| Flutter 3.x / Dart 3.x | 跨平台应用开发框架与语言 |
| `base`（path） | 公共库：Riverpod、Isar、L10n、API、缓存等 |
| `flutter_riverpod` / `riverpod_annotation` | 状态管理 |
| `isar_community` | 本地数据库（与 base 共用实例） |
| `dio` / `retrofit` | HTTP 客户端与 API 声明 |
| `cached_network_image` | 网络图片缓存 |
| `media_kit` | 核心视频播放（MP4、HLS、MKV 等） |
| `media_kit_video` | 播放器 UI 控件 |
| `media_kit_libs_video` | 各平台视频解码库 |
| `shelf` / `shelf_router` / `shelf_static` | 本地 Web 服务（端口 8023，管理页与 API） |
| `shelf_cors_headers` | CORS 支持 |
| `qr_flutter` | 二维码（扫码打开管理页等） |
| `flutter_gen` | 资源与 L10n 代码生成 |
| `wakelock_plus` | 播放时防休眠 |
| `path_provider` | 应用目录路径 |
| `permission_handler` | 权限请求 |
| `package_info_plus` | 应用版本信息 |
| `url_launcher` | 打开外部链接 |
| `open_file` | 打开本地文件 |
| `android_intent_plus` | Android 意图（如调起外部播放） |

**构建与代码生成**：`build_runner`、`riverpod_generator`、`retrofit_generator`、`json_serializable`、`isar_community_generator`、`flutter_gen_runner`。**图标生成**：`flutter_launcher_icons`。

---

## ⚙️ 系统初始化配置

应用启动时会从以下URL加载默认配置：
`https://ktv.aini.us.kg/config.json`

### 配置文件格式示例：
```json
{
	"sources": [
		{
			"name": "xx资源",
			"url": "https://xxx.com/api.php/provide/vod",
			"weight": 5,
			"disabled": false
		},
		// 更多视频源...
	],
	"proxy": {
		"name": "默认代理",
		"enabled": true,
		"url": "https://proxy.aini.us.kg"
	}
}
```

### 配置参数说明：
- `sources`: 视频源列表
    - `name`: 资源名称
    - `url`: API地址
    - `weight`: 权重(1-10)
    - `disabled`: 是否禁用
- `proxy`: 代理设置
    - `name`: 代理名称
    - `enabled`: 是否启用
    - `url`: 代理服务器地址

---

## 📱 系统要求

### Android 运行环境要求
- **最低系统版本**：Android 6.0 (API level 23)
- **推荐系统版本**：Android 9.0+ (API level 28+)
- **硬件要求**：
    - 支持硬件解码的芯片组
    - 至少 1GB RAM（流畅运行建议 2GB+）
---

## 💻 本地源管理

LibreTV 提供 Web 管理界面用于管理视频源和代理设置：

1. **访问管理界面**：
    - 在浏览器中输入：`http://[设备IP地址]:8023`
    - 示例：`http://192.168.1.100:8023`

2. **管理功能**：
    - 添加/编辑/删除视频源
    - 配置代理服务器
    - 调整资源权重
    - 启用/禁用特定资源

---

---

## 📸 应用截图

<div align="center">
  <img src="screenshots/home.png" width="400" alt="主界面截图">
  <img src="screenshots/search.png" width="400" alt="搜索界面截图">
  <img src="screenshots/player.png" width="400" alt="播放界面截图">
  <img src="screenshots/detail.png" width="400" alt="详情界面截图">
  <img src="screenshots/admin.png" width="400" alt="管理界面截图">
</div>


## 📜 开源协议 (MIT License)

```text
Copyright (c) 2023 LibreTV Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## ⚠️ 免责声明

1. **技术演示用途**：本应用仅为 Flutter 开发技术演示，不提供任何视频内容。
2. **内容来源**：所有视频内容均来自第三方 API 接口或用户本地资源，开发者无法控制其内容合法性。
3. **无存储功能**：应用本身不存储、不缓存任何视频资源。
4. **用户责任**：使用者应遵守所在地区法律法规，禁止传播违法内容。
5. **责任豁免**：因使用本应用产生的任何法律纠纷，开发者不承担任何责任。

---

## 🛠️ 开发环境

```bash
# 1. 安装依赖
flutter pub get

# 2. 运行应用（连接设备或模拟器）
flutter run

# 3. 构建APK（Android）
flutter build apk --release
```

**系统要求**：
- Flutter SDK ≥ 3.0
- Dart ≥ 3.0
- Android Studio / VS Code

### 应用启动图标

使用 [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) 从 `assets/icon/icon.png` 生成各平台图标（Android、iOS、Web、Windows、macOS）。替换源图后执行：

```bash
flutter pub get
dart run flutter_launcher_icons
# 或运行 ./script/dart\ run\ flutter_launcher_icons.sh
```

---

## 📚 参考资料

- [Flutter 官方文档](https://docs.flutter.dev/)
- [Dart 语言指南](https://dart.dev/guides)
- [media_kit 插件文档](https://pub.dev/packages/media_kit)
- [TV 应用设计规范](https://developer.android.com/design/tv)

---

## 🙏 鸣谢

特别感谢 [LibreSpark/LibreTV](https://github.com/LibreSpark/LibreTV) 项目作者提供的灵感和技术思路。

---

> ✨ 欢迎贡献代码！请提交 Pull Request 到 `dev` 分支。
> 🐞 问题反馈：<laopaoer@protonmail.com>
