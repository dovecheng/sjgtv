# sjgtv

基于 **Flutter** 的智能电视/机顶盒视频应用，采用整洁架构设计，支持多格式播放与遥控器操作优化。

> ⚠️ **开发中**：本项目尚在开发阶段，**未正式发布**。功能、API 与结构可能变更，暂不建议用于生产环境。

---

## 📌 项目由来

**本项目由 [DTV](https://github.com/laopaoer-wallet/DTV) 作者（laopaoer）提议并授意重写的新项目。**

原项目链接：[laopaoer-wallet/DTV](https://github.com/laopaoer-wallet/DTV)
谢谢他把我带入坑，本仓库在其建议下重写、独立维护。

---

## 📁 工程结构

```
sjgtv/
├── app/                           # 主应用目录
│   ├── lib/
│   │   ├── core/                   # 核心层（基础设施）
│   │   │   ├── api/                # API 客户端、结果类型
│   │   │   ├── arch/               # 架构层（错误处理、Result 模式）
│   │   │   ├── cache/              # 缓存策略
│   │   │   ├── converter/          # 数据转换器
│   │   │   ├── extension/          # 扩展方法
│   │   │   ├── isar/               # Isar 数据库
│   │   │   ├── l10n/               # 国际化
│   │   │   ├── log/                # 日志
│   │   │   ├── provider/           # Provider 基础类
│   │   │   ├── theme/              # 主题配置
│   │   │   └── utils/              # 工具类
│   │   ├── data/                    # 数据层
│   │   │   ├── datasources/        # 数据源接口和实现
│   │   │   ├── models/             # 数据模型（Isar）
│   │   │   └── repositories/       # 仓库实现
│   │   ├── domain/                  # 领域层
│   │   │   ├── entities/           # 实体
│   │   │   ├── repositories/       # 仓库接口
│   │   │   └── usecases/           # 用例
│   │   ├── di/                     # 依赖注入
│   │   └── src/                    # 表现层
│   │       ├── app/                 # 应用入口、路由、配置
│   │       ├── movie/               # 电影模块
│   │       ├── source/              # 视频源模块
│   │       ├── proxy/               # 代理模块
│   │       ├── tag/                 # 标签模块
│   │       ├── favorite/            # 收藏模块
│   │       ├── watch_history/       # 观看历史模块
│   │       └── settings/            # 设置模块
│   ├── assets/                     # 资源文件
│   ├── test/                       # 测试文件
│   ├── web/                        # Web 平台
│   ├── android/                    # Android 平台
│   ├── ios/                        # iOS 平台
│   ├── linux/                      # Linux 平台
│   ├── macos/                      # macOS 平台
│   └── windows/                    # Windows 平台
└── AGENTS.md                       # AI 智能体配置
```

### 架构说明

本项目采用 **整洁架构** 设计原则：

- **Domain 层**（`lib/domain/`）：核心业务逻辑，包含实体、仓库接口、用例
- **Data 层**（`lib/data/`）：数据访问逻辑，包含数据源、数据模型、仓库实现
- **Presentation 层**（`lib/src/`）：UI 层，包含页面、Provider、组件
- **Core 层**（`lib/core/`）：基础设施，包含通用工具、API、缓存、日志等

**依赖规则**：Presentation → Domain → Data → Core

---

## 📺 功能概览

### 核心功能
- 🎬 **多格式播放**：支持 MP4、HLS、MKV 等多种视频格式
- 📺 **遥控器优化**：专为电视/机顶盒操作设计，支持方向键导航
- 🔍 **导航与搜索**：分类浏览、选集切换、关键词搜索
- ⏯️ **播放控制**：播放/暂停、快进/快退、进度条拖动
- 🔉 **音量与常亮**：系统音量控制、播放时防休眠

### 视频源管理
- 📡 **多源聚合**：支持多视频源 API、本地源管理
- 🔀 **播放源切换**：播放页面一键切换播放源
- ⚡ **源测速**：对各源进行速度测试，辅助选择流畅线路
- 🏷️ **标签管理**：自定义视频源标签，方便分类管理
- 🌐 **代理支持**：为视频源配置代理，突破访问限制

### 用户数据
- ❤️ **收藏功能**：收藏喜欢的电影，快速访问
- 📝 **观看历史**：自动记录观看进度，随时继续播放
- ⚙️ **设置管理**：个性化播放设置（音量、倍速、自动播放）
- 🎨 **主题切换**：支持浅色/深色/跟随系统主题

### 其他功能
- ⚙️ **远程配置**：支持通过配置文件初始化应用

---

## 🛠️ 技术栈

| 技术/组件 | 用途 |
|-----------|------|
| Flutter / Dart ≥3.10 | 跨平台应用框架与语言 |
| **状态管理** | `flutter_riverpod`、`riverpod_generator` |
| **本地存储** | `isar_community`、`shared_preferences`、`flutter_secure_storage` |
| **网络请求** | `dio`、`http` |
| **视频播放** | `media_kit`、`media_kit_video`、`media_kit_libs_video` |
| **图片加载** | `cached_network_image` |
| **UI 与资源** | `google_fonts`、`qr_flutter`、`flutter_gen`（资源生成）、`flutter_launcher_icons`（图标生成） |
| **系统能力** | `wakelock_plus`、`permission_handler`、`path_provider`、`url_launcher`、`package_info_plus`、`open_file`、`android_intent_plus`、`network_info_plus` |
| **工具与构建** | `build_runner`、`retrofit` / `retrofit_generator` |

---

## ⚙️ 系统初始化配置

应用启动时从以下地址加载默认配置：
`https://ktv.aini.us.kg/config.json`

配置格式示例：

```json
{
  "sources": [
    {
      "name": "示例源",
      "url": "https://example.com/api",
      "type": "api",
      "enabled": true
    }
  ],
  "proxies": [
    {
      "name": "示例代理",
      "host": "127.0.0.1",
      "port": 7890,
      "type": "http"
    }
  ]
}
```

---

## 📱 系统要求

- **Android**：最低 6.0 (API 23)，推荐 9.0+；建议 1GB+ RAM，支持硬件解码
- **开发**：Flutter SDK ≥ 3.10，Dart ≥ 3.10

---

## 🛠️ 开发与构建

```bash
# 1. 安装依赖
cd app && flutter pub get

# 2. 生成代码（Isar 模型、Riverpod Provider）
flutter pub run build_runner build --delete-conflicting-outputs

# 3. 运行应用
flutter run

# 4. 构建 Release APK
flutter build apk --release

# 5. 代码分析
flutter analyze
```

---

## 📜 开源协议 (MIT)

MIT License

Copyright (c) 2026 sjgtv contributors

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
- [laopaoer-wallet/DTV](https://github.com/laopaoer-wallet/DTV)（本项目的提议与参考来源）
- [MediaKit 文档](https://github.com/media-kit/media-kit)
- [Riverpod 文档](https://riverpod.dev/)
- [Isar 文档](https://isar.dev/)

---

## 🙏 鸣谢

感谢 [DTV](https://github.com/laopaoer-wallet/DTV) 作者（laopaoer）提议重写新项目并授权参考原实现，本仓库在此基础上独立演进。

---

> ✨ 欢迎贡献：请提交 PR 到 `dev` 分支。
> 🐞 问题反馈：提交 Issue