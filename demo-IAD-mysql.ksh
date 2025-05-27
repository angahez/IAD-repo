#!/bin/bash

# Crear la estructura del directorio
mkdir -p IAD-MYSQL/mysql

# Crear el contenido del Dockerfile
cat <<EOL > IAD-MYSQL/mysql/Dockerfile
# Utilizar la imagen oficial de MySQL
FROM mysql:8.0

# Copiar el archivo de configuración personalizado
COPY my.cnf /etc/mysql/conf.d/

# Exponer el puerto de MySQL
EXPOSE 3306
EOL

# Crear el archivo de configuración my.cnf
cat <<EOL > IAD-MYSQL/mysql/my.cnf
[mysqld]
# Configuraciones personalizadas de MySQL
bind-address = 0.0.0.0
EOL

# Crear el archivo de configuración del entorno .env
cat <<EOL > IAD-MYSQL/.env
MYSQL_ROOT_PASSWORD=root_password
MYSQL_DATABASE=gestion_datos
MYSQL_USER=admin_usuario
MYSQL_PASSWORD=admin_password
EOL

# Crear el archivo de orquestación Docker Compose
cat <<EOL > IAD-MYSQL/docker-compose.yml
services:
  mysql:
    image: img_iad-mysql-001
    container_name: contenedor_mysql
    env_file:
      - .env
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
EOL

# Crear la imagen
docker build -t img_iad-mysql-001 ./IAD-MYSQL/mysql

# Arrancar el servicio de MySQL
docker-compose -f IAD-MYSQL/docker-compose.yml up -d

echo "La infraestructura de MySQL ha sido configurada y el servicio ha sido iniciado."

