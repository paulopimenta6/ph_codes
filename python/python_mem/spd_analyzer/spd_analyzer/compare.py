from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple

from .decoder import DecodedSpd


@dataclass
class ComparisonCheck:
    name: str
    passed: bool
    detail: str = ""


@dataclass
class ComparisonResult:
    modules: List[DecodedSpd]
    checks: List[ComparisonCheck] = field(default_factory=list)
    compatible: bool = False

    @property
    def all_pass(self) -> bool:
        return all(c.passed for c in self.checks)


def compare_modules(results: List[DecodedSpd]) -> ComparisonResult:
    comp = ComparisonResult(modules=results)

    if len(results) < 2:
        comp.checks.append(ComparisonCheck(
            name="General", passed=False, detail="Need at least 2 modules"
        ))
        comp.compatible = False
        return comp

    p0 = results[0].parsed
    p1 = results[1].parsed

    if p0 is None or p1 is None:
        comp.checks.append(ComparisonCheck(
            name="General", passed=False, detail="Cannot parse one or both modules"
        ))
        comp.compatible = False
        return comp

    capacity_ok = p0.module_capacity_mb == p1.module_capacity_mb
    comp.checks.append(ComparisonCheck(
        name="Capacity",
        passed=capacity_ok,
        detail=f"{p0.module_capacity_mb} MB vs {p1.module_capacity_mb} MB",
    ))

    timing_ok = (
        abs(p0.tAA_min_ps - p1.tAA_min_ps) <= 1 and
        abs(p0.tRCD_min_ps - p1.tRCD_min_ps) <= 1 and
        abs(p0.tRP_min_ps - p1.tRP_min_ps) <= 1
    )
    comp.checks.append(ComparisonCheck(
        name="Timings",
        passed=timing_ok,
        detail=f"tAA: {p0.tAA_min_ps:.0f}/{p1.tAA_min_ps:.0f} ps",
    ))

    voltage_ok = p0.voltage_level == p1.voltage_level
    comp.checks.append(ComparisonCheck(
        name="Voltage",
        passed=voltage_ok,
        detail=f"{p0.voltage_level} vs {p1.voltage_level}",
    ))

    jedec_ok = set(p0.cas_latencies) == set(p1.cas_latencies)
    comp.checks.append(ComparisonCheck(
        name="JEDEC Profiles",
        passed=jedec_ok,
        detail=f"CLs: {p0.cas_latencies} vs {p1.cas_latencies}",
    ))

    rank_ok = p0.ranks == p1.ranks
    comp.checks.append(ComparisonCheck(
        name="Rank",
        passed=rank_ok,
        detail=f"{p0.ranks}R vs {p1.ranks}R",
    ))

    crc_ok = results[0].crc_base_valid == results[1].crc_base_valid
    comp.checks.append(ComparisonCheck(
        name="CRC",
        passed=crc_ok,
        detail=f"{results[0].crc_base_valid} vs {results[1].crc_base_valid}",
    ))

    spd_ok = p0.spd_revision == p1.spd_revision
    comp.checks.append(ComparisonCheck(
        name="SPD Revision",
        passed=spd_ok,
        detail=f"{p0.spd_revision} vs {p1.spd_revision}",
    ))

    comp.compatible = comp.all_pass
    return comp
