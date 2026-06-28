from pathlib import Path
from typing import List, Optional, Tuple

DDR3_SPD_SIZE = 256


def decode_ascii(data: bytes, start: int, length: int) -> str:
    result = data[start : start + length].decode("ascii", errors="replace")
    return result.strip("\x00").strip()


def hex_bytes(data: bytes, start: int, length: int, sep: str = " ") -> str:
    return sep.join(f"{b:02X}" for b in data[start : start + length])


def checksum_crc(data: bytes, length: int = 256) -> Tuple[int, int]:
    total = sum(data[:length]) & 0xFF
    xor = 0
    for b in data[:length]:
        xor ^= b
    return total, xor


def parse_timing_ps(data: bytes, byte_low: int, byte_mid: int, byte_high: int) -> float:
    value = (data[byte_high] << 16) | (data[byte_mid] << 8) | data[byte_low]
    return value / 256.0 if value > 0 else 0.0


def parse_timing_ps_16bit(data: bytes, byte_low: int, byte_high: int) -> float:
    value = (data[byte_high] << 8) | data[byte_low]
    return value / 256.0 if value > 0 else 0.0


def bits_to_mhz(rate_mts: float) -> float:
    return rate_mts / 2.0


def ns_to_ps(ns: float) -> float:
    return ns * 1000.0


def parse_mfg_date(year_byte: int, week_byte: int) -> Tuple[Optional[int], Optional[int]]:
    year = None
    week = None
    if year_byte >= 0x00 and year_byte <= 0x7F:
        year = 2000 + (year_byte >> 1)
    if week_byte >= 0x01 and week_byte <= 0x36:
        week = week_byte
    return year, week


def find_i2cdump_text_files(directory: str = ".") -> List[Path]:
    files = []
    for f in sorted(Path(directory).glob("dimm*.bin")):
        if f.is_file():
            files.append(f)
    return files


def convert_i2cdump_text_to_binary(text: str) -> Optional[bytes]:
    lines = text.strip().split("\n")
    raw_bytes = bytearray()
    for line in lines:
        line = line.strip()
        if not line or ":" not in line:
            continue
        try:
            hex_part = line.split(":")[1].strip()
            parts = hex_part.split()
            for p in parts:
                if len(p) == 2:
                    try:
                        raw_bytes.append(int(p, 16))
                    except ValueError:
                        pass
        except (IndexError, ValueError):
            continue
    return bytes(raw_bytes) if raw_bytes else None


def detect_spd_format(data: bytes) -> str:
    if len(data) < 4:
        return "unknown"
    if data[0:1] in (b"\x00", b"\x01", b"\x02", b"\x03", b"\x04", b"\x11", b"\x12", b"\x13"):
        if len(data) >= 256 and data[2] in (0x0B, 0x0C, 0x11, 0x12, 0x13):
            return "raw_binary"
    if data[0:4] == b"    " or b":" in data[:80]:
        return "i2cdump_text"
    return "raw_binary"
