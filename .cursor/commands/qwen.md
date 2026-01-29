# qwen

在 Cursor 中通过终端调用 Qwen Code 无头模式。参考：[无头模式文档](https://qwenlm.github.io/qwen-code-docs/zh/users/features/headless/)

## qwen 路径（Agent 用）

Agent 执行命令时用的是**非交互式 shell**，不会自动读 `~/.bashrc`，PATH 里没有你在 .bashrc 里配的 qwen。因此 Agent 调用时请用**完整路径**或先加载环境：

- **完整路径**：`$HOME/.npm-global/bin/qwen`（与 .bashrc 里 `NPM_GLOBAL_BIN` 一致）
- **或先加载再执行**：`source ~/.bashrc && echo "整段内容" | qwen`
- **工作目录**：Agent 执行时请将 Shell 的 **working_directory** 设为**当前编辑器所在目录**或**项目根目录**（Cursor 工作区根目录），以便 qwen 能正确访问项目文件。

## 用法

- **无输入**：在终端执行 `qwen`，进入交互式对话。
- **有输入**：**推荐用 `echo "整段内容" | qwen`**，避免 Cursor 把一句话拆成多行；Agent 执行时也应优先采用此方式。
- **Agent 执行 qwen 时**：Shell 未传 timeout 时默认约 30 秒即超时，需传 **timeout=600000**（10 分钟）；代发提示时可在末尾加「请在 10 分钟内完成回答」，让 qwen 控制节奏。
- 若内容很长或多行，可用：`echo "第一行\n第二行\n更多..." | qwen` 或把内容写进文件后 `cat 文件 | qwen`。

## 常用无头选项

| 选项 | 说明 |
|------|------|
| `-p`, `--prompt` | 直接传入提示，无头运行 |
| `-o`, `--output-format` | 输出格式：`text`（默认）、`json`、`stream-json` |
| `-a`, `--all-files` | 在上下文中包含当前项目所有文件 |
| `--include-directories` | 额外包含目录，如 `--include-directories base,lib` |
| `-y`, `--yolo` | 自动批准所有操作（脚本/自动化时使用） |
| `--continue` | 恢复当前项目最近会话后再执行新提示 |
| `--resume <sessionId>` | 恢复指定会话后执行新提示 |

## 示例

```bash
# 推荐：echo 传参，避免 Cursor 把一句话变成多行
echo "解释这段代码" | qwen
echo "分析我的项目" | qwen

# 直接 -p（在 Cursor 里易被拆行，适合本地终端）
qwen -p "什么是机器学习？"

# 结合文件内容
cat README.md | qwen -p "总结这份文档"

# 输出为 JSON（便于脚本处理）
qwen -p "法国的首都是什么？" --output-format json

# 保存到文件
qwen -p "解释 Docker" > docker-explanation.txt
```

## 注意

- **为什么 Agent 找不到 qwen**：Agent 的 Shell 是非交互式的，默认不 source `~/.bashrc`，所以 .bashrc 里的 PATH 不生效。Agent 请用上面「qwen 路径」里的完整路径，或 `source ~/.bashrc && ...` 再执行。
- **Cursor 易把一句话拆成多行**：在 Cursor 里触发 qwen 时，优先用 `echo "整段内容" | qwen`，不要依赖 `-p` 传长句。
- **执行 qwen 时的超时**：Agent 调用 Shell 执行 qwen 时必须传 **timeout=600000**（10 分钟），否则 Shell 默认 30 秒就超时；提示 qwen 在 10 分钟内完成回答。
- 交互式运行（仅执行 `qwen`）需在真实 TTY 终端中进行。
