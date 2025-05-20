# Balanceador de Carga con Nginx
Proyecto Final Servicios Telemáticos 

# Configuración de NGINX como Balanceador de Carga

Este documento describe cómo configurar un servidor NGINX en Ubuntu para actuar como balanceador de carga entre varios servidores backend.

## Requisitos

- Sistema basado en Debian/Ubuntu.
- Acceso con permisos de superusuario (sudo).
- IPs de los servidores backend configuradas y accesibles.

## Pasos de Instalación y Configuración

### 1. Actualizar el sistema e instalar NGINX

```bash
sudo apt update && sudo apt install -y nginx
```

### 2. Respaldar la configuración actual de NGINX

```bash
sudo cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
```

### 3. Configurar NGINX como balanceador de carga

Reemplazar el archivo de configuración de NGINX con el siguiente contenido:

```nginx
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
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

Nota: Se puede modificar las IPs bajo `upstream backend` para adaptarlas a una infraestructura con más servidores.

Para reemplazar el archivo manualmente desde la terminal,  usar:

```bash
sudo nano /etc/nginx/nginx.conf
```

Y pegar el contenido anterior.

### 4. Reiniciar NGINX para aplicar los cambios

```bash
sudo systemctl restart nginx
```

## Acceso

Una vez aplicado, el balanceador estará disponible en:

```
http://192.168.50.30
```

---

# Configuración del Cliente para Pruebas de Carga con Artillery

Esta parte explica cómo preparar un entorno en una máquina con Ubuntu para ejecutar pruebas de carga utilizando Artillery, una herramienta moderna para pruebas de rendimiento.

## Requisitos

- Sistema operativo basado en Debian/Ubuntu.
- Permisos de superusuario (sudo).

## Pasos de Instalación

### 1. Actualizar los paquetes del sistema

Primero, asegurarse de que los paquetes de el sistema estén actualizados:

```bash
sudo apt update
```

### 2. Instalar Node.js

Agregar el repositorio oficial de Node.js versión 20.x e instalarlo:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
```

### 3. Instalar Artillery

Instalar Artillery como dependencia de desarrollo global utilizando npm:

```bash
sudo npm install --save-dev artillery
```

Nota: Si se desea instalar Artillery de forma global (disponible en todo el sistema), se puede usar:

```bash
sudo npm install -g artillery
```

## Verificación

Para comprobar que Artillery se ha instalado correctamente, ejecutar:

```bash
npx artillery --version
```

## Listo

El sistema ya está preparado para ejecutar pruebas de carga con Artillery.

---

# Ecoturismo Website - Guía de Aprovisionamiento para los Servidores
Esta parte contiene instrucciones para desplegar el proyecto Ecoturismo Website en una máquina basada en Ubuntu.
Aqui veremos el paso a paso de ese script explicado:

## Requisitos

- Ubuntu/Debian
- Acceso root o permisos sudo
- Conexión a Internet

## Pasos de instalación

### 1. Actualizar el sistema

Actualizar los paquetes del sistema operativo:

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Node.js 20.x, Git y NGINX

Agregar el repositorio oficial de Node.js 20.x y luego instalar Node.js, Git y NGINX:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs git nginx
```

### 3. Instalar PM2

Instalar PM2 globalmente para manejar procesos de Node.js:

```bash
sudo npm install -g pm2
```

### 4. Clonar o actualizar el repositorio del proyecto

Navegar al directorio /home/vagrant y clonar el repositorio si no existe, o actualizarlo si ya está presente:

```bash
cd /home/vagrant
if [ -d "ecoturismo-website" ]; then
  cd ecoturismo-website
  git pull
else
  git clone https://github.com/scortesg1/ecoturismo-website.git
  cd ecoturismo-website
fi
```

### 5. Instalar dependencias y construir el proyecto

Dentro del directorio del proyecto, instalar las dependencias con npm y generar los archivos de construcción:

```bash
npm install --force
npm run build
```

### 6. Iniciar la aplicación con PM2

Iniciar la aplicación usando PM2 y guardar la configuración:

```bash
pm2 start npm --name "ecoturismo" -- start
pm2 save
```

### 7. Configurar inicio automático de PM2

Configurar PM2 para que se inicie automáticamente al arrancar el sistema (ajustado para el usuario vagrant):

```bash
sudo env PATH=$PATH:/usr/bin pm2 startup systemd -u vagrant --hp /home/vagrant
```

### 8. Configurar NGINX como proxy inverso

Crear una configuración personalizada para NGINX que redirija las solicitudes a la aplicación Node.js en el puerto 3000:

```nginx
server {
    listen 80;
    server_name localhost;
    location / {
        add_header X-Servidor [nombre-del-host];
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Guarda esto en `/etc/nginx/sites-available/ecoturismo`, luego activarlo:

```bash
sudo ln -sf /etc/nginx/sites-available/ecoturismo /etc/nginx/sites-enabled/ecoturismo
sudo rm -f /etc/nginx/sites-enabled/default
```

### 9. Reiniciar NGINX

Verificar la configuración y reiniciar el servicio de NGINX:

```bash
sudo nginx -t && sudo systemctl restart nginx
```

## Acceso a la aplicación

Una vez finalizado el proceso, acceder a la aplicación en:

```
http://192.168.50.10
```

