#!/bin/bash
set -e

echo "Actualizando sistema e instalando Node.js y Artillery..."
sudo apt update
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install --save-dev artillery

echo "✔️ Cliente listo para pruebas de carga con Artillery"
