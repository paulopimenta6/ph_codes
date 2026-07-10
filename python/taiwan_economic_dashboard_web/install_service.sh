#!/bin/bash
# Instala o dashboard como serviço systemd no Raspberry Pi
# Após isso, o servidor roda sozinho mesmo sem SSH

set -e

SERVICE_NAME="taiwan-dashboard"
INSTALL_DIR="/home/nottingham/projetos/servidor_dados/taiwan_economic_dashboard_web"
USER_NAME="nottingham"

VENV_PYTHON="/home/nottingham/projetos/servidor_dados/venv/bin/python"

echo "=== Instalando serviço $SERVICE_NAME ==="

# Criar arquivo de serviço systemd
SERVICE_FILE="/tmp/$SERVICE_NAME.service"

cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Taiwan Economic Dashboard
After=network.target

[Service]
Type=simple
User=$USER_NAME
WorkingDirectory=$INSTALL_DIR
ExecStart=$VENV_PYTHON $INSTALL_DIR/app.py --host 0.0.0.0 --port 5000 --pi-mode
Restart=on-failure
RestartSec=10
Environment=OMP_NUM_THREADS=2
Environment=MKL_NUM_THREADS=2
Environment=OPENBLAS_NUM_THREADS=2

[Install]
WantedBy=multi-user.target
EOF

sudo mv "$SERVICE_FILE" "/etc/systemd/system/$SERVICE_NAME.service"
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"

echo ""
echo "=== OK! Serviço instalado e rodando ==="
echo ""
echo "Comandos úteis:"
echo "  sudo systemctl status $SERVICE_NAME    # Ver status"
echo "  sudo systemctl stop $SERVICE_NAME      # Parar"
echo "  sudo systemctl start $SERVICE_NAME     # Iniciar"
echo "  sudo systemctl restart $SERVICE_NAME   # Reiniciar"
echo "  sudo journalctl -u $SERVICE_NAME -f    # Ver logs em tempo real"
echo ""
echo "Acesse o dashboard em: http://$(hostname -I | awk '{print $1}'):5000"
