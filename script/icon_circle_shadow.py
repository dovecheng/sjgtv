#!/usr/bin/env python3
"""
生成圆形裁剪的应用图标，带轻微阴影，不覆盖原图。

用法（任意工作目录）：
  python3 script/icon_circle_shadow.py --input app/assets/icon/icon.png
  python3 script/icon_circle_shadow.py -i icon.png -o icon_circle.png

输出默认：输入同目录下 原名_circle.png
"""
import argparse
import sys
from pathlib import Path

try:
    from PIL import Image, ImageFilter, ImageDraw
except ImportError:
    print("错误: 需要安装 Pillow")
    print("请运行: pip3 install --user Pillow")
    sys.exit(1)


def _circle_mask(size: int) -> Image.Image:
    """生成圆形遮罩（内白外透明），直径 = size。"""
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    r = size / 2.0
    draw.ellipse((0, 0, size - 1, size - 1), fill=255)
    return mask


def make_circle_icon_with_shadow(
    input_path: str,
    output_size: int = 1024,
    shadow_offset: float = 0.02,
    shadow_blur: float = 0.03,
    shadow_opacity: float = 0.35,
    shadow_color_hex: str = "#0a0a12",
) -> Image.Image | None:
    """
    生成圆形裁剪 + 轻微阴影的图标。
    shadow_offset/shadow_blur 为相对半径的比例；不覆盖原图，返回新图。
    """
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
    if w != h or w != output_size:
        img = img.resize((output_size, output_size), Image.Resampling.LANCZOS)

    size = output_size
    mask = _circle_mask(size)
    circle_only = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    circle_only.paste(img, (0, 0), mask)

    radius = size / 2.0
    offset_px = max(2, int(radius * shadow_offset))
    blur_px = max(2, int(radius * shadow_blur))

    hex_color = shadow_color_hex.lstrip("#")
    sr = int(hex_color[0:2], 16)
    sg = int(hex_color[2:4], 16)
    sb = int(hex_color[4:6], 16)
    sa = int(255 * shadow_opacity)
    shadow_color: tuple[int, int, int, int] = (sr, sg, sb, sa)

    shadow_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(shadow_layer)
    r_inner = radius - 2
    draw.ellipse(
        (
            radius - r_inner + offset_px,
            radius - r_inner + offset_px,
            radius + r_inner + offset_px,
            radius + r_inner + offset_px,
        ),
        fill=shadow_color,
    )
    shadow_layer = shadow_layer.filter(ImageFilter.GaussianBlur(radius=blur_px))
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    canvas.paste(shadow_layer, (0, 0), shadow_layer)
    canvas.paste(circle_only, (0, 0), circle_only)
    return canvas


def main() -> None:
    parser = argparse.ArgumentParser(
        description="生成圆形裁剪的应用图标（带轻微阴影），不覆盖原图",
    )
    parser.add_argument("--input", "-i", type=str, required=True, help="输入图标路径")
    parser.add_argument(
        "--output",
        "-o",
        type=str,
        default=None,
        help="输出路径（默认：输入同目录 原名_circle.png）",
    )
    parser.add_argument(
        "--size",
        type=int,
        default=1024,
        help="输出边长（默认 1024）",
    )
    parser.add_argument(
        "--shadow-offset",
        type=float,
        default=0.02,
        help="阴影偏移相对半径比例（默认 0.02）",
    )
    parser.add_argument(
        "--shadow-blur",
        type=float,
        default=0.03,
        help="阴影模糊相对半径比例（默认 0.03）",
    )
    parser.add_argument(
        "--shadow-opacity",
        type=float,
        default=0.35,
        help="阴影不透明度 0~1（默认 0.35）",
    )
    parser.add_argument(
        "--shadow-color",
        type=str,
        default="#0a0a12",
        help="阴影颜色十六进制（默认 #0a0a12）",
    )
    args = parser.parse_args()

    input_path = Path(args.input).resolve()
    if not input_path.exists():
        print(f"✗ 输入文件不存在: {input_path}")
        sys.exit(1)

    if args.output:
        output_path = Path(args.output).resolve()
    else:
        output_path = input_path.parent / f"{input_path.stem}_circle.png"

    output_path.parent.mkdir(parents=True, exist_ok=True)

    img = make_circle_icon_with_shadow(
        str(input_path),
        output_size=args.size,
        shadow_offset=args.shadow_offset,
        shadow_blur=args.shadow_blur,
        shadow_opacity=args.shadow_opacity,
        shadow_color_hex=args.shadow_color,
    )
    if img is None:
        sys.exit(1)

    img.save(str(output_path), "PNG", optimize=True)
    print(f"✓ 已保存圆形图标（带阴影）: {output_path}")
    print("完成")


if __name__ == "__main__":
    main()
