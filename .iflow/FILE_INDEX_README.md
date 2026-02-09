# 项目文件索引使用说明

## 📊 概述

项目文件索引是一个用于快速查找和定位项目文件的工具，包含所有 Dart 文件的元数据信息。

## 📦 文件信息

**索引文件**: `.iflow/file_index.json`
**生成时间**: 2026-02-10T00:52:00
**总文件数**: 207 个 Dart 文件

## 📁 文件分类统计

### 按类型分类
- **other**: 78 个
- **provider**: 31 个
- **extension**: 20 个
- **model**: 18 个
- **widget**: 13 个
- **api**: 10 个
- **page**: 10 个
- **converter**: 8 个
- **navigation**: 6 个
- **utils**: 5 个
- **arch**: 4 个
- **theme**: 2 个
- **cache**: 1 个
- **service**: 1 个

### 按模块分类
- **lib/core**: 92 个
- **lib/src**: 67 个
- **lib/domain**: 32 个
- **lib/data**: 10 个
- **lib/l10n_gen**: 3 个
- **lib/di**: 1 个
- **lib/gen**: 1 个
- **lib/main.dart**: 1 个

## 🔍 使用方法

### 1. 查看统计信息

```bash
/tmp/query_file_index.sh
```

输出示例:
```
📊 项目文件索引统计

📁 按类型分类:
  - other: 78 个
  - provider: 31 个
  - ...

📦 按模块分类:
  - lib/core: 92 个
  - lib/src: 67 个
  - ...

📄 总计: 207 个文件

用法: /tmp/query_file_index.sh [关键词]
  - 搜索包含关键词的文件
  - 关键词可以是文件名、类型或路径
```

### 2. 搜索文件

按类型搜索:
```bash
/tmp/query_file_index.sh widget    # 搜索 widget 类型
/tmp/query_file_index.sh provider  # 搜索 provider 类型
/tmp/query_file_index.sh model     # 搜索 model 类型
```

按文件名搜索:
```bash
/tmp/query_file_index.sh card      # 搜索包含 "card" 的文件
/tmp/query_file_index.sh page      # 搜索包含 "page" 的文件
```

按路径搜索:
```bash
/tmp/query_file_index.sh src/movie  # 搜索 src/movie 路径下的文件
/tmp/query_file_index.sh core/api  # 搜索 core/api 路径下的文件
```

输出示例:
```
🔍 搜索: widget

找到 13 个文件:

📄 lib/core/cache/widget/cache_decoration_image.dart
   类型: widget | 大小: 1.76 KB | 行数: ~17
   路径: /data/home/dove/projects/sjgtv/lib/core/cache/widget/cache_decoration_image.dart

📄 lib/core/cache/widget/cache_image.dart
   类型: widget | 大小: 2.81 KB | 行数: ~28
   路径: /data/home/dove/projects/sjgtv/lib/core/cache/widget/cache_image.dart
...
```

## 📝 索引数据结构

每个文件包含以下信息:
- **path**: 相对路径
- **absolute_path**: 绝对路径
- **type**: 文件类型 (model, widget, page, provider 等)
- **size_kb**: 文件大小 (KB)
- **modified**: 最后修改时间 (ISO 8601 格式)
- **lines**: 估算的行数

## 🔄 更新索引

当项目文件发生变化时，需要重新生成索引:

```bash
python3 /tmp/generate_file_index.py
```

## 💡 使用场景

### 快速查找组件
```bash
/tmp/query_file_index.sh widget
```

### 查找数据模型
```bash
/tmp/query_file_index.sh model
```

### 查找页面文件
```bash
/tmp/query_file_index.sh page
```

### 查找特定功能文件
```bash
/tmp/query_file_index.sh cache
/tmp/query_file_index.sh navigation
```

## 🎯 最佳实践

1. **定期更新索引**: 当添加、删除或重命名文件后，重新生成索引
2. **使用精确关键词**: 使用文件类型或路径关键词进行搜索
3. **结合其他工具**: 将文件索引与 `grep`、`find` 等工具结合使用

## 📚 相关工具

- **文件搜索**: `find lib -name "*.dart" -type f`
- **内容搜索**: `grep -r "keyword" lib/`
- **代码分析**: `flutter analyze`

---

**生成日期**: 2026-02-10
**工具版本**: 1.0