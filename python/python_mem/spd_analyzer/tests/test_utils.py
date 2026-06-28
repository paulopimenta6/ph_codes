import pytest
from spd_analyzer.utils import (
    convert_i2cdump_text_to_binary,
    decode_ascii,
    detect_spd_format,
    parse_timing_ps,
)


def test_decode_ascii():
    data = b"MODULE\x00\x00\x00TEST"
    assert decode_ascii(data, 0, 6) == "MODULE"
    assert decode_ascii(data, 9, 4) == "TEST"


def test_convert_text_short():
    text = "00: 92 12 0b 03 04 21 02 09 03 11 01 08 0a 00 fe 00"
    result = convert_i2cdump_text_to_binary(text)
    assert result is not None
    assert len(result) == 16
    assert result[0] == 0x92
    assert result[2] == 0x0B


def test_detect_raw_binary():
    data = bytes([0x00, 0x01, 0x0B] + [0x00] * 253)
    assert detect_spd_format(data) == "raw_binary"


def test_detect_text_format():
    data = b"    0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f"
    assert detect_spd_format(data) == "i2cdump_text"
