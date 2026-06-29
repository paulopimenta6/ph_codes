import json
from typing import Any, Dict, List, Optional

from .decoder import DecodedSpd
from .timings import compute_profile_from_data


def to_dict(decoded: DecodedSpd) -> Dict[str, Any]:
    result: Dict[str, Any] = {
        "slot": decoded.slot,
        "memory_type": decoded.memory_type,
    }

    if decoded.error:
        result["error"] = decoded.error
        return result

    p = decoded.parsed
    if p is None:
        return result

    result.update({
        "spd_size": p.spd_size,
        "spd_revision": p.spd_revision,
        "memory_type_code": hex(p.memory_type_code),
        "module_type": p.module_type,
        "module_type_code": hex(p.module_type_code),
        "capacity_mb": p.module_capacity_mb,
        "capacity_gb": round(p.module_capacity_mb / 1024.0, 2),
        "bus_width": p.module_bus_width,
        "ranks": p.ranks,
        "banks": p.sdram_banks,
        "voltage": p.voltage_level,
        "supported_voltages": p.supported_voltages,
        "manufacturer": p.manufacturer_name,
        "manufacturer_id": [hex(x) for x in p.manufacturer_id],
        "part_number": p.part_number,
        "serial_number": p.serial_number,
        "revision_code": [hex(x) for x in p.revision_code],
        "organization": {
            "ranks": p.ranks,
            "bus_width": p.module_bus_width,
            "chip_width": p.sdram_width_bits,
            "chip_count": p.chip_count,
            "rows": p.sdram_rows,
            "columns": p.sdram_columns,
            "density": p.sdram_density_mb,
        },
        "crc": {
            "valid": decoded.crc_base_valid,
            "crc_extra_valid": decoded.crc_extra_valid,
        },
        "timings": {
            "taa_ps": round(p.tAA_min_ps, 1),
            "trcd_ps": round(p.tRCD_min_ps, 1),
            "trp_ps": round(p.tRP_min_ps, 1),
            "tras_ps": round(p.tRAS_min_ps, 1),
            "trc_ps": round(p.tRC_min_ps, 1),
            "trfc_ps": round(p.tRFC_min_ps, 1),
            "twr_ps": round(p.tWR_min_ps, 1),
            "twtr_ps": round(p.tWTR_min_ps, 1),
            "tfaw_ps": round(p.tFAW_min_ps, 1),
        },
        "cas_latencies": p.cas_latencies,
    })

    profiles = compute_profile_from_data(p)
    result["jedec_profiles"] = [
        {
            "speed_mts": prof.speed_mts,
            "frequency_mhz": prof.frequency_mhz,
            "cas": prof.cas,
            "trcd": prof.tRCD,
            "trp": prof.tRP,
            "tras": prof.tRAS,
            "trc": prof.tRC,
            "timing": prof.timing_string,
        }
        for prof in profiles
    ]

    if p.manufacturing_year or p.manufacturing_week:
        result["manufacturing_date"] = {}
        if p.manufacturing_year:
            result["manufacturing_date"]["year"] = p.manufacturing_year
        if p.manufacturing_week:
            result["manufacturing_date"]["week"] = p.manufacturing_week

    return result


def export_json(results: List[DecodedSpd], filepath: str) -> str:
    data = {
        "spd_analyzer_version": "1.0",
        "modules": [to_dict(r) for r in results],
    }
    with open(filepath, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    return filepath


def export_json_to_string(results: List[DecodedSpd]) -> str:
    data = {
        "spd_analyzer_version": "1.0",
        "modules": [to_dict(r) for r in results],
    }
    return json.dumps(data, indent=2, ensure_ascii=False)
