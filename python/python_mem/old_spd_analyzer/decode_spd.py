from pathlib import Path

JEDEC_MANUFACTURERS = {
    (0x01, 0x98): "Kingston",
    (0x01, 0xCE): "Samsung",
    (0x01, 0x2C): "Micron",
    (0x01, 0xAD): "SK hynix",
    (0x01, 0x98): "Kingston",
    (0x01, 0x04): "Fujitsu",
    (0x01, 0x7F): "Reserved",
}

arquivo = ["dimm0.bin", "dimm1.bin"]

for bin in arquivo:
    data = Path(bin).read_bytes()

    print(f"Tamanho do SPD: {len(data)} bytes")
    print()

    print("===== Informações =====")

    print("Tipo SPD:", hex(data[2]))

    manufacturer = (data[117], data[118])

    print("Manufacturer ID:", manufacturer)

    if manufacturer in JEDEC_MANUFACTURERS:
        print("Fabricante:", JEDEC_MANUFACTURERS[manufacturer])
    else:
        print("Fabricante: desconhecido na tabela simplificada")

    part = data[128:146].decode(errors="ignore").strip("\x00")

    print("Part Number:", part)

    serial = ''.join(f"{b:02X}" for b in data[122:126])

    print("Serial:", serial)