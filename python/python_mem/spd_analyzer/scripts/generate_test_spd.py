#!/usr/bin/env python3
"""Generate synthetic test SPD data for DDR3 modules."""

import sys
from pathlib import Path


def _make_spd(data: bytearray) -> bytes:
    return bytes(data[:256])


def make_ddr3_spd_1600_8gb() -> bytes:
    data = bytearray(256)

    data[0] = 0x92
    data[1] = 0x10
    data[2] = 0x0B
    data[3] = 0x03
    data[4] = 0x05
    data[5] = 0x21
    data[6] = 0x00
    data[7] = 0x01
    data[8] = 0x13
    data[9] = 0x01
    data[10] = 0x01
    data[11] = 0x03
    data[12] = 0x00
    data[13] = 0x00
    data[14] = 0x80
    data[15] = 0x00

    data[17] = 0xFF
    data[18] = 0x07

    tAA_mtb = int(13125 / 31.25) << 2
    data[20] = tAA_mtb & 0xFF
    data[21] = (tAA_mtb >> 8) & 0xFF
    data[22] = tAA_mtb >> 16

    tRCD_mtb = int(13125 / 31.25) << 2
    data[23] = tRCD_mtb & 0xFF
    data[24] = (tRCD_mtb >> 8) & 0xFF
    data[25] = tRCD_mtb >> 16

    tRP_mtb = int(13125 / 31.25) << 2
    data[26] = tRP_mtb & 0xFF
    data[27] = (tRP_mtb >> 8) & 0xFF
    data[28] = tRP_mtb >> 16

    tRAS_mtb = int(36000 / 31.25) << 2
    data[29] = tRAS_mtb & 0xFF
    data[30] = (tRAS_mtb >> 8) & 0xFF
    data[31] = tRAS_mtb >> 16

    data[117] = 0x01
    data[118] = 0xCE
    data[122] = 0x03
    data[123] = 0x9E
    data[124] = 0x85
    data[125] = 0x0E

    pn = b'M471B1G73QH0-YK0\x00\x00\x00\x00\x00\x00\x00\x00'
    for i, b in enumerate(pn[:18]):
        data[128 + i] = b

    data[148] = 0x28
    data[149] = 0x14

    return _make_spd(data)


def make_ddr3_spd_1333_4gb() -> bytes:
    data = bytearray(256)

    data[0] = 0x92
    data[1] = 0x10
    data[2] = 0x0B
    data[3] = 0x03
    data[4] = 0x04
    data[5] = 0x21
    data[6] = 0x00
    data[7] = 0x01
    data[8] = 0x13
    data[9] = 0x01
    data[10] = 0x00
    data[11] = 0x03
    data[12] = 0x00
    data[13] = 0x00
    data[14] = 0x80
    data[15] = 0x00

    data[17] = 0xFC
    data[18] = 0x02

    tAA_mtb = int(13500 / 31.25) << 2
    data[20] = tAA_mtb & 0xFF
    data[21] = (tAA_mtb >> 8) & 0xFF
    data[22] = tAA_mtb >> 16

    tRCD_mtb = int(13500 / 31.25) << 2
    data[23] = tRCD_mtb & 0xFF
    data[24] = (tRCD_mtb >> 8) & 0xFF
    data[25] = tRCD_mtb >> 16

    tRP_mtb = int(13500 / 31.25) << 2
    data[26] = tRP_mtb & 0xFF
    data[27] = (tRP_mtb >> 8) & 0xFF
    data[28] = tRP_mtb >> 16

    tRAS_mtb = int(36000 / 31.25) << 2
    data[29] = tRAS_mtb & 0xFF
    data[30] = (tRAS_mtb >> 8) & 0xFF
    data[31] = tRAS_mtb >> 16

    data[117] = 0x01
    data[118] = 0xCE

    pn = b'M471B5273DH0-CH9\x00\x00\x00\x00\x00\x00\x00\x00\x00'
    for i, b in enumerate(pn[:18]):
        data[128 + i] = b

    data[148] = 0x2A
    data[149] = 0x15

    return _make_spd(data)


def main():
    output_dir = sys.argv[1] if len(sys.argv) > 1 else "tests/data"
    out = Path(output_dir)
    out.mkdir(parents=True, exist_ok=True)

    for name, fn in [("dimm0.bin", make_ddr3_spd_1600_8gb),
                     ("dimm1.bin", make_ddr3_spd_1333_4gb)]:
        path = out / name
        path.write_bytes(fn())
        print(f"  → {path} ({path.stat().st_size} bytes)")

    print()
    print("Test SPD files generated!")
    print(f"Run: spd-analyzer decode -i {output_dir}")


if __name__ == "__main__":
    main()
