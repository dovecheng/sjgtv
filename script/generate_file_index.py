#!/usr/bin/env python3
import os
import json
from pathlib import Path
from datetime import datetime

# 项目根目录
project_root = Path("/data/home/dove/projects/sjgtv/lib")

# 忽略的目录
ignore_dirs = {'.dart_tool', 'build', '.git', '.github', '.devcontainer', 'node_modules', '.tmp'}

# 文件类型分类
def classify_file(path):
    path_str = str(path)
    if '/model/' in path_str:
        return 'model'
    elif '/widget/' in path_str:
        return 'widget'
    elif '/page/' in path_str:
        return 'page'
    elif '/provider/' in path_str:
        return 'provider'
    elif '/service/' in path_str:
        return 'service'
    elif '/api/' in path_str:
        return 'api'
    elif '/util' in path_str or '/utils/' in path_str:
        return 'utils'
    elif '/extension/' in path_str:
        return 'extension'
    elif '/converter/' in path_str:
        return 'converter'
    elif '/arch/' in path_str:
        return 'arch'
    elif '/cache/' in path_str:
        return 'cache'
    elif '/theme/' in path_str:
        return 'theme'
    elif '/navigation/' in path_str or '/router/' in path_str:
        return 'navigation'
    elif '/test/' in path_str:
        return 'test'
    else:
        return 'other'

# 收集所有文件
file_index = []
total_count = 0

for root, dirs, files in os.walk(project_root):
    # 过滤忽略的目录
    dirs[:] = [d for d in dirs if d not in ignore_dirs and not d.startswith('.')]
    
    for file in files:
        if file.endswith('.dart'):
            file_path = Path(root) / file
            rel_path = file_path.relative_to(project_root.parent)
            
            # 获取文件信息
            stat = file_path.stat()
            size_kb = stat.st_size / 1024
            mtime = datetime.fromtimestamp(stat.st_mtime).isoformat()
            
            # 分类
            file_type = classify_file(file_path)
            
            file_index.append({
                'path': str(rel_path),
                'absolute_path': str(file_path),
                'type': file_type,
                'size_kb': round(size_kb, 2),
                'modified': mtime,
                'lines': int(stat.st_size / 100) if stat.st_size > 0 else 0  # 估算行数
            })
            total_count += 1

# 按类型分组统计
by_type_count = {}
for file_info in file_index:
    file_type = file_info['type']
    by_type_count[file_type] = by_type_count.get(file_type, 0) + 1

# 按模块分组统计
by_module_count = {}
for file_info in file_index:
    parts = file_info['path'].split('/')
    if len(parts) >= 2:
        module = f"{parts[0]}/{parts[1]}"
    else:
        module = parts[0]
    
    by_module_count[module] = by_module_count.get(module, 0) + 1

# 生成索引
index = {
    'generated_at': datetime.now().isoformat(),
    'total_files': total_count,
    'by_type': dict(sorted(by_type_count.items())),
    'by_module': dict(sorted(by_module_count.items())),
    'files': sorted(file_index, key=lambda x: x['path'])
}

# 保存索引
output_file = Path("/data/home/dove/projects/sjgtv/.iflow/file_index.json")
with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(index, f, indent=2, ensure_ascii=False)

print(f"✅ 文件索引已生成: {output_file}")
print(f"📊 总计: {total_count} 个 Dart 文件")
print(f"📁 按类型分类:")
for file_type, count in sorted(by_type_count.items()):
    print(f"  - {file_type}: {count} 个")
print(f"📦 按模块分类 (前10):")
for module, count in sorted(by_module_count.items(), key=lambda x: x[1], reverse=True)[:10]:
    print(f"  - {module}: {count} 个")
