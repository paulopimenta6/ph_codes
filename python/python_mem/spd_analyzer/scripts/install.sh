#!/usr/bin/env bash
#
# install.sh - Script de instalação do SPD Analyzer
#
# Suporta: pip, pipx, e desenvolvimento (editable)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PYTHON="${PYTHON:-python3}"

echo "──────────────────────────────────────────────"
echo " SPD Analyzer — Instalação"
echo "──────────────────────────────────────────────"

# Verifica Python
if ! command -v "$PYTHON" &>/dev/null; then
    echo "Erro: Python não encontrado. Instale python3 primeiro."
    exit 1
fi

echo "Python: $($PYTHON --version)"
echo ""

case "${1:-pip}" in
    pip)
        echo "Modo: pip install (usuário)"
        "$PYTHON" -m pip install --user "$REPO_DIR"
        echo ""
        echo "Instalado! Execute: spd-analyzer --help"
        ;;

    dev)
        echo "Modo: editable (desenvolvimento)"
        "$PYTHON" -m pip install -e "$REPO_DIR"
        echo ""
        echo "Instalado em modo editable!"
        echo "Execute: spd-analyzer --help"
        ;;

    pipx)
        echo "Modo: pipx"
        pipx install "$REPO_DIR"
        echo ""
        echo "Instalado via pipx!"
        ;;

    uninstall)
        echo "Removendo..."
        "$PYTHON" -m pip uninstall spd-analyzer -y
        echo "Removido."
        ;;

    deps)
        echo "Instalando dependências do sistema..."
        if command -v apt &>/dev/null; then
            sudo apt update
            sudo apt install -y i2c-tools python3-smbus
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y i2c-tools python3-smbus
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm i2c-tools python-smbus
        else
            echo "Gerenciador de pacotes não reconhecido. Instale i2c-tools manualmente."
        fi
        echo "Dependências do sistema instaladas!"
        ;;

    *)
        echo "Uso: $0 [pip|dev|pipx|uninstall|deps]"
        echo ""
        echo "  pip       - Instalação para o usuário (padrão)"
        echo "  dev       - Modo desenvolvimento (editable)"
        echo "  pipx      - Instalação isolada via pipx"
        echo "  uninstall - Remove o pacote"
        echo "  deps      - Instala dependências do sistema (i2c-tools)"
        exit 1
        ;;
esac
