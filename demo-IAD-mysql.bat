@echo off

REM Crear la estructura del directorio
mkdir IAD-MYSQL\mysql

REM Crear el contenido del Dockerfile
(
echo # Utilizar la imagen oficial de MySQL
echo FROM mysql:8.0
echo.
echo # Copiar el archivo de configuración personalizado
echo COPY my.cnf /etc/mysql/conf.d/
echo.
echo # Exponer el puerto de MySQL
echo EXPOSE 3306
) > IAD-MYSQL\mysql\Dockerfile

REM Crear el archivo de configuración my.cnf
(
echo [mysqld]
echo # Configuraciones personalizadas de MySQL
echo bind-address = 0.0.0.0
) > IAD-MYSQL\mysql\my.cnf

REM Crear el archivo de configuración del entorno .env
(
echo MYSQL_ROOT_PASSWORD=root_password
echo MYSQL_DATABASE=gestion_datos
echo MYSQL_USER=admin_usuario
echo MYSQL_PASSWORD=admin_password
) > IAD-MYSQL\.env

REM Crear el archivo de orquestación Docker Compose
(
echo services:
echo   mysql:
echo     image: img_iad-mysql-001
echo     container_name: contenedor_mysql
echo     env_file:
echo       - .env
echo     ports:
echo       - "3306:3306"
echo     volumes:
echo       - mysql_data:/var/lib/mysql
echo.
echo volumes:
echo   mysql_data:
) > IAD-MYSQL\docker-compose.yml

REM Crear la imagen
docker build -t img_iad-mysql-001 .\IAD-MYSQL\mysql

REM Arrancar el servicio de MySQL
docker-compose -f IAD-MYSQL\docker-compose.yml up -d

echo La infraestructura de MySQL ha sido configurada y el servicio ha sido iniciado.
