import csv
import io
from typing import List

from .decoder import DecodedSpd
from .timings import compute_profile_from_data


def export_csv(results: List[DecodedSpd], filepath: str) -> str:
    rows = _build_rows(results)
    with open(filepath, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)
    return filepath


def export_csv_to_string(results: List[DecodedSpd]) -> str:
    rows = _build_rows(results)
    output = io.StringIO()
    writer = csv.DictWriter(output, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)
    return output.getvalue()


def _build_rows(results: List[DecodedSpd]) -> List[dict]:
    rows = []
    for r in results:
        row = {
            "slot": r.slot,
            "memory_type": r.memory_type,
            "manufacturer": r.manufacturer,
            "part_number": r.part_number,
            "serial": r.serial_number,
        }
        if r.parsed:
            p = r.parsed
            row.update({
                "spd_revision": p.spd_revision,
                "capacity_mb": p.module_capacity_mb,
                "module_type": p.module_type,
                "bus_width": p.module_bus_width,
                "ranks": p.ranks,
                "banks": p.sdram_banks,
                "voltage": p.voltage_level,
                "rows": p.sdram_rows,
                "columns": p.sdram_columns,
                "chip_count": p.chip_count,
                "organization": p.module_organization,
                "crc_valid": r.crc_base_valid,
            })
        if r.error:
            row["error"] = r.error
        rows.append(row)
    return rows
