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

## 改进建议（2026-02-09）

基于对 YTV 和 SJGTV 项目的对比分析，以下是对 SJGTV 项目的改进建议：

### 1. 测试覆盖提升

- [ ] 增加单元测试
  - [ ] 为 Use Cases 添加单元测试（SearchMoviesUseCase、GetSourcesUseCase 等）
  - [ ] 为 Providers 添加测试（SourcesProvider、ProxiesProvider 等）
  - [ ] 为工具类添加测试（FocusHelper、JSONConverter 等）

- [ ] 增加集成测试
  - [ ] 测试 Shelf API 端点
  - [ ] 测试 Isar 数据库操作
  - [ ] 测试远程配置加载

- [ ] 增加 Widget 测试
  - [ ] 测试 YouTubeTVMovieCard 组件
  - [ ] 测试 YouTubeTVCategoryBar 组件
  - [ ] 测试焦点管理功能

### 2. 错误处理改进

- [ ] 添加重试逻辑
  - [ ] 为远程配置加载添加指数退避重试
  - [ ] 为 API 请求添加自动重试机制
  - [ ] 为网络超时添加友好的用户提示

- [ ] 实现离线模式
  - [ ] 使用缓存数据作为降级方案
  - [ ] 添加网络状态监听
  - [ ] 离线时显示本地数据并标记为"已缓存"

- [ ] 改进错误提示
  - [ ] 统一错误消息格式
  - [ ] 添加用户友好的错误说明
  - [ ] 提供错误恢复建议

### 3. 性能优化

- [ ] 实现懒加载
  - [ ] 电影列表分页加载
  - [ ] 图片懒加载和预加载
  - [ ] 视频元数据按需加载

- [ ] 优化数据库查询
  - [ ] 为常用查询添加索引
  - [ ] 优化 Isar 查询性能
  - [ ] 减少不必要的数据库访问

- [ ] 图片优化
  - [ ] 使用 cached_network_image 的缓存策略
  - [ ] 添加图片压缩和格式转换
  - [ ] 实现图片预加载队列

### 4. 安全增强

- [ ] URL 验证
  - [ ] 验证所有外部 URL 格式
  - [ ] 检查 URL 协议（仅允许 http/https）
  - [ ] 添加 URL 黑名单机制

- [ ] 输入清理
  - [ ] 清理用户输入的搜索关键词
  - [ ] 防止 XSS 攻击
  - [ ] 验证 JSON 数据结构

- [ ] HTTPS 证书锁定（生产环境）
  - [ ] 实现证书固定
  - [ ] 添加证书验证
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

- [ ] 设置页面实现
  - [ ] 完成设置页面的功能开发
  - [ ] 添加播放设置（默认音量、播放速度）
  - [ ] 添加显示设置（主题、语言）

- [ ] 播放历史
  - [ ] 记录观看历史
  - [ ] 提供历史记录查看
  - [ ] 支持清除历史记录

- [ ] 收藏功能
  - [ ] 添加电影收藏功能
  - [ ] 收藏列表管理
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