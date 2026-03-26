#!/bin/bash
# setup.sh production

ENVIRONMENT=$1
NETWORK_NAME="harco_network"

echo "🚀 Iniciando configuración en modo: ${ENVIRONMENT:-development}"

# 1. Crear la red si no existe
if [ ! "$(docker network ls | grep -w $NETWORK_NAME)" ]; then
  echo "🌐 Creando red global: $NETWORK_NAME"
  docker network create $NETWORK_NAME
else
  echo "✅ La red $NETWORK_NAME ya existe."
fi

# 2. Levantar Infraestructura Global
echo "📦 Levantando Base de Datos Global..."

if [ -d "infra-global" ]; then
  cd infra-global
  
  # Validamos si existe el archivo de variables antes de intentar levantar
  if [ ! -f ".env" ]; then
    echo "❌ ERROR: No se encontró el archivo infra-global/.env"
    echo "Crea el archivo con las variables PGUSER, PGPASSWORD y PGDATABASE."
    exit 1
  fi

  # Docker Compose usa automáticamente el archivo .env del directorio actual
  docker compose up -d
  
  if [ $? -eq 0 ]; then
    echo "✅ Infraestructura global levantada con éxito."
  else
    echo "❌ Error al levantar los contenedores. Revisa los logs con 'docker compose logs'."
    exit 1
  fi
  cd ..
else
  echo "⚠️ Carpeta 'infra-global' no encontrada."
fi

# 3. Levantar Backend
if [ -f "docker-compose.yml" ]; then
  echo "⚙️ Levantando Backend de la aplicación..."
  docker compose up -d
else
  echo "ℹ️ No hay docker-compose.yml en la raíz, proceso finalizado."
fi

echo "✨ ¡Todo listo! Tu fortaleza en Hetzner está operando."