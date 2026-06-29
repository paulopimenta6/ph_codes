from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple


SPD_MEMORY_TYPES: Dict[int, str] = {
    0x00: "Undefined",
    0x01: "FPM DRAM",
    0x02: "EDO DRAM",
    0x03: "Pipelined Nibble",
    0x04: "SDRAM",
    0x05: "ROM",
    0x06: "DDR SGRAM",
    0x07: "DDR SDRAM",
    0x08: "DDR2 SDRAM",
    0x09: "DDR2 SDRAM",
    0x0A: "DDR2 SDRAM",
    0x0B: "DDR3 SDRAM",
    0x0C: "DDR4 SDRAM",
    0x11: "DDR5 SDRAM",
    0x12: "LPDDR5 SDRAM",
    0x13: "LPDDR5X SDRAM",
}


@dataclass
class SpdDdr3Timing:
    cycle_time_mtb: float
    cas_latencies: List[int]
    tAA_ps: float
    tRCD_ps: float
    tRP_ps: float
    tRAS_ps: float
    tRC_ps: float
    tRFC_ps: float
    tWR_ps: float
    tWTR_ps: float
    tFAW_ps: float

    def mtb_to_mhz(self) -> float:
        return 1000.0 / self.cycle_time_mtb if self.cycle_time_mtb > 0 else 0.0

    def mtb_to_mts(self) -> float:
        return 2.0 * self.mtb_to_mhz() if self.cycle_time_mtb > 0 else 0.0


@dataclass
class SpdDdr3Profile:
    speed_mts: int
    cas: int
    tRCD: int
    tRP: int
    tRAS: int


@dataclass
class SpdDdr3Parsed:
    spd_size: int
    spd_revision: str
    memory_type: str
    memory_type_code: int
    module_type: str
    module_type_code: int

    sdram_density_bits: int
    sdram_density_mbits: int
    sdram_banks: int
    sdram_rows: int
    sdram_columns: int
    sdram_width_bits: int

    ranks: int
    module_bus_width: int
    module_bus_extension: int

    mtb_ps: float
    ftb_ps: float

    medium_timebase: float
    fine_timebase: float

    tAA_min_ps: float
    tRCD_min_ps: float
    tRP_min_ps: float
    tRAS_min_ps: float
    tRC_min_ps: float
    tRFC_min_ps: float
    tWR_min_ps: float
    tWTR_min_ps: float
    tFAW_min_ps: float
    tRTTP_min_ps: float

    cas_latencies: List[int]
    voltage_level: str
    supported_voltages: List[str]

    manufacturer_id: Tuple[int, int]
    manufacturer_name: str
    manufacturing_location: int
    manufacturing_year: Optional[int]
    manufacturing_week: Optional[int]
    serial_number: str
    part_number: str
    revision_code: Tuple[int, int]

    sdram_density_mb: str
    module_capacity_mb: int
    module_organization: str
    chip_count: int

    crc_base_valid: Optional[bool] = None
    crc_extra_valid: Optional[bool] = None

    profiles: List[SpdDdr3Profile] = field(default_factory=list)
    raw_bytes: bytes = field(default_factory=bytes)
    features: Dict[str, bool] = field(default_factory=dict)


def parse_spd_revision(byte_val: int) -> str:
    major = (byte_val >> 4) & 0x0F
    minor = byte_val & 0x0F
    return f"{major}.{minor}"


def parse_ddr3(data: bytes, mfr_name: str) -> SpdDdr3Parsed:
    sdram_density_mbits = 256 << (data[4] & 0x07)

    sdram_banks = 8
    row_addr_table = {0: 12, 1: 13, 2: 14, 3: 15, 4: 16}
    col_addr_table = {0: 8, 1: 9, 2: 10, 3: 11}
    rows = row_addr_table.get((data[5] >> 1) & 0x07, 15)
    cols = col_addr_table.get((data[5] >> 4) & 0x07, 10)

    sdram_width_bits = {0: 4, 1: 8, 2: 16, 3: 32}.get(data[7] & 0x07, 8)

    ranks_raw = (data[10] >> 3) & 0x07
    ranks = ranks_raw + 1
    if ranks_raw == 0:
        ranks = 1
    elif ranks_raw == 1:
        ranks = 2
    elif ranks_raw == 2:
        ranks = 3
    elif ranks_raw == 3:
        ranks = 4

    bus_width_map = {0: 8, 1: 16, 2: 32, 3: 64, 4: 128}
    primary_bus = bus_width_map.get(data[11] & 0x07, 64)
    bus_extension = (data[12] & 0x07) * 8
    module_bus_width = primary_bus + bus_extension

    mitb = data[8] & 0x0F
    mftb = (data[8] >> 4) & 0x0F
    mtb_ps = 125.0 / (2 ** (mitb - 1)) if mitb > 0 else 125.0
    ftb_ps = 1.0 / (2 ** (mftb - 1)) if mftb > 0 else 1.0

    tAA_ps = parse_timing(data, 20, 21, 22, mtb_ps, ftb_ps)
    tRCD_ps = parse_timing(data, 23, 24, 25, mtb_ps, ftb_ps)
    tRP_ps = parse_timing(data, 26, 27, 28, mtb_ps, ftb_ps)
    tRAS_ps = parse_timing(data, 29, 30, 31, mtb_ps, ftb_ps)
    tRC_ps = parse_timing(data, 32, 33, 34, mtb_ps, ftb_ps)
    tRFC_ps = parse_timing(data, 35, 36, 37, mtb_ps, ftb_ps)
    tWR_ps = parse_timing16(data, 38, 39, mtb_ps, ftb_ps)
    tWTR_ps = parse_timing16(data, 40, 41, mtb_ps, ftb_ps)
    tRTTP_ps = parse_timing16(data, 42, 43, mtb_ps, ftb_ps)
    tFAW_ps = parse_timing16(data, 44, 45, mtb_ps, ftb_ps)

    cas_lsb = data[17]
    cas_msb = data[18]
    cas = []
    for i in range(16):
        cl = i + 4
        if cl > 25:
            break
        if i < 8:
            if cas_lsb & (1 << i):
                cas.append(cl)
        else:
            if cas_msb & (1 << (i - 8)):
                cas.append(cl)

    volt_code = data[9] & 0x07
    volt_map = {0: "1.50V", 1: "1.35V", 2: "1.25V", 3: "1.20V"}
    voltage_level = volt_map.get(volt_code, f"Unknown ({volt_code})")

    supported_voltages = []
    vmask = data[9] >> 4
    if vmask & 0x01:
        supported_voltages.append("1.50V")
    if vmask & 0x02:
        supported_voltages.append("1.35V")
    if vmask & 0x04:
        supported_voltages.append("1.25V")
    if vmask & 0x08:
        supported_voltages.append("1.20V")
    if not supported_voltages:
        supported_voltages.append(voltage_level)

    manufacturer_id = (data[117], data[118])
    mfg_location = data[119]

    mfg_year = None
    mfg_week = None
    if len(data) > 149:
        if 0x00 <= data[148] <= 0x7F:
            mfg_year = 2000 + (data[148] >> 1)
        if 1 <= data[149] <= 0x36:
            mfg_week = data[149]

    serial = "".join(f"{b:02X}" for b in data[122:125])
    part_number = data[128:146].decode("ascii", errors="replace").rstrip("\x00").rstrip()
    revision = (data[146], data[147])

    module_type_map = {
        0x01: "RDIMM", 0x02: "UDIMM", 0x03: "SO-DIMM",
        0x04: "Micro-DIMM", 0x05: "Mini-RDIMM", 0x06: "Mini-UDIMM",
        0x08: "72b-SO-CDIMM", 0x09: "72b-SO-RDIMM", 0x0B: "RDIMM",
        0x0C: "LRDIMM",
    }
    module_type_code = data[3]
    module_type = module_type_map.get(module_type_code, f"Type {module_type_code:02X}")

    chip_count = module_bus_width // sdram_width_bits if sdram_width_bits > 0 else 0
    total_mbits = sdram_density_mbits * chip_count * ranks
    module_capacity_mb = total_mbits // 8
    module_organization = f"{ranks}R x{sdram_width_bits}"

    parsed = SpdDdr3Parsed(
        spd_size=data[0],
        spd_revision=parse_spd_revision(data[1]),
        memory_type=SPD_MEMORY_TYPES.get(data[2], f"Unknown ({data[2]:02X})"),
        memory_type_code=data[2],
        module_type=module_type,
        module_type_code=module_type_code,
        sdram_density_bits=sdram_density_mbits * 8,
        sdram_density_mbits=sdram_density_mbits,
        sdram_banks=sdram_banks,
        sdram_rows=rows,
        sdram_columns=cols,
        sdram_width_bits=sdram_width_bits,
        ranks=ranks,
        module_bus_width=module_bus_width,
        module_bus_extension=bus_extension,
        mtb_ps=mtb_ps,
        ftb_ps=ftb_ps,
        medium_timebase=mtb_ps,
        fine_timebase=ftb_ps,
        tAA_min_ps=tAA_ps,
        tRCD_min_ps=tRCD_ps,
        tRP_min_ps=tRP_ps,
        tRAS_min_ps=tRAS_ps,
        tRC_min_ps=tRC_ps,
        tRFC_min_ps=tRFC_ps,
        tWR_min_ps=tWR_ps,
        tWTR_min_ps=tWTR_ps,
        tFAW_min_ps=tFAW_ps,
        tRTTP_min_ps=tRTTP_ps,
        cas_latencies=cas,
        voltage_level=voltage_level,
        supported_voltages=supported_voltages,
        manufacturer_id=manufacturer_id,
        manufacturer_name=mfr_name,
        manufacturing_location=mfg_location,
        manufacturing_year=mfg_year,
        manufacturing_week=mfg_week,
        serial_number=serial,
        part_number=part_number,
        revision_code=revision,
        sdram_density_mb=f"{sdram_density_mbits} Mb",
        module_capacity_mb=module_capacity_mb,
        module_organization=module_organization,
        chip_count=chip_count,
        raw_bytes=data,
        profiles=_compute_profiles(data, cas, mtb_ps),
    )
    return parsed


def parse_timing(data: bytes, lo: int, mid: int, hi: int, mtb: float, ftb: float) -> float:
    val = (data[hi] << 16) | (data[mid] << 8) | data[lo]
    if val == 0:
        return 0.0
    mtb_val = (val >> 2) & 0x3FFFF
    ftb_val = val & 0x03
    return (mtb_val * mtb) + (ftb_val * ftb / 4.0)


def parse_timing16(data: bytes, lo: int, hi: int, mtb: float, ftb: float) -> float:
    val = (data[hi] << 8) | data[lo]
    if val == 0:
        return 0.0
    mtb_val = (val >> 2) & 0x3FFF
    ftb_val = val & 0x03
    return (mtb_val * mtb) + (ftb_val * ftb / 4.0)


def _compute_profiles(data: bytes, cas_list: List[int], mtb_ps: float) -> List[SpdDdr3Profile]:
    profiles = []
    medium_speeds = [
        (14, 15),
    ]
    max_freq_mhz = 1000000.0 / mtb_ps if mtb_ps > 0 else 0
    speed_mts_list = [
        int(round(max_freq_mhz * 2 / 266 * 266)),
        int(round(max_freq_mhz * 2 / 200 * 200)),
        int(round(max_freq_mhz * 2 / 133 * 133)),
    ]
    speed_mts_list = sorted(set(s for s in speed_mts_list if s > 0), reverse=True)

    tAA_ps = parse_timing(data, 20, 21, 22, mtb_ps, 1.0)
    tRCD_ps = parse_timing(data, 23, 24, 25, mtb_ps, 1.0)
    tRP_ps = parse_timing(data, 26, 27, 28, mtb_ps, 1.0)
    tRAS_ps = parse_timing(data, 29, 30, 31, mtb_ps, 1.0)

    for mts in speed_mts_list:
        if mts < 400:
            continue
        cycle_ns = 2000.0 / mts if mts > 0 else 0
        best_cas = None
        for cl in sorted(cas_list, reverse=True):
            if cl * cycle_ns * 1000 >= tAA_ps:
                best_cas = cl
            else:
                break

        if best_cas is None and cas_list:
            best_cas = max(cas_list)

        if best_cas:
            trcd_cycles = max(1, int((tRCD_ps / 1000) / cycle_ns) if cycle_ns > 0 else 0) or 1
            trp_cycles = max(1, int((tRP_ps / 1000) / cycle_ns) if cycle_ns > 0 else 0) or 1
            tras_ns = tRAS_ps / 1000
            tras_cycles = max(1, int(tras_ns / cycle_ns) if cycle_ns > 0 else 0) or 1
            profiles.append(SpdDdr3Profile(
                speed_mts=mts,
                cas=best_cas,
                tRCD=int(tRCD_ps / 1000 / cycle_ns) if cycle_ns > 0 else 0,
                tRP=int(tRP_ps / 1000 / cycle_ns) if cycle_ns > 0 else 0,
                tRAS=int(tRAS_ps / 1000 / cycle_ns) if cycle_ns > 0 else 0,
            ))

    return profiles


def parse_spd(data: bytes) -> Optional[SpdDdr3Parsed]:
    if len(data) < 4:
        return None
    mem_type = data[2]
    mfr_name = "Unknown"
    if len(data) > 118:
        from .jedec import lookup_manufacturer_by_id
        mfr_name = lookup_manufacturer_by_id(data[117], data[118])
    if mem_type == 0x0B:
        return parse_ddr3(data, mfr_name)
    return None
