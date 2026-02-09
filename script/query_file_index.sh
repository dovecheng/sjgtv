#!/bin/bash
# 文件索引查询工具

INDEX_FILE=".iflow/file_index.json"

if [ ! -f "$INDEX_FILE" ]; then
    echo "❌ 文件索引不存在: $INDEX_FILE"
    echo "请先运行 python3 生成索引"
    exit 1
fi

if [ $# -eq 0 ]; then
    echo "📊 项目文件索引统计"
    echo ""
    echo "📁 按类型分类:"
    cat "$INDEX_FILE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for t, c in sorted(data['by_type'].items(), key=lambda x: x[1], reverse=True):
    print(f'  - {t}: {c} 个')
"
    echo ""
    echo "📦 按模块分类:"
    cat "$INDEX_FILE" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for m, c in sorted(data['by_module'].items(), key=lambda x: x[1], reverse=True):
    print(f'  - {m}: {c} 个')
"
    echo ""
    echo "📄 总计: $(cat "$INDEX_FILE" | python3 -c "import json,sys; print(json.load(sys.stdin)['total_files'])") 个文件"
    echo ""
    echo "用法: $0 [关键词]"
    echo "  - 搜索包含关键词的文件"
    echo "  - 关键词可以是文件名、类型或路径"
    exit 0
fi

# 搜索功能
KEYWORD="$1"
echo "🔍 搜索: $KEYWORD"
echo ""

cat "$INDEX_FILE" | python3 -c "
import json, sys

data = json.load(sys.stdin)
keyword = sys.argv[1].lower()

results = []
for file in data['files']:
    if keyword in file['path'].lower() or \
       keyword in file['type'].lower():
        results.append(file)

if results:
    print(f'找到 {len(results)} 个文件:')
    print('')
    for file in results:
        print(f'📄 {file[\"path\"]}')
        print(f'   类型: {file[\"type\"]} | 大小: {file[\"size_kb\"]} KB | 行数: ~{file[\"lines\"]}')
        print(f'   路径: {file[\"absolute_path\"]}')
        print('')
else:
    print('未找到匹配的文件')
" "$KEYWORD"
