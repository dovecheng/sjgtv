# gemini

在 Cursor 中通过终端调用 Gemini CLI 无头模式。参考：[Headless mode](https://geminicli.com/docs/cli/headless/)

## gemini 路径（Agent 用）

Agent 执行命令时用的是**非交互式 shell**，不会自动读 `~/.bashrc`，PATH 里没有你在 .bashrc 里配的 gemini。因此 Agent 调用时请用**完整路径**或先加载环境：

- **完整路径**：`$HOME/.npm-global/bin/gemini`（与 .bashrc 里 `GEMINI_PATH`/`NPM_GLOBAL_BIN` 一致）
- **或先加载再执行**：`source ~/.bashrc && echo "整段内容" | gemini`
- **工作目录**：Agent 执行时请将 Shell 的 **working_directory** 设为**当前编辑器所在目录**或**项目根目录**（Cursor 工作区根目录），以便 gemini 能正确访问项目文件。

## 用法

- **直接提示**：用 `-p`/`--prompt` 传入问题，无头运行。
- **stdin 输入**：**推荐用 `echo "整段内容" | gemini`**，避免 Cursor 把一句话拆成多行；Agent 执行时也应优先采用此方式。
- **结合文件**：`cat README.md | gemini -p "总结这份文档"`。
- **Agent 执行 gemini 时**：Shell 未传 timeout 时默认约 30 秒即超时，需传 **timeout=600000**（10 分钟）；代发提示时可在末尾加「请在 10 分钟内完成回答」。

## 常用无头选项

| 选项 | 说明 |
|------|------|
| `-p`, `--prompt` | 直接传入提示，无头运行 |
| `--output-format` | 输出格式：`text`（默认）、`json`、`stream-json` |
| `-m`, `--model` | 指定模型，如 `gemini-2.5-flash` |
| `-y`, `--yolo` | 自动批准所有操作（脚本/自动化时使用） |
| `--approval-mode` | 批准模式，如 `auto_edit` |
| `--include-directories` | 额外包含目录，如 `--include-directories src,docs` |
| `-d`, `--debug` | 开启调试 |

## 输出格式

- **text**（默认）：人类可读文本。
- **json**：结构化数据，含 `response`、`stats`（模型/工具/文件统计）、`error`，便于脚本处理。
- **stream-json**：实时 JSONL 事件流（`init`、`message`、`tool_use`、`tool_result`、`error`、`result`），适合监控长任务或做流水线。

## 示例

```bash
# 直接 -p
gemini -p "法国的首都是什么？"

# 推荐：echo 传参，避免 Cursor 拆行
echo "解释这段代码" | gemini
echo "分析我的项目" | gemini

# 结合文件
cat README.md | gemini -p "总结这份文档"

# 输出为 JSON（便于脚本处理）
gemini -p "法国的首都是什么？" --output-format json
echo "$result" | jq -r '.response'

# 保存到文件
gemini -p "解释 Docker" > docker-explanation.txt
gemini -p "解释 Docker" --output-format json > docker-explanation.json

# 流式 JSON（监控/流水线）
gemini --output-format stream-json -p "分析这段代码" | jq -r '.type'
```

## 注意

- **为什么 Agent 找不到 gemini**：Agent 的 Shell 是非交互式的，默认不 source `~/.bashrc`，所以 .bashrc 里的 PATH 不生效。Agent 请用上面「gemini 路径」里的完整路径，或 `source ~/.bashrc && ...` 再执行。
- **Cursor 易把一句话拆成多行**：在 Cursor 里触发 gemini 时，优先用 `echo "整段内容" | gemini`，不要依赖 `-p` 传长句。
- **执行 gemini 时的超时**：Agent 调用 Shell 执行 gemini 时必须传 **timeout=600000**（10 分钟），否则 Shell 默认 30 秒就超时。
- 需已安装并配置好 [Gemini CLI](https://geminicli.com/docs/cli/headless/)（含认证）。
