#!/usr/bin/env python3
"""
检查 Dart 代码中重写方法是否调用了 super

用法:
    python3 check_super_calls.py [目录路径]

参数:
    目录路径: 要检查的目录（默认: app、base）

示例:
    python3 script/check_super_calls.py                    # 检查所有 @override 方法
    python3 script/check_super_calls.py base            # 只检查 base
    python3 script/check_super_calls.py app            # 只检查 app

说明:
    此脚本用于扫描所有 @override 方法，检查是否调用了 super。

    注意：并非所有未调用 super 的情况都是问题，需要根据具体情况判断：

    1. 父类方法可能是空实现，但未来可能会添加代码
       - 如果父类方法当前是空的，可以考虑调用 super 以保持兼容性
       - 但这并非强制要求，取决于具体情况：
         * 如果父类可能在未来添加实现，调用 super 可以保持兼容性
         * 如果确定父类永远不会添加实现，或者子类需要完全替代父类行为，不调用也是可以的
       - 调用 super 通常不会造成问题（即使父类是空实现），但也没有实际作用

    2. 子类需要完全覆盖父类的默认实现
       - 例如：拦截器场景中，父类默认实现是"跳过拦截"，子类重写是为了"处理拦截"
       - 这种情况下，不调用 super 是合理的，因为子类需要替代父类的行为

    3. 父类有默认实现，但子类需要跳过该默认实现
       - 某些设计模式中，子类需要完全自定义行为，不执行父类的默认逻辑
       - 这种情况下，不调用 super 是符合设计意图的

    4. 父类是抽象方法，没有方法体
       - 如果父类方法是 abstract 的，子类重写时不需要调用 super
       - 因为抽象方法本身没有实现，调用 super 会导致编译错误

    因此，此脚本仅用于提醒和检查，最终是否需要调用 super 应由开发者根据业务逻辑决定。
"""

import os
import re
import sys
from pathlib import Path
from typing import List, Tuple, Optional


def find_dart_files(root_dir: str) -> List[Path]:
    """查找所有 .dart 文件"""
    dart_files = []
    for path in Path(root_dir).rglob("*.dart"):
        # 排除一些目录
        if any(excluded in str(path) for excluded in [
            ".dart_tool",
            "build",
            ".pub-cache",
            "gen",
            ".freezed.dart",
            ".g.dart",
        ]):
            continue
        dart_files.append(path)
    return dart_files


def extract_method_name(line: str) -> Optional[str]:
    """从方法声明行提取方法名"""
    # 匹配: void methodName(...) 或 Future<void> methodName(...) 等
    patterns = [
        r'@override\s+.*?\s+(\w+)\s*\(',  # @override ... methodName(
        r'(\w+)\s*\([^)]*\)\s*{',  # methodName(...) {
        r'(\w+)\s*\([^)]*\)\s*async',  # methodName(...) async
    ]

    for pattern in patterns:
        match = re.search(pattern, line)
        if match:
            return match.group(1)
    return None


def has_return_value(method_declaration: str) -> bool:
    """检查方法是否有返回值（非 void）"""
    # 移除注释和空白
    decl = re.sub(r'//.*$', '', method_declaration).strip()

    # 移除 @override 和 @mustCallSuper 等注解
    decl = re.sub(r'@\w+\s*', '', decl).strip()

    # 提取方法名
    method_name_match = re.search(r'(\w+)\s*\(', decl)
    if not method_name_match:
        return False  # 无法提取方法名，默认无返回值

    method_name = method_name_match.group(1)
    # 获取方法名之前的部分（返回类型部分）
    before_method = decl[:decl.index(method_name)].strip()

    # 如果没有返回类型声明，默认是 void（无返回值）
    if not before_method:
        return False

    # 检查是否是 void 或 Future<void>
    # 匹配: void 或 Future<void> 或 Future< void >
    if re.match(r'^\s*void\s*$', before_method):
        return False  # void 无返回值

    if re.match(r'^\s*Future\s*<\s*void\s*>\s*$', before_method):
        return False  # Future<void> 无返回值

    # 其他情况认为有返回值
    return True


def check_super_call(file_path: Path) -> List[Tuple[int, str]]:
    """检查文件中重写方法是否调用了 super

    返回: [(行号, 方法名), ...]

    注意：此函数仅用于扫描和提醒，并非所有未调用 super 的情况都是问题。
    需要开发者根据具体情况判断：

    1. 父类方法可能是空实现，但未来可能会添加代码
       - 可以考虑调用 super 以保持兼容性，但这并非强制要求
       - 取决于具体情况：如果父类可能在未来添加实现，调用 super 可以保持兼容性
       - 如果确定父类永远不会添加实现，或者子类需要完全替代父类行为，不调用也是可以的

    2. 子类需要完全覆盖父类的默认实现
       - 例如拦截器场景：父类默认"跳过拦截"，子类重写"处理拦截"
       - 这种情况下不调用 super 是合理的

    3. 父类有默认实现，但子类需要跳过该默认实现
       - 某些设计模式中，子类需要完全自定义行为
       - 这种情况下不调用 super 是符合设计意图的

    4. 父类是抽象方法，没有方法体
       - 如果父类方法是 abstract 的，子类重写时不需要调用 super
       - 因为抽象方法本身没有实现，调用 super 会导致编译错误
    """
    issues = []

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except Exception as e:
        return [(0, "ERROR")]

    i = 0
    while i < len(lines):
        line = lines[i]

        # 检查是否是 @override 方法
        if '@override' in line:
            # 查找方法声明（可能在下一行）
            method_name = None
            method_start = i
            method_declaration_line = None

            # 在当前行或下一行查找方法名
            if i + 1 < len(lines):
                next_line = lines[i + 1]
                method_name = extract_method_name(next_line)
                if method_name:
                    i += 1  # 跳过 @override 行
                    method_start = i
                    method_declaration_line = next_line

            if not method_name:
                # 尝试从当前行提取（@override 和方法在同一行）
                method_name = extract_method_name(line)
                if method_name:
                    method_start = i
                    method_declaration_line = line

            if method_name:
                # 检查方法是否有返回值，如果有则跳过
                if method_declaration_line and has_return_value(method_declaration_line):
                    i += 1
                    continue

                # 查找方法体
                method_body_lines = []
                brace_count = 0
                found_opening_brace = False
                j = method_start

                # 找到方法开始的大括号
                while j < len(lines):
                    current_line = lines[j]
                    method_body_lines.append(current_line)

                    # 计算大括号
                    brace_count += current_line.count('{')
                    brace_count -= current_line.count('}')

                    if '{' in current_line:
                        found_opening_brace = True

                    if found_opening_brace and brace_count == 0:
                        break

                    j += 1

                # 检查方法体中是否有 super.方法名 调用
                method_body = ''.join(method_body_lines)
                super_patterns = [
                    rf'super\.{re.escape(method_name)}\s*\(',
                    rf'super\.{re.escape(method_name)}\s*;',
                ]

                has_super_call = any(
                    re.search(pattern, method_body, re.MULTILINE)
                    for pattern in super_patterns
                )

                # 如果方法体为空或者是抽象方法，跳过
                if method_body.strip().endswith(';') or 'abstract' in line:
                    pass
                elif not has_super_call:
                    # 检查是否是特殊方法（通常不需要 super）
                    skip_methods = [
                        'build', 'createState', 'toString', 'hashCode', 'operator ==',
                        'noSuchMethod', 'runtimeType',
                    ]

                    if method_name not in skip_methods:
                        # 所有 @override 方法都应该检查是否调用了 super
                        issues.append((
                            method_start + 1,
                            method_name,
                        ))

        i += 1

    return issues


def main():
    # 项目根目录（script 的上一级）
    root = Path(__file__).resolve().parent.parent
    os.chdir(root)

    # 默认检查目录
    if len(sys.argv) > 1:
        check_dirs = [sys.argv[1]]
    else:
        check_dirs = ['app', 'base']

    all_issues = []

    for check_dir in check_dirs:
        if not os.path.exists(check_dir):
            print(f"⚠️  目录不存在: {check_dir}")
            continue

        print(f"🔍 检查目录: {check_dir}")
        dart_files = find_dart_files(check_dir)
        print(f"   找到 {len(dart_files)} 个 Dart 文件\n")

        for dart_file in sorted(dart_files):
            issues = check_super_call(dart_file)
            if issues:
                all_issues.append((dart_file, issues))

    # 输出结果
    if all_issues:
        print("\n" + "=" * 80)
        print("❌ 发现问题:")
        print("=" * 80)
        print("⚠️  注意：以下方法未调用 super，但并非所有情况都需要修复。")
        print("   请根据具体情况判断：")
        print("   1. 父类方法可能是空实现，但未来可能会添加代码 → 可考虑调用 super（非强制）")
        print("   2. 子类需要完全覆盖父类的默认实现 → 不调用 super 是合理的")
        print("   3. 父类有默认实现，但子类需要跳过该默认实现 → 不调用 super 是符合设计意图的")
        print("   4. 父类是抽象方法，没有方法体 → 不需要调用 super（抽象方法无实现）")
        print("=" * 80 + "\n")

        # 总序号
        total_index = 1

        for file_path, issues in all_issues:
            # 输出绝对路径，终端可点击跳转
            abs_path = Path(file_path).resolve()
            print(f"📄 {abs_path}")
            for line_num, method_name in issues:
                # 输出 路径:行号 格式，VS Code/Cursor 终端支持点击跳转到指定行
                file_link = f"{abs_path}:{line_num}"
                print(f"   #{total_index} {line_num:4d}: {method_name}")
                print(f"      🔗 {file_link}")
                total_index += 1
            print()

        print("=" * 80)
        print(f"总计: {total_index - 1} 个潜在问题")
    else:
        print("\n✅ 未发现问题！所有重写方法都调用了 super")


if __name__ == '__main__':
    main()
