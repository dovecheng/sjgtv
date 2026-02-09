#!/bin/bash
# 综合项目检查脚本
# 
# 功能：
# - 检查代码错误和警告
# - 检查国际化声明
# - 检查测试用例更新
# - 检查引用关系
# - 检查代码格式
# - 检查依赖更新
# - 根据修改的文件智能跳过无关检查
#
# 用法: script/check_project.sh [选项]
#   --all          执行所有检查
#   --quick        快速检查（仅代码分析）
#   --modified     仅检查修改的文件
#   --no-build     跳过构建测试

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
CHECK_ALL=false
CHECK_QUICK=false
CHECK_MODIFIED_ONLY=false
SKIP_BUILD=false

# 解析参数
while [[ $# -gt 0 ]]; do
  case $1 in
    --all)
      CHECK_ALL=true
      shift
      ;;
    --quick)
      CHECK_QUICK=true
      shift
      ;;
    --modified)
      CHECK_MODIFIED_ONLY=true
      shift
      ;;
    --no-build)
      SKIP_BUILD=true
      shift
      ;;
    -h|--help)
      echo "用法: $0 [选项]"
      echo ""
      echo "选项:"
      echo "  --all          执行所有检查"
      echo "  --quick        快速检查（仅代码分析）"
      echo "  --modified     仅检查修改的文件"
      echo "  --no-build     跳过构建测试"
      echo "  -h, --help     显示帮助信息"
      exit 0
      ;;
    *)
      echo "未知选项: $1"
      exit 1
      ;;
  esac
done

# 获取项目根目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}     综合项目检查脚本${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# 检查修改的文件
get_modified_files() {
  if [ -d .git ]; then
    git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || echo ""
  else
    echo ""
  fi
}

MODIFIED_FILES=$(get_modified_files)
MODIFIED_COUNT=$(echo "$MODIFIED_FILES" | grep -c '\.dart$' 2>/dev/null | tr -d '\n' || echo "0")

if [ -n "$MODIFIED_FILES" ]; then
  echo -e "${YELLOW}📝 修改的文件 ($MODIFIED_COUNT 个):${NC}"
  echo "$MODIFIED_FILES" | grep '\.dart$' | sed 's/^/  - /' || true
  echo ""
fi

# 检查 1: 代码分析和格式化
check_code_quality() {
  echo -e "${BLUE}🔍 检查 1: 代码质量和格式${NC}"
  
  echo -e "  运行 flutter analyze..."
  if flutter analyze 2>&1 | tee /tmp/flutter_analyze.log; then
    echo -e "  ${GREEN}✓ 代码分析通过${NC}"
  else
    echo -e "  ${RED}✗ 代码分析失败${NC}"
    cat /tmp/flutter_analyze.log | grep -E "error|warning" || true
  fi
  echo ""
  
  echo -e "  运行 dart format 检查..."
  if dart format --set-exit-if-changed --output=none . 2>/dev/null; then
    echo -e "  ${GREEN}✓ 代码格式正确${NC}"
  else
    echo -e "  ${YELLOW}⚠ 发现需要格式化的文件${NC}"
    dart format --set-exit-if-changed . 2>&1 | grep "Changed" | sed 's/^/    - /' || true
  fi
  echo ""
}

# 检查 2: 国际化声明
check_i18n() {
  # 检查是否有修改的 Dart 文件包含硬编码的中文字符串
  if [ "$CHECK_MODIFIED_ONLY" = true ] && [ -n "$MODIFIED_FILES" ]; then
    MODIFIED_DART=$(echo "$MODIFIED_FILES" | grep '\.dart$' | tr '\n' ' ')
    if [ -n "$MODIFIED_DART" ]; then
      echo -e "${BLUE}🔍 检查 2: 国际化声明（修改的文件）${NC}"
      HARDCODED_STRINGS=$(grep -h "['\"][\u4e00-\u9fa5][^'\"]*['\"]" $MODIFIED_DART 2>/dev/null | head -20 || true)
      if [ -n "$HARDCODED_STRINGS" ]; then
        echo -e "  ${YELLOW}⚠ 发现硬编码的中文字符串:${NC}"
        echo "$HARDCODED_STRINGS" | sed 's/^/    /' || true
      else
        echo -e "  ${GREEN}✓ 未发现硬编码的中文字符串${NC}"
      fi
      echo ""
    fi
  else
    echo -e "${BLUE}🔍 检查 2: 国际化声明${NC}"
    echo -e "  ${YELLOW}⚠ 跳过（使用 --modified 选项检查修改的文件）${NC}"
    echo ""
  fi
}

# 检查 3: 测试用例
check_tests() {
  echo -e "${BLUE}🔍 检查 3: 测试用例${NC}"
  
  if [ "$CHECK_QUICK" = true ]; then
    echo -e "  ${YELLOW}⚠ 快速模式跳过测试运行${NC}"
    echo ""
    return
  fi
  
  echo -e "  运行 flutter test..."
  if flutter test 2>&1 | tee /tmp/flutter_test.log; then
    echo -e "  ${GREEN}✓ 所有测试通过${NC}"
  else
    echo -e "  ${RED}✗ 测试失败${NC}"
    grep -E "FAILED|ERROR" /tmp/flutter_test.log | head -20 || true
  fi
  echo ""
}

# 检查 4: 引用关系
check_references() {
  if [ "$CHECK_MODIFIED_ONLY" = true ] && [ -n "$MODIFIED_FILES" ]; then
    echo -e "${BLUE}🔍 检查 4: 引用关系${NC}"
    
    # 检查修改的文件是否被其他文件引用
    for file in $MODIFIED_DART; do
      if [ -f "$file" ]; then
        # 获取文件名（不含路径）
        filename=$(basename "$file")
        # 查找引用此文件的其他文件
        references=$(grep -r "import.*$filename" lib/ --include="*.dart" 2>/dev/null | grep -v "^$file:" || true)
        if [ -n "$references" ]; then
          echo -e "  ${YELLOW}⚠ $filename 被以下文件引用:${NC}"
          echo "$references" | cut -d: -f1 | sort -u | sed 's/^/    - /' || true
        fi
      fi
    done
    echo ""
  fi
}

# 检查 5: 依赖更新
check_dependencies() {
  echo -e "${BLUE}🔍 检查 5: 依赖更新${NC}"
  
  echo -e "  检查过时的依赖..."
  flutter pub outdated 2>&1 | tee /tmp/pub_outdated.log | grep -E "available|outdated" | head -10 || true
  echo ""
}

# 检查 6: 构建测试
check_build() {
  if [ "$SKIP_BUILD" = true ]; then
    echo -e "${BLUE}🔍 检查 6: 构建测试${NC}"
    echo -e "  ${YELLOW}⚠ 跳过构建测试（--no-build 选项）${NC}"
    echo ""
    return
  fi
  
  if [ "$CHECK_QUICK" = true ]; then
    echo -e "  ${YELLOW}⚠ 快速模式跳过构建测试${NC}"
    echo ""
    return
  fi
  
  echo -e "${BLUE}🔍 检查 6: 构建测试${NC}"
  
  echo -e "  测试 Android 构建..."
  if flutter build apk --debug --target-platform android-arm64 2>&1 | tee /tmp/build_apk.log | tail -20; then
    echo -e "  ${GREEN}✓ Android 构建成功${NC}"
  else
    echo -e "  ${RED}✗ Android 构建失败${NC}"
  fi
  echo ""
}

# 检查 7: 资源引用
check_resources() {
  if [ "$CHECK_MODIFIED_ONLY" = true ] && [ -n "$MODIFIED_FILES" ]; then
    echo -e "${BLUE}🔍 检查 7: 资源引用${NC}"
    
    # 检查修改的文件中引用的资源是否存在
    for file in $MODIFIED_DART; do
      if [ -f "$file" ]; then
        # 检查图片引用
        images=$(grep -oE 'assets/[^"'\''\)]+' "$file" 2>/dev/null || true)
        for img in $images; do
          if [ ! -f "$img" ]; then
            echo -e "  ${RED}✗ 资源不存在: $img${NC}"
          fi
        done
      fi
    done
    echo ""
  fi
}

# 检查 8: 数据库 Schema 变更
check_database_schema() {
  if [ "$CHECK_MODIFIED_ONLY" = true ] && [ -n "$MODIFIED_FILES" ]; then
    echo -e "${BLUE}🔍 检查 8: 数据库 Schema${NC}"
    
    # 检查是否修改了 Isar schema 文件
    SCHEMA_FILES=$(echo "$MODIFIED_FILES" | grep -E 'model.*\.dart$|schema' || true)
    if [ -n "$SCHEMA_FILES" ]; then
      echo -e "  ${YELLOW}⚠ 检测到数据库模型变更:${NC}"
      echo "$SCHEMA_FILES" | sed 's/^/    - /'
      echo -e "  ${YELLOW}⚠ 提示: 确保运行 'dart run build_runner build' 重新生成代码${NC}"
    else
      echo -e "  ${GREEN}✓ 未检测到数据库模型变更${NC}"
    fi
    echo ""
  fi
}

# 检查 9: API 变更
check_api_changes() {
  if [ "$CHECK_MODIFIED_ONLY" = true ] && [ -n "$MODIFIED_FILES" ]; then
    echo -e "${BLUE}🔍 检查 9: API 变更${NC}"
    
    # 检查是否修改了 API 相关文件
    API_FILES=$(echo "$MODIFIED_FILES" | grep -E 'api/|service/' || true)
    if [ -n "$API_FILES" ]; then
      echo -e "  ${YELLOW}⚠ 检测到 API 变更:${NC}"
      echo "$API_FILES" | sed 's/^/    - /'
      echo -e "  ${YELLOW}⚠ 提示: 检查调用方是否需要更新${NC}"
    else
      echo -e "  ${GREEN}✓ 未检测到 API 变更${NC}"
    fi
    echo ""
  fi
}

# 检查 10: 安全检查
check_security() {
  echo -e "${BLUE}🔍 检查 10: 安全检查${NC}"
  
  # 检查是否有硬编码的密钥或敏感信息
  SECRETS=$(grep -rE 'password|secret|api[_-]?key|token' lib/ --include="*.dart" 2>/dev/null | grep -v "test" | grep -E "(=|:).*(\".*\"|'.*')" | head -10 || true)
  if [ -n "$SECRETS" ]; then
    echo -e "  ${YELLOW}⚠ 发现可能的敏感信息:${NC}"
    echo "$SECRETS" | sed 's/^/    /' || true
  else
    echo -e "  ${GREEN}✓ 未发现明显的安全问题${NC}"
  fi
  echo ""
}

# 生成报告
generate_report() {
  echo -e "${BLUE}========================================${NC}"
  echo -e "${BLUE}     检查报告${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo ""
  
  # 统计问题
  ERRORS=$(grep -c "^  error" /tmp/flutter_analyze.log 2>/dev/null | tr -d '\n' || echo "0")
  WARNINGS=$(grep -c "^  warning" /tmp/flutter_analyze.log 2>/dev/null | tr -d '\n' || echo "0")
  
  echo -e "📊 检查统计:"
  echo -e "  - 代码错误: $ERRORS"
  echo -e "  - 代码警告: $WARNINGS"
  echo -e "  - 修改文件: $MODIFIED_COUNT"
  echo ""
  
  if [ "$ERRORS" -gt 0 ]; then
    echo -e "${RED}❌ 检查失败：发现 $ERRORS 个错误${NC}"
    exit 1
  elif [ "$WARNINGS" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  检查通过但有 $WARNINGS 个警告${NC}"
    exit 0
  else
    echo -e "${GREEN}✅ 所有检查通过！${NC}"
    exit 0
  fi
}

# 主流程
main() {
  # 代码质量检查（始终执行）
  check_code_quality
  
  # 根据参数执行其他检查
  if [ "$CHECK_ALL" = true ] || [ "$CHECK_QUICK" = false ]; then
    check_i18n
    check_tests
    check_references
    check_dependencies
    check_build
    check_resources
    check_database_schema
    check_api_changes
    check_security
  fi
  
  # 生成报告
  generate_report
}

# 执行主流程
main