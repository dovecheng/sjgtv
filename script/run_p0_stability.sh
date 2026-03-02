#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

TOTAL_ROUNDS="${1:-3}"
DEVICE_ID="${2:-192.168.145.55:5555}"
TARGET_PATH="${3:-integration_test/p0_core_flow_test.dart}"
PASS_COUNT=0

echo "开始执行 P0 稳定性验证，共 ${TOTAL_ROUNDS} 轮"
echo "设备: ${DEVICE_ID}"
echo "目标: ${TARGET_PATH}"

for ((i=1; i<=TOTAL_ROUNDS; i++)); do
  echo "----------------------------------------"
  echo "第 ${i} 轮：${TARGET_PATH}"
  if bash script/run_it_tv.sh quick --device "${DEVICE_ID}" --target "${TARGET_PATH}"; then
    PASS_COUNT=$((PASS_COUNT + 1))
    echo "第 ${i} 轮通过"
  else
    echo "第 ${i} 轮失败"
  fi
done

echo "----------------------------------------"
echo "稳定性结果：${PASS_COUNT}/${TOTAL_ROUNDS} 轮通过"

if [[ "$PASS_COUNT" -lt "$TOTAL_ROUNDS" ]]; then
  echo "未达到 100% 轮次通过，请检查 flaky 用例"
  exit 1
fi

echo "P0 稳定性验证通过"
