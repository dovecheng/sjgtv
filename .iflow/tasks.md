# sjgtv 任务列表

## 已完成（2026-02-09）

### Base 包重构

- [x] 架构层代码迁移
  - [x] 将错误处理（failures、result）从 app 迁移到 base
  - [x] 将 Use Case 模式从 app 迁移到 base
  - [x] 将焦点管理工具从 app 迁移到 base

- [x] 模块化导出结构
  - [x] 创建三层导出结构（base.dart → 模块导出 → 子模块导出）
  - [x] 修复所有悬挂文档注释警告
  - [x] 修复实现导入警告

- [x] 代码质量验证
  - [x] 运行 flutter analyze，无警告
  - [x] 所有导入路径更新为 `package:base/base.dart`

## 待完成

### Base 包扩展（参考 ytv）

- [x] 扩展 Failure 类型
  - [x] 添加 `TimeoutFailure` - 超时失败
  - [x] 添加 `UnauthorizedFailure` - 未授权失败
  - [x] 添加 `ForbiddenFailure` - 禁止访问失败
  - [x] 添加 `NotFoundFailure` - 未找到失败
  - [x] 添加 `ValidationFailure` - 验证失败

- [x] 改进 Result 类型
  - [x] 添加 `fold()` 方法 - 模式匹配
  - [x] 添加 `when()` 方法 - 副作用处理

- [x] YouTube TV 风格主题
  - [x] 迁移 `ytv/lib/core/theme/app_theme.dart` 到 base
  - [x] 创建 `base/lib/src/theme/` 目录
  - [x] 配置完整的 Material 3 主题
  - [x] 焦点颜色、动画等 TV 优化

- [x] YouTube TV 风格组件
  - [x] `YouTubeTVCards` - 焦点缩放、边框高亮（已在 app 包中实现）
  - [x] `YouTubeTVCategories` - 横向滚动分类导航（已在 app 包中实现）
  - [x] `YouTubeTVGrid` - 响应式网格布局（已在 app 包中实现）
  - [x] `YouTubeTVRow` - 横向滚动的视频行（已在 app 包中实现）

- [x] go_router 配置
  - [x] 迁移 go_router 配置模式（已存在完整配置）
  - [x] 自定义页面过渡动画（已实现）
  - [x] 完整的路由嵌套结构（已实现）
  - [x] 错误页面处理（go_router 内置）

- [x] 常量定义
  - [x] 迁移 `ytv/lib/core/constants/app_constants.dart`（已存在）
  - [x] 添加网络超时常量
  - [x] UI 相关（焦点缩放、边框宽度）
  - [x] 布局、动画、播放器等常量

### App 包优化

- [x] Use Case 改进
  - [x] 参考 ytv 的 Use Case 实现方式
  - [x] 添加 `SimpleUseCase` 简化基类

- [x] 焦点系统
  - [x] 集成 YouTube TV 风格的焦点组件（已实现）
  - [x] 优化焦点导航体验（已实现）

- [x] 主题应用
  - [x] 应用 YouTube TV 风格主题
  - [x] 统一设计语言

## 多平台适配（2026-02-10）

- [x] 设备检测模块
  - [x] 创建 DeviceType 枚举（phone, tablet, tv, desktop）
  - [x] 创建 ScreenOrientation 枚举（portrait, landscape）
  - [x] 创建 InputMethod 枚举（remote, touch, keyboard, mouse）
  - [x] 添加 Web 平台支持（kIsWeb 检测）

- [x] 响应式布局系统
  - [x] 创建 LayoutBreakpoints（定义布局断点）
  - [x] 创建 ResponsiveLayout（响应式布局组件）
  - [x] 创建 ResponsiveGrid（响应式网格系统）
  - [x] 根据 TV/平板/手机自动调整网格列数（2-6列）
  - [x] 自动调整卡片宽高比（16:9 或 2:3）

- [x] 导航适配器
  - [x] 创建 AdaptiveNavigationBar（自适应导航栏）
  - [x] TV 使用顶部导航（遥控器操作）
  - [x] 手机/平板使用顶部导航（触摸操作）
  - [x] 创建 FocusManager（焦点管理器）

- [x] 全屏管理器
  - [x] 创建 FullScreenManager（全屏管理）
  - [x] TV 自动进入全屏模式
  - [x] 手机/平板保持窗口模式

- [x] 组件适配
  - [x] 适配电影卡片组件（支持多种布局）
  - [x] 适配 Hero Banner 组件
  - [x] 适配所有页面（首页、搜索、详情、设置）

- [x] 多平台测试
  - [x] TV 设备测试（HK1 RBOX K8）
  - [x] 平板设备测试（Samsung Tab A8 - 横屏+竖屏）
  - [x] 手机设备测试（Pixel 模拟器）
  - [x] 生成测试报告和截图

## 代码质量优化（2026-02-10）

- [x] 包路径重构
  - [x] 将所有相对路径改为包路径（package:sjgtv/）
  - [x] 涉及 50+ 个文件
  - [x] 所有层次：di, data, domain, core, src

- [x] 代码警告修复
  - [x] 修复不必要的下划线使用（3 处）
  - [x] 修复弃用的 withOpacity API（7 处）
  - [x] 修复弃用的 Radio API（4 处）
  - [x] 从 14 个警告减少到 0 个

- [x] MediaQuery 访问错误修复
  - [x] category_page.dart：将 TVModeConfig.init 移到 didChangeDependencies
  - [x] search_page.dart：同样处理

- [x] 布局溢出问题修复
  - [x] 使用 Stack 布局代替 Column
  - [x] 信息区域覆盖在图片底部，不增加总高度

- [x] 源管理页面布局优化
  - [x] 增加操作按钮间距（8px）
  - [x] 增加 Card margin（12px → 16px）
  - [x] 优化 URL 显示（字体 14px → 13px）
  - [x] 统一按钮垂直对齐

- [x] 首页双击返回退出功能
  - [x] 添加 PopScope 包装 Scaffold
  - [x] 记录上次返回键时间
  - [x] 2 秒内再次按返回键才退出应用
  - [x] 首次按返回键显示提示信息

## 工具和脚本（2026-02-10）

- [x] 项目检查命令
  - [x] 创建 .iflow/commands/check.md
  - [x] 13 个检查项（代码错误、警告、格式、国际化、测试等）
  - [x] 快速检查和完整检查命令

- [x] 文件索引工具
  - [x] 创建 generate_file_index.py（生成 JSON 索引）
  - [x] 创建 query_file_index.sh（查询工具）
  - [x] 索引 207 个 Dart 文件
  - [x] 按类型和模块分类

- [x] 文档更新
  - [x] 更新 README.md
  - [x] 创建多平台适配方案文档
  - [x] 创建设备测试计划
  - [x] 创建多平台测试报告
  - [x] 创建会话总结

## 改进建议（2026-02-09）

基于对 YTV 和 SJGTV 项目的对比分析，以下是对 SJGTV 项目的改进建议：

### 1. 测试覆盖提升

- [ ] 增加单元测试
  - [x] 为 Use Cases 添加单元测试（SearchMoviesUseCase、GetSourcesUseCase 等）- 已完成 63 个测试用例
  - [ ] 为 Providers 添加测试（SourcesProvider、ProxiesProvider 等）
  - [ ] 为工具类添加测试（FocusHelper、JSONConverter 等）

- [ ] 增加集成测试
  - [ ] 测试 Shelf API 端点
  - [ ] 测试 Isar 数据库操作
  - [ ] 测试远程配置加载

- [ ] 增加 Widget 测试
  - [x] 测试 YouTubeTVMovieCard 组件 - 已完成 AppUpdater 测试
  - [ ] 测试 YouTubeTVCategoryBar 组件
  - [ ] 测试焦点管理功能

### 2. 错误处理改进
- [x] 添加重试逻辑
  - [x] 为远程配置加载添加指数退避重试
  - [x] 为 API 请求添加自动重试机制（RetryInterceptor）
  - [x] 为网络超时添加友好的用户提示（国际化文本）

- [x] 实现离线模式
  - [ ] 使用缓存数据作为降级方案
  - [x] 添加网络状态监听（NetworkStatus）
  - [ ] 离线时显示本地数据并标记为"已缓存"

- [ ] 改进错误提示
  - [ ] 统一错误消息格式
  - [ ] 添加用户友好的错误说明
  - [ ] 提供错误恢复建议

### 3. 性能优化

- [x] 实现懒加载

  - [x] 电影列表分页加载（_moviesPerPage = 20）

  - [x] 图片懒加载和预加载（cached_network_image）

  - [ ] 视频元数据按需加载



- [x] 优化数据库查询

  - [x] 为常用查询添加索引（@Index() 注解）

  - [ ] 优化 Isar 查询性能

  - [ ] 减少不必要的数据库访问



- [x] 图片优化

  - [x] 使用 cached_network_image 的缓存策略

  - [ ] 添加图片压缩和格式转换

  - [ ] 实现图片预加载队列



### 4. 安全增强



- [x] URL 验证

  - [x] 验证所有外部 URL 格式

  - [x] 检查 URL 协议（仅允许 http/https）

  - [x] 添加 URL 黑名单机制



- [x] 输入清理

  - [x] 清理用户输入的搜索关键词

  - [x] 防止 XSS 攻击

  - [x] 验证 JSON 数据结构



- [ ] HTTPS 证书锁定（生产环境）

  - [ ] 实现证书固定

  - [x] 添加证书验证（badCertificateCallback）

  - [ ] 防止中间人攻击

### 5. 文档完善

- [ ] 架构决策记录（ADR）
  - [ ] 记录为什么选择 Isar 而不是其他数据库
  - [ ] 记录为什么使用 Riverpod 代码生成
  - [ ] 记录模块化架构的设计决策

- [ ] 开发者文档
  - [ ] 添加电视遥控器按键映射说明
  - [ ] 创建开发者入门指南
  - [ ] 记录环境配置步骤

- [ ] API 文档
  - [ ] 为 Shelf API 端点添加文档
  - [ ] 为公开的 Use Cases 添加使用示例
  - [ ] 记录数据模型的结构说明

### 6. 功能完善

- [x] 设置页面实现
  - [x] 完成设置页面的功能开发
  - [x] 添加播放设置（默认音量、播放速度）
  - [x] 添加显示设置（主题、语言）

- [x] 播放历史
  - [x] 记录观看历史
  - [x] 提供历史记录查看
  - [x] 支持清除历史记录

- [x] 收藏功能
  - [x] 添加电影收藏功能
  - [x] 收藏列表管理
  - [ ] 收藏同步到云端（可选）

- [ ] 字幕支持
  - [ ] 添加字幕文件加载
  - [ ] 字幕格式解析（srt、vtt）
  - [ ] 字幕样式和位置调整

### 7. 从 YTV 学习借鉴

- [ ] Clean Architecture 实践
  - [ ] 评估是否需要更严格的三层分离
  - [ ] 考虑将 Use Cases 独立为更清晰的领域层
  - [ ] 参考其依赖注入模式

- [ ] Result 模式优化
  - [ ] 借鉴 YTV 的 Result 实现细节
  - [ ] 确保错误处理的类型安全
  - [ ] 优化 fold 和 when 方法的使用

- [ ] 焦点系统改进
  - [ ] 参考 YTV 的焦点动画设计
  - [ ] 优化焦点管理的性能
  - [ ] 改进网格内焦点移动逻辑

### 优先级建议

**高优先级：**
1. 测试覆盖提升（单元测试、集成测试）
2. 错误处理改进（重试逻辑、离线模式）
3. 功能完善（设置页面、播放历史）

**中优先级：**
4. 性能优化（懒加载、数据库优化）
5. 安全增强（URL 验证、输入清理）

**低优先级：**
6. 文档完善
7. 从 YTV 学习借鉴（架构调整）