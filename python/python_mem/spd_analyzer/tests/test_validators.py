import pytest
from spd_analyzer.validators import validate_ddr3_crc


def make_ddr3_spd() -> bytes:
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
    data[10] = 0x08
    data[11] = 0x03
    data[12] = 0x00
    data[13] = 0x00
    data[14] = 0x50
    data[15] = 0x00
    for i in range(16, 62):
        data[i] = 0x00
    data[62] = 0x00
    data[63] = 0x00
    data[117] = 0xCE
    data[118] = 0x01
    return bytes(data)


def test_crc_validation():
    spd = make_ddr3_spd()
    base_crc, extra_crc = validate_ddr3_crc(spd)
    assert base_crc is not None
    assert extra_crc is not None
