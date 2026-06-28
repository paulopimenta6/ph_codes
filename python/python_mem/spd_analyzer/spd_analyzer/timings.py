import math
from dataclasses import dataclass
from typing import List, Optional

from .parser import SpdDdr3Parsed


DDR3_STANDARD_SPEEDS = [
    (800, "DDR3-800"),
    (1066, "DDR3-1066"),
    (1333, "DDR3-1333"),
    (1600, "DDR3-1600"),
    (1866, "DDR3-1866"),
    (2133, "DDR3-2133"),
]


@dataclass
class TimingProfile:
    label: str
    speed_mts: int
    freq_mhz: int
    cas: int
    tRCD: int
    tRP: int
    tRAS: int
    timing_string: str


def compute_profiles(parsed: SpdDdr3Parsed) -> List[TimingProfile]:
    ps_per_cycle = parsed.tAA_min_ps
    if ps_per_cycle <= 0 or ps_per_cycle > 50000:
        return []

    tAA_ns = parsed.tAA_min_ps / 1000.0
    tRCD_ns = parsed.tRCD_min_ps / 1000.0
    tRP_ns = parsed.tRP_min_ps / 1000.0
    tRAS_ns = parsed.tRAS_min_ps / 1000.0

    profiles = []
    for mts, label in DDR3_STANDARD_SPEEDS:
        mhz = mts // 2
        cycle_ns = 2000.0 / mts

        min_cl = math.ceil(tAA_ns / cycle_ns) if cycle_ns > 0 else 0
        cas = None
        for cl in sorted(parsed.cas_latencies):
            if cl >= min_cl:
                cas = cl
                break
        if cas is None and parsed.cas_latencies:
            cas = max(parsed.cas_latencies)

        if cas is None or cycle_ns <= 0:
            continue

        trcd = max(1, math.ceil(tRCD_ns / cycle_ns))
        trp = max(1, math.ceil(tRP_ns / cycle_ns))
        tras = max(1, math.ceil(tRAS_ns / cycle_ns))

        profiles.append(TimingProfile(
            label=label,
            speed_mts=mts,
            freq_mhz=mhz,
            cas=cas,
            tRCD=trcd,
            tRP=trp,
            tRAS=tras,
            timing_string=f"{cas}-{trcd}-{trp}",
        ))

    valid = [p for p in profiles if p.cas >= 5 and p.tRCD >= 3 and p.tRP >= 3]
    return valid[:4]


def compute_profile_from_data(parsed: SpdDdr3Parsed) -> List[TimingProfile]:
    return compute_profiles(parsed)
