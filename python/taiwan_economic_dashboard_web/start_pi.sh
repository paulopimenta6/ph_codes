#!/bin/bash
# Taiwan Economic Dashboard - Inicialização Raspberry Pi 4B (1GB)
# Otimizações para ambiente com recursos limitados

set -e

SCRIPT_DIR="/home/nottingham/projetos/servidor_dados/taiwan_economic_dashboard_web"
cd "$SCRIPT_DIR"

echo "=========================================="
echo " Taiwan Economic Dashboard - Raspberry Pi"
echo "=========================================="

# Otimizações de memória e CPU para Raspberry Pi
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2
export NUMEXPR_NUM_THREADS=2
export PYTHONUNBUFFERED=1

PYTHON="/home/nottingham/projetos/servidor_dados/venv/bin/python"

echo "[1/3] Verificando dependências..."
"$PYTHON" -c "
import importlib
pkgs = ['flask', 'plotly', 'pandas', 'numpy', 'requests', 'bs4', 'matplotlib', 'scipy', 'sklearn']
for p in pkgs:
    try:
        importlib.import_module(p)
        print(f'  OK {p}')
    except ImportError:
        print(f'  FALTANDO {p}')
print('OK Dependências verificadas')
"

echo "[2/3] Iniciando servidor web..."
echo "  -> Abra http://$(hostname -I | awk '{print $1}'):5000 no navegador"
echo "  -> Pressione Ctrl+C para parar"
echo ""

"$PYTHON" app.py --host 0.0.0.0 --port 5000 --pi-mode "$@"
