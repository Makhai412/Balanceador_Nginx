#!/bin/bash
set -e

echo "Actualizando sistema..."
sudo apt update && sudo apt install -y nginx

echo "Configurando NGINX como balanceador..."
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak

cat <<EOF | sudo tee /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}
http {
    upstream backend {
        least_conn;
        server 192.168.50.10;
        server 192.168.50.20;
        server 192.168.50.11;
        server 192.168.50.12;
    }

    server {
        listen 80;
        location / {
            proxy_pass http://backend;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto \$scheme;
        }
    }
}
EOF

echo "Reiniciando NGINX..."
sudo systemctl restart nginx

echo "✔️ Balanceador configurado en http://192.168.50.30"