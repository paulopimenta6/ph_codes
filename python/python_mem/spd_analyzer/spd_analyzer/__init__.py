__version__ = "1.0.0"
__author__ = "SPD Analyzer Team"
__description__ = "Professional tool for analyzing SPD (Serial Presence Detect) data from memory modules"

from .decoder import decode_spd, decode_multiple
from .reader import load_all_spd_files, load_spd_from_file
from .parser import parse_spd
from .compare import compare_modules
from .validators import validate_ddr3_crc
from .jedec import lookup_manufacturer

__all__ = [
    "decode_spd",
    "decode_multiple",
    "load_all_spd_files",
    "load_spd_from_file",
    "parse_spd",
    "compare_modules",
    "validate_ddr3_crc",
    "lookup_manufacturer",
]
