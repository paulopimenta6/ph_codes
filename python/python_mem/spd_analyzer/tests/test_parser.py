import pytest
from spd_analyzer.parser import parse_spd, parse_spd_revision


def make_ddr3_spd():
    data = bytearray(256)
    data[0] = 0x00
    data[1] = 0x10
    data[2] = 0x0B
    data[3] = 0x03
    data[4] = 0x04
    data[5] = 0x21
    data[6] = 0x00
    data[7] = 0x01
    data[8] = 0x11
    data[9] = 0x00
    data[10] = 0x00
    data[11] = 0x03
    data[12] = 0x00
    data[13] = 0x00
    data[14] = 0x30
    data[15] = 0x00
    data[17] = 0xFF
    data[18] = 0x07
    data[20] = 0xC8
    data[21] = 0x00
    data[22] = 0x00
    data[23] = 0x4B
    data[24] = 0x00
    data[25] = 0x00
    data[26] = 0x4B
    data[27] = 0x00
    data[28] = 0x00
    data[117] = 0xCE
    data[118] = 0x01
    data[122] = 0x12
    data[123] = 0x34
    data[124] = 0x56
    data[128:146] = b"M471B1G73QH0-YK0\x00\x00"
    data[148] = 0x28
    data[149] = 0x14
    return bytes(data)


def test_parse_spd_revision():
    assert parse_spd_revision(0x10) == "1.0"
    assert parse_spd_revision(0x11) == "1.1"
    assert parse_spd_revision(0x20) == "2.0"


def test_parse_ddr3():
    spd = make_ddr3_spd()
    parsed = parse_spd(spd)
    assert parsed is not None
    assert parsed.memory_type == "DDR3 SDRAM"
    assert "Samsung" in parsed.manufacturer_name
    assert parsed.part_number == "M471B1G73QH0-YK0"
    assert parsed.serial_number == "123456"
    assert parsed.module_type == "SO-DIMM"
