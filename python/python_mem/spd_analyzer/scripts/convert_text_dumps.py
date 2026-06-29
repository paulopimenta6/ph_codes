#!/usr/bin/env python3
"""
Convert existing i2cdump text-format SPD dumps to raw binary format.

Usage:
    python scripts/convert_text_dumps.py [input_dir] [output_dir]

If no arguments given, converts dimm*.bin in current directory to data/dimm*.bin
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from spd_analyzer.utils import convert_i2cdump_text_to_binary


def main():
    input_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    output_dir = sys.argv[2] if len(sys.argv) > 2 else "data"

    input_path = Path(input_dir)
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    converted = 0
    for f in sorted(input_path.glob("dimm*.bin")):
        text = f.read_text()
        binary = convert_i2cdump_text_to_binary(text)
        if binary and len(binary) >= 128:
            out_file = output_path / f.name
            out_file.write_bytes(binary[:256])
            print(f"  ✓ {f.name} → {out_file} ({len(binary[:256])} bytes)")
            converted += 1
        else:
            print(f"  ✗ {f.name}: could not parse or too short ({len(binary or [])} bytes)")

    print(f"\nConverted {converted} file(s) to {output_dir}/")
    print("Run 'spd-analyzer decode' to decode them.")


if __name__ == "__main__":
    main()
