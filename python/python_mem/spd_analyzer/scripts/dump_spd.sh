#!/usr/bin/env bash
#
# dump_spd.sh - Extrai o conteúdo SPD dos módulos de memória via SMBus
#
# Uso:
#   ./dump_spd.sh                    # Detecta e extrai todos os módulos
#   ./dump_spd.sh --bus 1            # Usa o barramento SMBus 1
#   ./dump_spd.sh --output data/     # Diretório de saída
#
# Dependências: i2c-tools (i2cdump, i2cdetect, i2cget)

set -euo pipefail

SMBUS_BUS=0
OUTPUT_DIR="data"
VERBOSE=false

usage() {
    sed -n '3,9p' "$0" | sed 's/^# //'
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --bus) SMBUS_BUS="$2"; shift 2 ;;
        --output) OUTPUT_DIR="$2"; shift 2 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help) usage ;;
        *) echo "Opção desconhecida: $1"; usage ;;
    esac
done

mkdir -p "$OUTPUT_DIR"

if ! command -v i2cdetect &>/dev/null; then
    echo "Erro: i2c-tools não está instalado."
    echo "Instale com: sudo apt install i2c-tools"
    exit 1
fi

if ! command -v i2cdump &>/dev/null; then
    echo "Erro: i2cdump não encontrado."
    exit 1
fi

echo "──────────────────────────────────────────────"
echo " SPD Analyzer — Dump"
echo "──────────────────────────────────────────────"
echo "Barramento SMBus: $SMBUS_BUS"
echo ""

# Endereços SPD padrão (0x50 a 0x57)
SPD_ADDRESSES=(0x50 0x51 0x52 0x53 0x54 0x55 0x56 0x57)
SLOT_NAMES=("Slot A" "Slot B" "Slot C" "Slot D" "Slot E" "Slot F" "Slot G" "Slot H")

found=false
index=0

for addr in "${SPD_ADDRESSES[@]}"; do
    slot="${SLOT_NAMES[$index]}"

    # Verifica se o endereço responde
    if i2cget -y "$SMBUS_BUS" "$addr" 0x00 &>/dev/null; then
        found=true
        filename="${OUTPUT_DIR}/dimm${index}.bin"
        echo "  $slot detectado em $addr → $filename"

        # Dump raw binary (formato puro, sem formatação)
        # i2cdump -y -r 0-255 $SMBUS_BUS $addr b | tail -n +2 | while read line; do
        #   echo "$line" | awk '{for(i=2;i<=17;i++) printf "%s", $i}' | xxd -r -p
        # done > "$filename"

        # Método mais robusto: usar i2cget byte a byte
        > "$filename"
        for offset in $(seq 0 255); do
            byte=$(i2cget -y "$SMBUS_BUS" "$addr" "$offset" b 2>/dev/null || echo "0x00")
            printf "\\$(printf '%03o' "$byte")" >> "$filename"
        done

        echo "  → $(stat -c%s "$filename") bytes lidos"
    fi
    index=$((index + 1))
done

if [ "$found" = false ]; then
    echo "  Nenhum módulo de memória encontrado no barramento $SMBUS_BUS."
    echo "  Verifique se o módulo i2c-dev está carregado: sudo modprobe i2c-dev"
    exit 1
fi

echo ""
echo "Concluído. Arquivos salvos em: $OUTPUT_DIR/"
echo "Execute 'spd-analyzer decode' para decodificar."
