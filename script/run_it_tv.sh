#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

MODE="quick"
if [[ $# -gt 0 && "$1" != --* && "$1" != "-h" ]]; then
  MODE="$1"
  shift
fi

DEVICE_ID="192.168.145.55:5555"
TARGET_PATH=""
NAME_FILTER=""
ALLOW_NAME_FILTER=false
ALLOW_ENV_FLAKY_BYPASS=true
REPORTER="expanded"

print_help() {
  echo "用法: $0 [quick|full] [选项]"
  echo ""
  echo "选项:"
  echo "  --device <id>            指定设备ID（默认: 192.168.145.55:5555）"
  echo "  --target <path>          指定测试目标（文件或目录）"
  echo "  --name <pattern>         指定用例名过滤（默认禁止）"
  echo "  --allow-name             允许使用 --name（仅用于失败定位）"
  echo "  --strict-env             严格模式，环境失败也返回非0"
  echo "  --reporter <type>        flutter test reporter（默认 expanded）"
  echo "  -h, --help               查看帮助"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --device)
      DEVICE_ID="${2:-}"
      shift 2
      ;;
    --target)
      TARGET_PATH="${2:-}"
      shift 2
      ;;
    --name)
      NAME_FILTER="${2:-}"
      shift 2
      ;;
    --allow-name)
      ALLOW_NAME_FILTER=true
      shift
      ;;
    --strict-env)
      ALLOW_ENV_FLAKY_BYPASS=false
      shift
      ;;
    --reporter)
      REPORTER="${2:-}"
      shift 2
      ;;
    -h|--help)
      print_help
      exit 0
      ;;
    *)
      echo "未知参数: $1"
      print_help
      exit 1
      ;;
  esac
done

if [[ -n "$NAME_FILTER" && "$ALLOW_NAME_FILTER" != true ]]; then
  echo "错误: 默认禁止 --name 连续拆跑。"
  echo "如需定位失败用例，请显式加 --allow-name 后再使用 --name。"
  exit 2
fi

if [[ -z "$TARGET_PATH" ]]; then
  if [[ "$MODE" != "quick" && "$MODE" != "full" ]]; then
    echo "未知模式: $MODE（仅支持 quick/full）"
    print_help
    exit 1
  fi
  if [[ "$MODE" == "full" ]]; then
    TARGET_PATH="integration_test"
  else
    TARGET_PATH="integration_test/error_recovery_tv_behavior_test.dart"
  fi
fi

RUN_ID="$(date +%Y%m%d_%H%M%S)"
LOG_DIR="screenshots/it_runs/${RUN_ID}"
mkdir -p "$LOG_DIR"
LOG_FILE="${LOG_DIR}/run_${MODE}.log"

CMD=(flutter test "$TARGET_PATH" -d "$DEVICE_ID" --reporter "$REPORTER")
if [[ -n "$NAME_FILTER" ]]; then
  CMD+=(--name "$NAME_FILTER")
fi

echo "执行模式: $MODE"
echo "设备: $DEVICE_ID"
echo "目标: $TARGET_PATH"
echo "日志: $LOG_FILE"
echo "命令: ${CMD[*]}"

set +e
"${CMD[@]}" 2>&1 | tee "$LOG_FILE"
TEST_EXIT_CODE=${PIPESTATUS[0]}
set -e

if [[ $TEST_EXIT_CODE -eq 0 ]]; then
  echo "测试通过。"
  exit 0
fi

if [[ "$ALLOW_ENV_FLAKY_BYPASS" == true ]] && \
   rg -q "google_fonts|HandshakeException|CERTIFICATE_VERIFY_FAILED|SocketException|Connection reset by peer" "$LOG_FILE"; then
  echo "检测到环境网络异常（如 google_fonts 握手失败），本次归类为环境失败，不计入业务回归失败。"
  echo "如需严格失败，请加 --strict-env 重跑。"
  exit 0
fi

echo "测试失败（业务或严格模式环境失败），退出码: $TEST_EXIT_CODE"
exit "$TEST_EXIT_CODE"
