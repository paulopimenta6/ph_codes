from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple

from .jedec import lookup_manufacturer_by_id
from .parser import SpdDdr3Parsed, parse_spd
from .validators import validate_ddr3_crc


@dataclass
class DecodedSpd:
    slot: str
    raw_bytes: bytes
    parsed: Optional[SpdDdr3Parsed] = None
    error: Optional[str] = None

    crc_base_valid: Optional[bool] = None
    crc_extra_valid: Optional[bool] = None

    @property
    def memory_type(self) -> str:
        if self.parsed:
            return self.parsed.memory_type
        mem_code = self.raw_bytes[2] if len(self.raw_bytes) > 2 else 0
        from .parser import SPD_MEMORY_TYPES
        return SPD_MEMORY_TYPES.get(mem_code, f"Unknown ({mem_code:02X})")

    @property
    def is_ddr3(self) -> bool:
        return len(self.raw_bytes) > 2 and self.raw_bytes[2] == 0x0B

    @property
    def manufacturer(self) -> str:
        if self.parsed:
            return self.parsed.manufacturer_name
        if len(self.raw_bytes) > 118:
            return lookup_manufacturer_by_id(self.raw_bytes[117], self.raw_bytes[118])
        return "Unknown"

    @property
    def part_number(self) -> str:
        if self.parsed:
            return self.parsed.part_number
        if len(self.raw_bytes) > 145:
            return self.raw_bytes[128:146].decode("ascii", errors="replace").rstrip("\x00").rstrip()
        return ""

    @property
    def serial_number(self) -> str:
        if self.parsed:
            return self.parsed.serial_number
        if len(self.raw_bytes) > 125:
            return "".join(f"{b:02X}" for b in self.raw_bytes[122:125])
        return ""

    @property
    def capacity_mb(self) -> int:
        if self.parsed:
            return self.parsed.module_capacity_mb
        return 0

    @property
    def capacity_gb(self) -> float:
        return self.capacity_mb / 1024.0 if self.capacity_mb else 0.0


def decode_spd(data: bytes, slot: str = "Slot A") -> DecodedSpd:
    result = DecodedSpd(slot=slot, raw_bytes=data)

    parsed = parse_spd(data)
    if parsed is None:
        result.error = "Unsupported memory type or invalid SPD data"
        return result

    result.parsed = parsed

    if result.is_ddr3 and len(data) >= 256:
        base_crc, extra_crc = validate_ddr3_crc(data)
        result.crc_base_valid = base_crc.valid
        result.crc_extra_valid = extra_crc.valid

    return result


def decode_multiple(spd_data: Dict[str, bytes]) -> List[DecodedSpd]:
    results = []
    for slot, data in spd_data.items():
        results.append(decode_spd(data, slot))
    return results


def get_summary(decoded: DecodedSpd) -> Dict[str, Any]:
    summary: Dict[str, Any] = {
        "slot": decoded.slot,
        "memory_type": decoded.memory_type,
        "manufacturer": decoded.manufacturer,
        "part_number": decoded.part_number,
        "serial": decoded.serial_number,
    }

    if decoded.parsed:
        p = decoded.parsed
        summary.update({
            "capacity_mb": p.module_capacity_mb,
            "capacity_gb": round(p.module_capacity_mb / 1024.0, 1),
            "module_type": p.module_type,
            "bus_width": p.module_bus_width,
            "ranks": p.ranks,
            "voltage": p.voltage_level,
            "supported_voltages": p.supported_voltages,
            "organization": p.module_organization,
            "chip_count": p.chip_count,
            "spd_revision": p.spd_revision,
            "manufacturing_year": p.manufacturing_year,
            "manufacturing_week": p.manufacturing_week,
            "crc_base_valid": decoded.crc_base_valid,
            "crc_extra_valid": decoded.crc_extra_valid,
        })

    if decoded.error:
        summary["error"] = decoded.error

    return summary
