#!/usr/bin/env python3
"""
image_to_pixel_pet.py
Converts any high-resolution image of a character (like Rick, Morty, aliens)
into a clean, downsampled retro pixel-art sprite ready for OmaPets.

Usage:
    python3 tools/image_to_pixel_pet.py input.png output.png [--size 24] [--colors 16]
"""

import argparse
import os
import subprocess
import sys

def convert_image(input_path, output_path, size=24, colors=16, trim=True):
    if not os.path.exists(input_path):
        print(f"Error: input file '{input_path}' not found.", file=sys.stderr)
        sys.exit(1)

    # ImageMagick processing chain:
    # 1. -trim (optional: remove excess transparent border)
    # 2. -resize size x size with aspect ratio preserved
    # 3. -filter point (nearest-neighbor)
    # 4. -colors N +dither (quantize to clean retro palette without noise)
    
    cmd = ["magick", input_path]
    if trim:
        cmd.extend(["-trim", "+repage"])
    
    cmd.extend([
        "-background", "none",
        "-resize", f"{size}x{size}",
        "-gravity", "center",
        "-extent", f"{size}x{size}",
        "-filter", "point",
        "-colors", str(colors),
        "+dither",
        f"PNG32:{output_path}"
    ])
    
    try:
        subprocess.run(cmd, check=True)
        print(f"Converted '{input_path}' -> '{output_path}' ({size}x{size}, {colors} colors)")
    except subprocess.CalledProcessError as e:
        print(f"ImageMagick failed: {e}", file=sys.stderr)
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Convert any image to an OmaPets pixel-art sprite.")
    parser.add_argument("input", help="Path to input image (PNG/JPG)")
    parser.add_argument("output", help="Path to output PNG file")
    parser.add_argument("--size", type=int, default=24, help="Target sprite size in pixels (default: 24)")
    parser.add_argument("--colors", type=int, default=16, help="Color quantization limit (default: 16)")
    parser.add_argument("--no-trim", action="store_true", help="Do not trim empty transparent borders")
    
    args = parser.parse_args()
    convert_image(args.input, args.output, size=args.size, colors=args.colors, trim=not args.no_trim)

if __name__ == "__main__":
    main()
