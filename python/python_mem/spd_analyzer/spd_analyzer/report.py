from typing import List, Optional

from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.text import Text
from rich import box
from rich.columns import Columns

from .decoder import DecodedSpd
from .timings import compute_profile_from_data


console = Console()


def print_banner():
    console.print()
    console.print(Panel(
        Text("SPD Analyzer", style="bold cyan", justify="center") + "\n" +
        Text("Version 1.0", style="dim", justify="center"),
        box=box.HEAVY,
        border_style="blue",
        padding=(1, 4),
    ))
    console.print()


def print_scan_results(slots: List[str], addresses: List[int]):
    console.print("[bold cyan]Scan Results[/bold cyan]")
    console.print("─" * 50)
    for slot, addr in zip(slots, addresses):
        console.print(f"  [green]●[/green] {slot:<8} SPD: [bold]{hex(addr)}[/bold]")
    console.print()


def print_module_header(slot: str, index: int = 0, total: int = 1):
    console.print()
    console.print("═" * 55, style="blue")
    console.print(f"  {slot}", style="bold white on blue")
    console.print("═" * 55, style="blue")
    console.print()


def print_decode_report(decoded: DecodedSpd):
    if decoded.error:
        console.print(f"  [red]✖ Error: {decoded.error}[/red]")
        return

    p = decoded.parsed
    if p is None:
        console.print("  [yellow]No parsed data available[/yellow]")
        return

    table = Table.grid(padding=(0, 2))
    table.add_column(style="bold yellow", width=22)
    table.add_column(style="white")

    rows = [
        ("Memory Type", p.memory_type),
        ("Capacity", f"{p.module_capacity_mb} MB ({p.module_capacity_mb / 1024:.1f} GB)"),
        ("Module", p.module_type),
        ("Bus Width", f"{p.module_bus_width} bits"),
        ("Ranks", str(p.ranks)),
        ("Banks", str(p.sdram_banks)),
        ("Voltage", p.voltage_level),
        ("Supported Voltages", ", ".join(p.supported_voltages)),
        ("Manufacturer", p.manufacturer_name),
        ("Part Number", p.part_number),
        ("Serial", p.serial_number),
    ]

    if p.manufacturing_year or p.manufacturing_week:
        date_parts = []
        if p.manufacturing_week:
            date_parts.append(f"Week {p.manufacturing_week}")
        if p.manufacturing_year:
            date_parts.append(str(p.manufacturing_year))
        rows.append(("Manufacture Date", " ".join(date_parts)))

    crc_status = "✓ OK" if decoded.crc_base_valid else "✖ FAIL"
    rows.append(("CRC", crc_status))

    rows.append(("SPD Revision", p.spd_revision))

    for label, value in rows:
        table.add_row(label, str(value))

    console.print(table)

    profiles = compute_profile_from_data(p)
    if profiles:
        console.print()
        console.print("[bold cyan]JEDEC Profiles[/bold cyan]")
        profile_table = Table.grid(padding=(0, 2))
        profile_table.add_column(style="bold", width=14)
        profile_table.add_column(style="white")
        for prof in profiles:
            profile_table.add_row(
                f"{prof.speed_mts} MT/s",
                f"{prof.timing_string}"
            )
        console.print(profile_table)

    console.print()
    console.print("[bold cyan]Organization[/bold cyan]")
    org_table = Table.grid(padding=(0, 2))
    org_table.add_column(style="bold yellow", width=22)
    org_table.add_column(style="white")
    org_rows = [
        ("Organization", p.module_organization),
        ("Banks", str(p.sdram_banks)),
        ("Bus Width", f"{p.module_bus_width}-bit"),
        ("Chips", f"{p.chip_count} chips"),
        ("Rows", str(p.sdram_rows)),
        ("Columns", str(p.sdram_columns)),
    ]
    for label, value in org_rows:
        org_table.add_row(label, str(value))
    console.print(org_table)


def print_compare_report(results: List[DecodedSpd], compatible: bool):
    console.print()
    console.print("[bold cyan]Comparison[/bold cyan]")
    console.print("─" * 50)

    if len(results) < 2:
        console.print("  [yellow]Need at least 2 modules to compare[/yellow]")
        return

    for r in results:
        console.print(f"  [bold]{r.slot}[/bold] — [green]{r.manufacturer}[/green]")

    console.print()

    checks = []
    p0 = results[0].parsed
    p1 = results[1].parsed

    if p0 and p1:
        cap_check = abs(p0.module_capacity_mb - p1.module_capacity_mb) < 1
        checks.append(("Capacity", cap_check))

        timing_check = (
            abs(p0.tAA_min_ps - p1.tAA_min_ps) < 100 and
            abs(p0.tRCD_min_ps - p1.tRCD_min_ps) < 100
        )
        checks.append(("Timings", timing_check))

        volt_check = p0.voltage_level == p1.voltage_level
        checks.append(("Voltage", volt_check))

        jedec_check = len(p0.cas_latencies) == len(p1.cas_latencies)
        checks.append(("JEDEC", jedec_check))

        rank_check = p0.ranks == p1.ranks
        checks.append(("Rank", rank_check))

        crc_check = results[0].crc_base_valid == results[1].crc_base_valid
        checks.append(("CRC", crc_check))

        spd_check = p0.spd_revision == p1.spd_revision
        checks.append(("SPD Revision", spd_check))

    check_table = Table.grid(padding=(0, 2))
    check_table.add_column(style="bold", width=16)
    check_table.add_column(style="white", width=8)

    all_ok = True
    for label, ok in checks:
        icon = "✓" if ok else "✖"
        color = "green" if ok else "red"
        check_table.add_row(label, Text(icon, style=color))
        if not ok:
            all_ok = False

    console.print(check_table)
    console.print()

    overall = "Compatible" if all_ok else "Incompatible"
    overall_style = "green" if all_ok else "red"
    console.print(f"  [bold]Overall:[/bold] [{overall_style}]{overall}[/{overall_style}]")
    console.print()


def print_hex_dump(data: bytes, bytes_per_line: int = 16):
    console.print("[dim]Hex dump:[/dim]")
    for i in range(0, min(len(data), 256), bytes_per_line):
        hex_part = " ".join(f"{b:02X}" for b in data[i:i + bytes_per_line])
        ascii_part = "".join(chr(b) if 32 <= b < 127 else "." for b in data[i:i + bytes_per_line])
        console.print(f"  {i:02X}: {hex_part:<48} {ascii_part}")
