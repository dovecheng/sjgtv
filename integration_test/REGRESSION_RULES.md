# 集成测试回归规则（最高标准）

## 1. 分阶段准入门槛
- P0（主链路）进入 P1 前：同设备连续 3 轮通过率 >= 95%。
- P1（核心业务）进入 P2 前：关键断言完整、失败率 < 5%。
- P2（异常韧性）完成后：形成全量回归集，按发布节奏执行。

## 2. 断言规范
- 每条用例必须包含：前置条件、用户动作、可观测业务断言。
- 禁止仅靠日志判断通过，必须有 `expect(...)`。
- 搜索/网络类用例允许“多态断言”，但必须限制在可接受状态集合内。

## 3. 等待与重试策略
- 默认使用短轮询（200~500ms）+ 明确超时（8~20s）。
- 避免超长 `pumpAndSettle`。
- 页面加载失败时，优先断言错误态文案，而不是无限等待。

## 4. Flaky 判定与处理
- 同一用例 10 轮中失败 >= 2 次定义为 flaky。
- flaky 必须记录：失败步骤、截图/日志、复现条件、修复动作。
- flaky 未关闭前，不允许作为发布阻断条件。

## 5. 执行命令
- 单文件调试：`flutter test integration_test/p0_core_flow_test.dart --reporter expanded`
- P0 稳定性：`bash script/run_p0_stability.sh 3`
- 全量回归：`flutter test integration_test --reporter expanded`

## 6. TV 慢网提速规范（默认）
- 默认入口：`bash script/run_it_tv.sh quick --device 192.168.145.55:5555`。
- 全量入口：`bash script/run_it_tv.sh full --device 192.168.145.55:5555`。
- 默认禁止连续 `--name` 拆分执行；仅在失败定位时允许：
  - `bash script/run_it_tv.sh quick --allow-name --name "<用例名>" --device 192.168.145.55:5555`
- 在 VSCode 中优先使用任务：
  - `it: tv quick`
  - `it: tv full`
- 若日志出现 `google_fonts` 握手失败等网络异常，归类为环境失败，不计入业务回归失败；需要严格失败时加 `--strict-env`。

## 7. CI 建议
- PR 阶段至少执行 P0 集合。
- 合并前执行全量 integration_test。
- 失败自动重跑 1 次，若仍失败则标记不通过并附失败用例清单。
