#!/bin/bash

# Extrai informacoes sobre o primeiro modulo de memoria e joga em um arquivo biario
sudo i2cdump -f -y 0 0x50 b > dimm0.bin
# Extrai informacoes sobre o segundo modulo de memoria e joga em um arquivo biario
sudo i2cdump -f -y 0 0x51 b > dimm1.bin

exit 0