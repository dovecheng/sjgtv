#!/usr/bin/env python3
"""
通用图片压缩和调整分辨率脚本

功能：
- 支持单个图片或批量处理目录中的所有图片
- 自动确保分辨率宽度和高度为偶数
- 优化 PNG 压缩

使用方法：
1. 按宽度压缩单个图片：
   python3 script/resize_images.py --input path/to/image.png --output path/to/output.png --width 320

2. 按高度压缩单个图片：
   python3 script/resize_images.py --input path/to/image.png --output path/to/output.png --height 240

3. 指定宽高（等比缩放后裁剪，填满目标尺寸）：
   python3 script/resize_images.py --input path/to/image.png --output path/to/output.png --width 320 --height 240 --fit-mode fit

4. 指定宽高（等比缩放后填充，完整显示）：
   python3 script/resize_images.py --input path/to/image.png --output path/to/output.png --width 320 --height 240 --fit-mode fill

5. 批量处理目录中的所有 PNG 图片：
   python3 script/resize_images.py --input-dir path/to/input_dir --output-dir path/to/output_dir --width 320

AI 调用示例：
- 按宽度压缩：python3 script/resize_images.py --input app/assets/images/photo.png --output app/assets/images/photo_compressed.png --width 800
- 按高度压缩：python3 script/resize_images.py --input app/assets/images/photo.png --output app/assets/images/photo_compressed.png --height 600
- 指定宽高（填满）：python3 script/resize_images.py --input app/assets/images/photo.png --output app/assets/images/photo_compressed.png --width 800 --height 600 --fit-mode fit
- 批量处理：python3 script/resize_images.py --input-dir app/assets/images --output-dir app/assets/images_compressed --width 1024
"""
import sys
import argparse
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("错误: 需要安装 Pillow 库")
    print("请运行: pip3 install --user --break-system-packages Pillow")
    sys.exit(1)

def resize_image(input_path: str, output_path: str, target_width: int = None, target_height: int = None, fit_mode: str = 'fit'):
    """
    调整图片尺寸，保持宽高比，确保尺寸为偶数

    Args:
        input_path: 输入图片路径
        output_path: 输出图片路径
        target_width: 目标宽度（None 表示不限制）
        target_height: 目标高度（None 表示不限制）
        fit_mode: 宽高都指定时的处理模式
            - 'fit': 等比缩放后裁剪，确保填满目标尺寸（默认）
            - 'fill': 等比缩放后填充，确保完整显示，空白处填充
            - 'stretch': 拉伸到目标尺寸，不保持宽高比

    Returns:
        bool: 处理是否成功
    """
    try:
        with Image.open(input_path) as img:
            original_width, original_height = img.size

            # 如果宽高都没指定，返回错误
            if target_width is None and target_height is None:
                print("✗ 错误: 必须指定宽度或高度至少一个")
                return False

            # 确保宽度和高度都是偶数
            if target_width is not None and target_width % 2 != 0:
                target_width += 1
            if target_height is not None and target_height % 2 != 0:
                target_height += 1

            # 情况1: 只指定宽度
            if target_width is not None and target_height is None:
                aspect_ratio = original_height / original_width
                new_width = target_width
                new_height = int(target_width * aspect_ratio)
                if new_height % 2 != 0:
                    new_height += 1
                resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

            # 情况2: 只指定高度
            elif target_height is not None and target_width is None:
                aspect_ratio = original_width / original_height
                new_height = target_height
                new_width = int(target_height * aspect_ratio)
                if new_width % 2 != 0:
                    new_width += 1
                resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

            # 情况3: 宽高都指定
            else:
                original_ratio = original_width / original_height
                target_ratio = target_width / target_height

                if fit_mode == 'stretch':
                    # 直接拉伸到目标尺寸
                    resized_img = img.resize((target_width, target_height), Image.Resampling.LANCZOS)

                elif fit_mode == 'fit':
                    # 等比缩放后裁剪（确保填满目标尺寸）
                    if original_ratio > target_ratio:
                        # 原图更宽，按高度缩放
                        scale = target_height / original_height
                        new_width = int(original_width * scale)
                        new_height = target_height
                    else:
                        # 原图更高，按宽度缩放
                        scale = target_width / original_width
                        new_width = target_width
                        new_height = int(original_height * scale)

                    # 确保是偶数
                    if new_width % 2 != 0:
                        new_width += 1
                    if new_height % 2 != 0:
                        new_height += 1

                    # 先等比缩放
                    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

                    # 如果尺寸不匹配，进行居中裁剪
                    if new_width != target_width or new_height != target_height:
                        left = (new_width - target_width) // 2
                        top = (new_height - target_height) // 2
                        right = left + target_width
                        bottom = top + target_height
                        resized_img = resized_img.crop((left, top, right, bottom))

                elif fit_mode == 'fill':
                    # 等比缩放后填充（确保完整显示）
                    if original_ratio > target_ratio:
                        # 原图更宽，按宽度缩放
                        scale = target_width / original_width
                        new_width = target_width
                        new_height = int(original_height * scale)
                    else:
                        # 原图更高，按高度缩放
                        scale = target_height / original_height
                        new_width = int(original_width * scale)
                        new_height = target_height

                    # 确保是偶数
                    if new_width % 2 != 0:
                        new_width += 1
                    if new_height % 2 != 0:
                        new_height += 1

                    # 等比缩放
                    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

                    # 创建目标尺寸的透明背景
                    final_img = Image.new('RGBA', (target_width, target_height), (0, 0, 0, 0))

                    # 居中粘贴
                    paste_x = (target_width - new_width) // 2
                    paste_y = (target_height - new_height) // 2
                    final_img.paste(resized_img, (paste_x, paste_y), resized_img if resized_img.mode == 'RGBA' else None)
                    resized_img = final_img

            # 确保输出目录存在
            Path(output_path).parent.mkdir(parents=True, exist_ok=True)

            # 保存图片，优化压缩
            resized_img.save(
                output_path,
                'PNG',
                optimize=True,
                compress_level=9
            )

            # 显示处理结果
            original_size = Path(input_path).stat().st_size
            new_size = Path(output_path).stat().st_size
            compression_ratio = (1 - new_size / original_size) * 100

            final_width, final_height = resized_img.size
            print(f"✓ {Path(input_path).name} -> {Path(output_path).name}")
            print(f"  原始: {original_width}x{original_height} ({original_size/1024:.1f}KB)")
            print(f"  新尺寸: {final_width}x{final_height} ({new_size/1024:.1f}KB)")
            if fit_mode != 'stretch' and target_width is not None and target_height is not None:
                print(f"  模式: {fit_mode}")
            print(f"  压缩率: {compression_ratio:.1f}%")
            print()

            return True
    except Exception as e:
        print(f"✗ 处理 {input_path} 时出错: {e}")
        return False

def process_single_image(input_path: str, output_path: str, target_width: int = None, target_height: int = None, fit_mode: str = 'fit'):
    """处理单个图片"""
    input_file = Path(input_path)
    if not input_file.exists():
        print(f"✗ 文件不存在: {input_path}")
        return False

    # 如果输出路径是目录，使用原文件名
    output_file = Path(output_path)
    if output_file.is_dir() or not output_file.suffix:
        output_file = output_file / input_file.name

    return resize_image(str(input_file), str(output_file), target_width, target_height, fit_mode)

def process_directory(input_dir: str, output_dir: str, target_width: int = None, target_height: int = None, pattern: str = "*.png", fit_mode: str = 'fit'):
    """批量处理目录中的所有图片"""
    input_path = Path(input_dir)
    output_path = Path(output_dir)

    if not input_path.exists():
        print(f"✗ 输入目录不存在: {input_dir}")
        return 0

    # 查找所有匹配的图片文件
    image_files = list(input_path.glob(pattern))

    if not image_files:
        print(f"✗ 在 {input_dir} 中未找到匹配 {pattern} 的图片")
        return 0

    print(f"找到 {len(image_files)} 张图片，开始处理...\n")

    success_count = 0
    for img_file in image_files:
        output_file = output_path / img_file.name
        if resize_image(str(img_file), str(output_file), target_width, target_height, fit_mode):
            success_count += 1

    return success_count

def main():
    """主函数：解析命令行参数并处理图片"""
    parser = argparse.ArgumentParser(
        description="图片压缩和调整分辨率工具",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例：
  # 按宽度压缩单个图片
  python3 script/resize_images.py --input photo.png --output photo_small.png --width 320

  # 按高度压缩单个图片
  python3 script/resize_images.py --input photo.png --output photo_small.png --height 240

  # 指定宽高（填满目标尺寸）
  python3 script/resize_images.py --input photo.png --output photo_small.png --width 320 --height 240 --fit-mode fit

  # 批量处理目录
  python3 script/resize_images.py --input-dir images/3.0x --output-dir images/2.0x --width 214

  # 处理特定格式
  python3 script/resize_images.py --input-dir images --output-dir images_compressed --width 800 --pattern "*.jpg"
        """
    )

    # 输入选项（互斥）
    input_group = parser.add_mutually_exclusive_group(required=True)
    input_group.add_argument(
        '--input',
        type=str,
        help='单个输入图片文件路径'
    )
    input_group.add_argument(
        '--input-dir',
        type=str,
        help='输入目录路径（批量处理）'
    )

    # 输出选项
    parser.add_argument(
        '--output',
        type=str,
        help='单个输出图片文件路径（与 --input 配合使用）'
    )
    parser.add_argument(
        '--output-dir',
        type=str,
        help='输出目录路径（与 --input-dir 配合使用）'
    )

    # 尺寸选项（至少指定一个）
    parser.add_argument(
        '--width',
        type=int,
        default=None,
        help='目标宽度（像素），会自动调整为偶数'
    )
    parser.add_argument(
        '--height',
        type=int,
        default=None,
        help='目标高度（像素），会自动调整为偶数'
    )
    parser.add_argument(
        '--fit-mode',
        type=str,
        choices=['fit', 'fill', 'stretch'],
        default='fit',
        help='宽高都指定时的处理模式: fit=等比缩放后裁剪(填满), fill=等比缩放后填充(完整显示), stretch=拉伸(可能变形)'
    )
    parser.add_argument(
        '--pattern',
        type=str,
        default='*.png',
        help='批量处理时的文件匹配模式（默认: *.png）'
    )

    args = parser.parse_args()

    # 验证参数
    if args.width is None and args.height is None:
        print("错误: 必须指定 --width 或 --height 至少一个")
        sys.exit(1)

    # 如果只指定了宽度或高度，fit_mode 不需要
    if args.width is not None and args.height is not None:
        print(f"宽高都指定，使用模式: {args.fit_mode}")
        print(f"  fit: 等比缩放后裁剪，确保填满目标尺寸\n  fill: 等比缩放后填充，确保完整显示\n  stretch: 拉伸到目标尺寸（可能变形）\n")

    # 处理单个图片
    if args.input:
        if not args.output:
            print("错误: 使用 --input 时必须指定 --output")
            sys.exit(1)
        success = process_single_image(args.input, args.output, args.width, args.height, args.fit_mode)
        sys.exit(0 if success else 1)

    # 批量处理目录
    if args.input_dir:
        if not args.output_dir:
            print("错误: 使用 --input-dir 时必须指定 --output-dir")
            sys.exit(1)
        success_count = process_directory(args.input_dir, args.output_dir, args.width, args.height, args.pattern, args.fit_mode)
        print(f"\n处理完成: {success_count} 张图片")
        sys.exit(0 if success_count > 0 else 1)

if __name__ == "__main__":
    main()
