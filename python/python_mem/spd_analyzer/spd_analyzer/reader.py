from pathlib import Path
from typing import Dict, List, Optional, Tuple

from .utils import convert_i2cdump_text_to_binary, detect_spd_format, find_i2cdump_text_files


SPD_ADDRESSES = [0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57]
SLOT_NAMES = ["Slot A", "Slot B", "Slot C", "Slot D", "Slot E", "Slot F", "Slot G", "Slot H"]


def detect_smbus_busses() -> List[int]:
    busses = []
    for bus in range(0, 8):
        path = Path(f"/dev/i2c-{bus}")
        if path.exists():
            busses.append(bus)
    return busses


def scan_smbus(bus_number: int = 0) -> List[Tuple[int, str, int]]:
    results = []
    try:
        import smbus2
        bus = smbus2.SMBus(bus_number)
        for i, addr in enumerate(SPD_ADDRESSES):
            try:
                bus.read_byte(addr)
                results.append((addr, SLOT_NAMES[i], bus_number))
            except OSError:
                pass
        bus.close()
    except ImportError:
        pass
    return results


def read_spd_raw(bus_number: int, address: int, length: int = 256) -> Optional[bytes]:
    try:
        import smbus2
        bus = smbus2.SMBus(bus_number)
        data = bytearray()
        for offset in range(length):
            try:
                byte = bus.read_byte_data(address, offset)
                data.append(byte)
            except OSError:
                data.append(0x00)
        bus.close()
        return bytes(data)
    except ImportError:
        return None


def load_spd_from_file(path: Path) -> Optional[bytes]:
    if not path.exists():
        return None
    raw = path.read_bytes()
    fmt = detect_spd_format(raw)
    if fmt == "i2cdump_text":
        converted = convert_i2cdump_text_to_binary(raw.decode("ascii", errors="replace"))
        if converted:
            return converted
    if fmt == "raw_binary":
        return raw[:256]
    return None


def load_all_spd_files(directory: str = "data") -> Dict[str, bytes]:
    modules: Dict[str, bytes] = {}
    path = Path(directory)
    if not path.exists():
        return modules
    files = sorted(path.glob("dimm*.bin"))
    slot_names = SLOT_NAMES[:]
    for i, f in enumerate(files):
        data = load_spd_from_file(f)
        if data:
            label = slot_names[i] if i < len(slot_names) else f"Slot {chr(65 + i)}"
            modules[label] = data
    return modules


def get_spd_data(source: str) -> Dict[str, bytes]:
    path = Path(source)
    if path.is_dir():
        return load_all_spd_files(str(path))
    if path.is_file():
        data = load_spd_from_file(path)
        if data:
            return {"SPD": data}
    return {}
