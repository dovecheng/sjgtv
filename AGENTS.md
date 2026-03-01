1:# AGENTS.md - SJGTV 开发指南
2:
3:本文档为 AI Agent 提供开发规范和命令参考。
4:
5:---
6:
7:## 1. 快速命令
8:
9:### 构建与运行
10:```bash
11:# 运行应用（默认调试模式）
12:flutter run
13:
14:# 构建 APK
15:flutter build apk --debug
16:flutter build apk --release
17:
18:# 构建 Web
19:flutter build web --release
20:```
21:
22:### 代码分析
23:```bash
24:# 分析代码（推荐每次修改后运行）
25:flutter analyze
26:
27:# 修复代码风格问题
28:dart fix --apply
29:
30:# 检查代码格式
31:dart format --set-exit-if-changed .
32:```
33:
34:### 测试
35:```bash
36:# 运行所有测试
37:flutter test
38:
39:# 运行单个测试文件
40:flutter test test/domain/usecases/add_source_usecase_test.dart
41:
42:# 运行单个测试用例（按名称过滤）
43:flutter test --name "AddSourceUseCase 应该成功添加视频源"
44:
45:# 运行测试并显示详细输出
46:flutter test --reporter expanded
47:
48:# 运行测试并生成覆盖率报告
49:flutter test --coverage
50:```
51:
52:### 代码生成
53:```bash
54:# 运行 build_runner（当修改了需要生成的代码时）
55:dart run build_runner build --delete-conflicting-outputs
56:
57:# 重新生成 Riverpod Provider
58:dart run riverpod_generator build
59:
60:# 重新生成国际化
61:flutter gen-l10n
62:```
63:
64:### 其他
65:```bash
66:# 获取依赖
67:flutter pub get
68:
69:# 更新依赖（检查新版本）
70:flutter pub outdated
71:
72:# 清理并重新构建
73:flutter clean && flutter pub get
74:```
75:
76:---
77:
78:## 2. 代码规范
79:
80:### 语言要求（来自 .cursorrules）
81:- **必须使用简体中文**回复：对话、解释、错误提示、总结
82:- Git 提交消息必须使用中文
83:- 代码注释必须使用中文
84:
85:### 类型声明（强制）
86:- 所有变量、方法参数、返回值、类字段**必须显式声明类型**
87:- 示例：
88:  ```dart
89:  // ✅ 正确
90:  final String name;
91:  Future<void> fetchData() async { ... }
92:  void onTap(BuildContext context) { ... }
93:  
94:  // ❌ 错误
95:  final name = 'test';
96:  fetchData() async { ... }
97:  onTap(context) { ... }
98:  ```
99:
100:### const 使用
101:- 能加 `const` 的地方尽量加
102:- Widget 依赖运行时数据时不能使用 `const`
103:
104:### 导入规范
105:- 使用包路径 `package:sjgtv/...` 而非相对路径
106:- 导入顺序：dart → package → relative
107:- 示例：
108:  ```dart
109:  import 'dart:io';
110:  import 'package:flutter/material.dart';
111:  import 'package:flutter_riverpod/flutter_riverpod.dart';
112:  import 'package:sjgtv/core/core.dart';
113:  import 'package:sjgtv/src/movie/model/movie_model.dart';
114:  ```
115:
116:### 命名规范
117:- 类名：`UpperCamelCase`（如 `MovieDetailPage`）
118:- 方法/变量：`lowerCamelCase`（如 `movieList`）
119:- 常量：`kCamelCase`（如 `kDefaultPageSize`）
120:- 文件名：`snake_case.dart`（如 `movie_detail_page.dart`）
121:
122:### 注释规范
123:- 使用中文注释
124:- 只写必要注释：复杂逻辑、非显而易见细节、重要业务规则
125:- 禁止：修改原因、重复代码含义、解释修改过程
126:
127:### 错误处理
128:- 使用 `Result` 类型封装业务逻辑返回值
129:- 使用 `try-catch` 捕获异常并记录日志
130:- 示例：
131:  ```dart
132:  final Result<Movie> result = await _repository.getMovie(id);
133:  return result.fold(
134:    onSuccess: (movie) => Success(movie),
135:    onFailure: (failure) => Failure(failure.message),
136:  );
137:  ```
138:
139:---
140:
141:## 3. 项目架构
142:
143:### 目录结构
144:```
145:lib/
146:├── core/           # 公共工具和扩展
147:├── data/           # 数据层（Repository 实现）
148:├── di/             # 依赖注入
149:├── domain/         # 领域层（Use Case、Entity）
150:├── gen/            # 生成的文件（勿手动修改）
151:├── l10n_arb/       # 国际化 ARB 源文件
152:├── l10n_gen/       # 生成的国际化代码
153:├── src/            # 应用代码
154:│   ├── app/        # 应用级（配置、路由、主题）
155:│   ├── source/     # 视频源管理
156:│   ├── movie/      # 电影业务
157:│   ├── favorite/   # 收藏功能
158:│   ├── watch_history/ # 观看历史
159:│   ├── settings/   # 设置页面
160:│   ├── proxy/      # 代理管理
161:│   ├── tag/        # 标签管理
162:│   └── shelf/      # 本地 HTTP 服务
163:└── main.dart       # 应用入口
164:```
165:
166:### 模块分层
167:- **page/** - UI 页面
168:- **provider/** - Riverpod 状态管理
169:- **model/** - 数据模型
170:- **service/** - 业务服务
171:- **widget/** - 可复用组件
172:- **l10n/** - 国际化文本
173:
174:### Riverpod 使用
175:- 使用 `@riverpod` 注解 + `riverpod_generator` 生成代码
176:- 手写 Provider 时使用 `StateNotifierProvider` 或 `FutureProvider`
177:
178:---
179:
180:## 4. 注意事项
181:
182:### 不主动使用代码生成器
183:除非用户明确要求，否则不主动使用：
184:- Freezed
185:- Retrofit（手写 Dio 请求）
186:- json_serializable（手写 model）
187:- riverpod_generator（如需可询问用户）
188:- flutter_gen_runner
189:
190:### 需求审查
191:- 执行前评估需求合理性、方案风险、替代方案
192:- 发现问题时先停止执行并指正问题
193:- 不盲目执行用户方案，主动评估是否有更好方案
194:
195:### 完成后必做
196:1. 运行 `flutter analyze` 确保无警告
197:2. 运行 `flutter test` 确保测试通过
198:3. 确认用户是否需要执行代码生成
199:
200:---
201:
209:## 6. 规划待办（功能增强）
210:
211:### 功能类
212:- [ ] 字幕支持（srt/vtt 解析、样式调整）
213:- [ ] Flutter 代理/标签管理页（网页已有）
214:- [ ] 离线缓存降级
215:- [ ] 收藏云端同步
216:
217:### 体验优化
218:- [ ] TV 播放体验优化
219:- [ ] 首页布局（卡片间距、焦点指示器）
220:- [ ] 搜索功能优化
221:- [ ] 广告过滤完善
222:
223:### 质量类
224:- [ ] 更多测试（Providers、集成测试）
225:- [ ] HTTPS 证书锁定（生产环境）
226:- [ ] 主线程阻塞优化
227:
228:### 可选/低优先
229:- [ ] base viewer 模块精简
230:- [ ] Isar 换 Hive/SP
231:
232:---
233:
234:## 7. 相关文件
235:
236:- `.cursorrules` - Cursor AI 规则配置
237:- `analysis_options.yaml` - Dart 分析器配置
238:- `pubspec.yaml` - 项目依赖配置
