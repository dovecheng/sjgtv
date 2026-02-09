# check

项目综合检查命令，用于检查代码错误、警告、国际化、测试、引用关系等。

## 检查项

### 1. 代码错误检查
```bash
flutter analyze
```
检查代码中的错误，包括语法错误、类型错误、未定义的引用等。

### 2. 代码警告检查
```bash
flutter analyze
```
检查代码中的警告，包括未使用的变量、过时的 API 等。

### 3. 代码格式检查
```bash
dart format --set-exit-if-changed .
```
检查代码格式是否符合 Dart 代码规范。

### 4. 代码格式化
```bash
dart format .
```
自动格式化所有代码文件。

### 5. 国际化检查
```bash
grep -r "['\"][\u4e00-\u9fa5][^'\"]*['\"]" lib/ --include="*.dart"
```
检查硬编码的中文字符串，应该使用国际化。

### 6. 测试用例检查
```bash
flutter test
```
运行所有单元测试和集成测试。

### 7. 引用关系检查
```bash
# 检查修改文件的引用关系
git diff --name-only HEAD | grep '\.dart$' | while read file; do
  filename=$(basename "$file")
  grep -r "import.*$filename" lib/ --include="*.dart" | grep -v "^$file:" || true
done
```
检查修改的文件是否被其他文件引用。

### 8. 依赖更新检查
```bash
flutter pub outdated
```
检查是否有依赖包可以更新。

### 9. 资源引用检查
```bash
# 检查引用的资源是否存在
grep -rhE 'assets/[^"'\''\)]+' lib/ --include="*.dart" | while read asset; do
  if [ ! -f "$asset" ]; then
    echo "资源不存在: $asset"
  fi
done
```
检查代码中引用的资源文件是否存在。

### 10. 数据库 Schema 检查
```bash
# 检查 Isar model 变更
git diff --name-only HEAD | grep -E 'model.*\.dart$|schema'
```
检查是否有数据库模型变更，需要重新生成代码。

### 11. API 变更检查
```bash
# 检查 API 相关文件变更
git diff --name-only HEAD | grep -E 'api/|service/'
```
检查是否有 API 相关文件变更，需要检查调用方。

### 12. 安全检查
```bash
# 检查敏感信息
grep -rE 'password|secret|api[_-]?key|token' lib/ --include="*.dart" | grep -v "test" | grep -E "(=|:).*(\".*\"|'.*')"
```
检查代码中是否有硬编码的敏感信息。

### 13. 导入路径检查
```bash
# 检查是否使用了相对路径导入（不建议使用）
grep -r "^import.*'\.\./" lib/ --include="*.dart"
```
检查是否使用了相对路径导入，建议使用包路径（`package:`）代替相对路径。

## 快速检查

快速检查（仅代码分析）：
```bash
flutter analyze && dart format --set-exit-if-changed .
```

完整检查（所有项）：
```bash
flutter analyze && dart format . && flutter test && grep -r "^import.*'\.\./" lib/ --include="*.dart"
```

## 检查结果

- ✅ 无错误、无警告：代码质量良好
- ⚠️ 有警告：需要修复警告
- ❌ 有错误：必须修复错误才能提交