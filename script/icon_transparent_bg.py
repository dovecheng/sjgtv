#!/usr/bin/env python3
"""
将图片中与边缘连通的深色背景设为透明，输出 PNG。
只抠与四边连通的连续背景区域，中间的相似色保留。

用法（任意工作目录）：
  python3 script/icon_transparent_bg.py --input /path/to/icon.png
  python3 script/icon_transparent_bg.py --input icon.png --output icon_transparent_bg.png
  python3 script/icon_transparent_bg.py --input icon.png --no-overwrite

可选参数可调整背景色范围；仅从边缘 flood fill 得到的连通区域会变透明。
"""
import argparse
import sys
from collections import deque
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("错误: 需要安装 Pillow")
    print("请运行: pip3 install --user Pillow")
    sys.exit(1)

# 默认背景色范围（深蓝紫，含 #0d0d27 #1a0e26 等，略放宽以覆盖抗锯齿）
DEFAULT_R_MAX = 32
DEFAULT_G_MAX = 22
DEFAULT_B_MIN = 14
DEFAULT_B_MAX = 56


def _is_bg_color(r: int, g: int, b: int, r_max: int, g_max: int, b_min: int, b_max: int) -> bool:
    return r <= r_max and g <= g_max and b_min <= b <= b_max


def make_background_transparent(
    input_path: str,
    r_max: int = DEFAULT_R_MAX,
    g_max: int = DEFAULT_G_MAX,
    b_min: int = DEFAULT_B_MIN,
    b_max: int = DEFAULT_B_MAX,
) -> Image.Image | None:
    """仅将与边缘连通的背景色区域设为透明（flood fill 从四边开始），返回 RGBA 图。"""
    path = Path(input_path)
    if not path.exists():
        print(f"✗ 文件不存在: {input_path}")
        return None
    try:
        img = Image.open(path).convert("RGBA")
    except Exception as e:
        print(f"✗ 无法打开图片: {e}")
        return None

    w, h = img.size
    data = list(img.getdata())

    def idx(x: int, y: int) -> int:
        return y * w + x

    is_bg = [
        _is_bg_color(
            *((item[:3]) if len(item) >= 3 else (0, 0, 0)),
            r_max, g_max, b_min, b_max,
        )
        for item in data
    ]

    to_remove = [False] * (w * h)
    q: deque[tuple[int, int]] = deque()
    for x in range(w):
        if is_bg[idx(x, 0)]:
            to_remove[idx(x, 0)] = True
            q.append((x, 0))
        if is_bg[idx(x, h - 1)]:
            to_remove[idx(x, h - 1)] = True
            q.append((x, h - 1))
    for y in range(h):
        if is_bg[idx(0, y)]:
            to_remove[idx(0, y)] = True
            q.append((0, y))
        if is_bg[idx(w - 1, y)]:
            to_remove[idx(w - 1, y)] = True
            q.append((w - 1, y))

    while q:
        x, y = q.popleft()
        for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < w and 0 <= ny < h and is_bg[idx(nx, ny)] and not to_remove[idx(nx, ny)]:
                to_remove[idx(nx, ny)] = True
                q.append((nx, ny))

    new_data: list[tuple[int, int, int, int]] = []
    for i, item in enumerate(data):
        r, g, b, a = (item if len(item) == 4 else (*item[:3], 255))
        if to_remove[i]:
            new_data.append((r, g, b, 0))
        else:
            new_data.append((r, g, b, a))

    img.putdata(new_data)
    return img


def main() -> None:
    parser = argparse.ArgumentParser(
        description="将图片中指定深色背景范围设为透明，输出 PNG",
    )
    parser.add_argument("--input", "-i", type=str, required=True, help="输入图片路径")
    parser.add_argument(
        "--output",
        "-o",
        type=str,
        default=None,
        help="透明背景输出路径（默认：输入同目录下 原名_transparent_bg.png）",
    )
    parser.add_argument(
        "--no-overwrite",
        action="store_true",
        help="不覆盖原图，仅写入 --output（未指定则用默认输出路径）",
    )
    parser.add_argument("--r-max", type=int, default=DEFAULT_R_MAX, help="背景 R 上限（默认 %s）" % DEFAULT_R_MAX)
    parser.add_argument("--g-max", type=int, default=DEFAULT_G_MAX, help="背景 G 上限（默认 %s）" % DEFAULT_G_MAX)
    parser.add_argument("--b-min", type=int, default=DEFAULT_B_MIN, help="背景 B 下限（默认 %s）" % DEFAULT_B_MIN)
    parser.add_argument("--b-max", type=int, default=DEFAULT_B_MAX, help="背景 B 上限（默认 %s）" % DEFAULT_B_MAX)
    args = parser.parse_args()

    input_path = Path(args.input).resolve()
    if not input_path.exists():
        print(f"✗ 输入文件不存在: {input_path}")
        sys.exit(1)

    if args.output:
        output_path = Path(args.output).resolve()
    else:
        output_path = input_path.parent / f"{input_path.stem}_transparent_bg.png"

    output_path.parent.mkdir(parents=True, exist_ok=True)

    img = make_background_transparent(
        str(input_path),
        r_max=args.r_max,
        g_max=args.g_max,
        b_min=args.b_min,
        b_max=args.b_max,
    )
    if img is None:
        sys.exit(1)

    if output_path.resolve() != input_path.resolve():
        img.save(str(output_path), "PNG", optimize=True)
        print(f"✓ 已保存透明背景图: {output_path}")

    if not args.no_overwrite:
        img.save(str(input_path), "PNG", optimize=True)
        print(f"✓ 已覆盖原图: {input_path}")

    print("完成")


if __name__ == "__main__":
    main()
