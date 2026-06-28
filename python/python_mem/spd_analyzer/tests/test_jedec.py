import pytest
from spd_analyzer.jedec import lookup_manufacturer, lookup_manufacturer_by_id


def test_samsung():
    result = lookup_manufacturer_by_id(0xCE, 0x00)
    assert "Samsung" in result


def test_hynix():
    result = lookup_manufacturer_by_id(0xAD, 0x00)
    assert "SK hynix" in result or "Hynix" in result


def test_kingston():
    result = lookup_manufacturer_by_id(0x98, 0x01)
    assert "Kingston" in result


def test_unknown():
    result = lookup_manufacturer_by_id(0xFF, 0xFF)
    assert "Unknown" in result


def test_continuation_codes():
    result = lookup_manufacturer_by_id(0x01, 0x14)
    assert "Corsair" in result
