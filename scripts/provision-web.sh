#!/bin/bash
set -e

echo "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs git nginx

echo "Instalando PM2..."
sudo npm install -g pm2

echo "Clonando o actualizando el proyecto..."
cd /home/vagrant
if [ -d "ecoturismo-website" ]; then
  cd ecoturismo-website
  git pull
else
  git clone https://github.com/scortesg1/ecoturismo-website.git
  cd ecoturismo-website
fi

echo "Instalando dependencias y construyendo proyecto..."
npm install --force
npm run build

echo "Iniciando app con PM2..."
pm2 start npm --name "ecoturismo" -- start
pm2 save

echo "Configurando PM2 startup..."
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant

echo "Configurando NGINX..."
HOSTNAME=$(hostname)
sudo tee /etc/nginx/sites-available/ecoturismo > /dev/null <<EOF
server {
    listen 80;
    server_name localhost;

    location / {
        add_header X-Servidor $HOSTNAME;
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "Activando configuración de NGINX..."
sudo ln -sf /etc/nginx/sites-available/ecoturismo /etc/nginx/sites-enabled/ecoturismo
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl restart nginx

echo "✔️ Aprovisionamiento completo. Accede en http://192.168.50.10"
