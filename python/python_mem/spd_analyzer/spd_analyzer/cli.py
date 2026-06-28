import argparse
import sys
from pathlib import Path
from typing import List, Optional

from . import __version__
from .decoder import decode_multiple, decode_spd
from .reader import (
    SLOT_NAMES,
    SPD_ADDRESSES,
    detect_smbus_busses,
    load_all_spd_files,
    load_spd_from_file,
    scan_smbus,
)
from .report import (
    console,
    print_banner,
    print_compare_report,
    print_decode_report,
    print_hex_dump,
    print_module_header,
    print_scan_results,
)
from .compare import compare_modules
from .json_export import export_json
from .csv_export import export_csv
from .html import export_html


def cmd_scan(args: argparse.Namespace):
    print_banner()
    busses = detect_smbus_busses()
    if not busses:
        console.print("[yellow]No SMBus devices found. Load i2c-dev module.[/yellow]")
        return

    all_found = []
    all_addrs = []
    for bus in busses:
        found = scan_smbus(bus)
        for addr, slot, bus_num in found:
            all_found.append(slot)
            all_addrs.append(addr)

    if all_found:
        console.print("[bold green]Found:[/bold green]")
        print_scan_results(all_found, all_addrs)
    else:
        console.print("[yellow]No SPD devices detected.[/yellow]")
        console.print("Try running with sudo or check i2c-dev module.")


def cmd_dump(args: argparse.Namespace):
    print_banner()

    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    busses = detect_smbus_busses()
    if not busses:
        console.print("[yellow]No SMBus devices found.[/yellow]")
        return

    count = 0
    for bus in busses:
        found = scan_smbus(bus)
        for addr, slot, bus_num in found:
            filename = output_dir / f"dimm{count}.bin"
            console.print(f"  Reading {slot} ({hex(addr)}) on bus {bus_num}...")

            spd_data = None
            try:
                import smbus2
                smbus = smbus2.SMBus(bus_num)
                raw = bytearray()
                for offset in range(256):
                    try:
                        raw.append(smbus.read_byte_data(addr, offset))
                    except OSError:
                        raw.append(0x00)
                smbus.close()
                spd_data = bytes(raw)
            except ImportError:
                console.print("  [red]smbus2 not installed. Install with: pip install smbus2[/red]")
                return

            if spd_data and len(spd_data) >= 128:
                filename.write_bytes(spd_data)
                console.print(f"  → [green]{filename}[/green] ({len(spd_data)} bytes)")
                count += 1
            else:
                console.print(f"  [red]Failed to read SPD from {hex(addr)}[/red]")

    if count == 0:
        console.print("[yellow]No modules dumped.[/yellow]")
    else:
        console.print(f"\n[green]Dumped {count} module(s) to {output_dir}/[/green]")


def cmd_decode(args: argparse.Namespace):
    print_banner()

    if args.input:
        path = Path(args.input)
        if path.is_file():
            data = load_spd_from_file(path)
            if data:
                decoded = decode_spd(data, path.stem)
                print_module_header(path.stem)
                print_decode_report(decoded)
            else:
                console.print(f"[red]Could not read SPD from {args.input}[/red]")
        elif path.is_dir():
            spd_data = load_all_spd_files(args.input)
            if not spd_data:
                console.print(f"[yellow]No SPD files found in {args.input}/[/yellow]")
                return
            results = decode_multiple(spd_data)
            for i, decoded in enumerate(results):
                print_module_header(decoded.slot, i, len(results))
                print_decode_report(decoded)
        else:
            console.print(f"[red]Path not found: {args.input}[/red]")
    else:
        spd_data = load_all_spd_files("data")
        if not spd_data:
            spd_data = load_all_spd_files(".")
        if not spd_data:
            console.print("[yellow]No SPD data found. Run 'spd-analyzer dump' first.[/yellow]")
            console.print("Or specify --input <file_or_directory>")
            return
        results = decode_multiple(spd_data)
        for i, decoded in enumerate(results):
            print_module_header(decoded.slot, i, len(results))
            print_decode_report(decoded)


def cmd_compare(args: argparse.Namespace):
    print_banner()

    if args.input:
        path = Path(args.input)
        if path.is_file():
            data = load_spd_from_file(path)
            if data:
                results = [decode_spd(data, path.stem)]
            else:
                console.print(f"[red]Could not read SPD from {args.input}[/red]")
                return
        elif path.is_dir():
            spd_data = load_all_spd_files(args.input)
            if not spd_data:
                console.print(f"[yellow]No SPD files found in {args.input}/[/yellow]")
                return
            results = decode_multiple(spd_data)
        else:
            console.print(f"[red]Path not found: {args.input}[/red]")
            return
    else:
        spd_data = load_all_spd_files("data")
        if not spd_data:
            spd_data = load_all_spd_files(".")
        if not spd_data:
            console.print("[yellow]No SPD data found.[/yellow]")
            return
        results = decode_multiple(spd_data)

    if len(results) < 2:
        console.print("[yellow]Need at least 2 modules to compare.[/yellow]")
        return

    comp = compare_modules(results)
    print_compare_report(results, comp.compatible)


def cmd_export(args: argparse.Namespace):
    print_banner()

    spd_data = load_all_spd_files("data")
    if not spd_data:
        spd_data = load_all_spd_files(".")
    if not spd_data:
        if args.input:
            path = Path(args.input)
            if path.is_file():
                data = load_spd_from_file(path)
                if data:
                    spd_data = {path.stem: data}
            elif path.is_dir():
                spd_data = load_all_spd_files(args.input)

    if not spd_data:
        console.print("[yellow]No SPD data found.[/yellow]")
        return

    results = decode_multiple(spd_data)
    fmt = args.format

    output_dir = Path("reports")
    output_dir.mkdir(parents=True, exist_ok=True)

    filename = output_dir / f"report.{fmt}"
    filepath = str(filename)

    if fmt == "json":
        export_json(results, filepath)
    elif fmt == "csv":
        export_csv(results, filepath)
    elif fmt == "html":
        export_html(results, filepath)
    else:
        console.print(f"[red]Unsupported format: {fmt}[/red]")
        return

    console.print(f"  [green]→ {filepath}[/green]")


def cmd_hex(args: argparse.Namespace):
    print_banner()

    if args.input:
        path = Path(args.input)
        if path.is_file():
            data = load_spd_from_file(path)
            if data:
                console.print(f"[bold]Hex dump: {path}[/bold]")
                print_hex_dump(data)
            else:
                console.print(f"[red]Could not read {args.input}[/red]")
        elif path.is_dir():
            spd_data = load_all_spd_files(args.input)
            if not spd_data:
                console.print(f"[yellow]No SPD files found in {args.input}/[/yellow]")
                return
            for slot, data in spd_data.items():
                console.print(f"\n[bold]{slot}[/bold]")
                print_hex_dump(data)
    else:
        spd_data = load_all_spd_files("data")
        if not spd_data:
            spd_data = load_all_spd_files(".")
        if not spd_data:
            console.print("[yellow]No SPD data found.[/yellow]")
            return
        for slot, data in spd_data.items():
            console.print(f"\n[bold]{slot}[/bold]")
            print_hex_dump(data)


def cmd_info(args: argparse.Namespace):
    print_banner()
    console.print(f"  [bold]Version:[/bold]     {__version__}")
    console.print(f"  [bold]Python:[/bold]       {sys.version.split()[0]}")
    console.print(f"  [bold]Platform:[/bold]     {sys.platform}")

    console.print(f"\n  [bold]Commands:[/bold]")
    console.print(f"    scan          Detect SPD devices on SMBus")
    console.print(f"    dump          Read SPD data from modules")
    console.print(f"    decode        Decode and display SPD data")
    console.print(f"    compare       Compare two memory modules")
    console.print(f"    export        Export data (json, csv, html)")
    console.print(f"    hex           Show raw hex dump of SPD")
    console.print(f"    info          Show system information")

    console.print(f"\n  [bold]Data directories:[/bold]")
    for d in ["data", "reports", "tests"]:
        p = Path(d)
        status = "✓" if p.exists() else "—"
        console.print(f"    {status} {d}/")

    console.print(f"\n  [dim]Based on JEDEC Standard 21-C[/dim]")


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="spd-analyzer",
        description="Professional SPD (Serial Presence Detect) analyzer for memory modules",
        epilog="Based on JEDEC Standard No. 21-C",
    )
    parser.add_argument(
        "-v", "--version",
        action="version",
        version=f"%(prog)s {__version__}",
    )

    sub = parser.add_subparsers(dest="command", required=True)

    p_scan = sub.add_parser("scan", help="Detect SPD devices on SMBus")

    p_dump = sub.add_parser("dump", help="Read SPD data from memory modules")
    p_dump.add_argument("-o", "--output", default="data", help="Output directory (default: data/)")

    p_decode = sub.add_parser("decode", help="Decode and display SPD data")
    p_decode.add_argument("-i", "--input", help="SPD binary file or directory with dimm*.bin files")

    p_compare = sub.add_parser("compare", help="Compare two or more modules")
    p_compare.add_argument("-i", "--input", help="Directory containing SPD binary files")

    p_export = sub.add_parser("export", help="Export decoded data")
    p_export.add_argument("format", choices=["json", "csv", "html"], help="Export format")
    p_export.add_argument("-i", "--input", help="SPD binary file or directory")

    p_hex = sub.add_parser("hex", help="Show raw hex dump of SPD data")
    p_hex.add_argument("-i", "--input", help="SPD binary file or directory")

    p_info = sub.add_parser("info", help="Show system and version information")

    return parser


def main(argv: Optional[List[str]] = None):
    parser = build_parser()
    args = parser.parse_args(argv)

    command_map = {
        "scan": cmd_scan,
        "dump": cmd_dump,
        "decode": cmd_decode,
        "compare": cmd_compare,
        "export": cmd_export,
        "hex": cmd_hex,
        "info": cmd_info,
    }

    cmd_fn = command_map.get(args.command)
    if cmd_fn:
        cmd_fn(args)


if __name__ == "__main__":
    main()
