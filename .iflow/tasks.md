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