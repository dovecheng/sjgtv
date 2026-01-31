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

**未完成的计划**
- [ ] 源管理：做「删除/编辑源」功能（列表项操作、编辑页、与 shelf API 对接）
- [ ] 代理/标签：按现有源管理模式，补代理管理、标签管理页面与 API
- [ ] TV 与播放：继续优化 TV 焦点、遥控、播放器 UI/交互
- [ ] 代码质量：再跑一遍 `dart analyze` / `dart fix`，查未使用导入与死代码
- [ ] 重新分析项目：若用户说「要分析」，则对项目做分析并整理、更新摘要

**涉及/修改的文件**
- 新增：`.cursor/summaries/recoding3.md`

## 历史

### 2026-01-31 21:32
- 创建 recoding3，将会话中 ok 收尾给出的「可选下一步」记录为未完成计划（5 条待办）

### 2026-01-31 21:32（补充引用）
- 新增「引用摘要」小节，引用 [recoding2](.cursor/summaries/recoding2.md)，便于再次会话时先读旧摘要以延续上下文

### 2026-01-31 21:32（一二三摘要关联）
- 确保 recoding1、recoding2、recoding3 相互关联：recoding1 增加「引用摘要/后续摘要」指向 recoding2 与 recoding3；recoding2 增加「引用摘要」指向 recoding1、「后续摘要」指向 recoding3；recoding3 在引用摘要中补充 recoding1，并增加「后续摘要」说明本摘要为当前最新
