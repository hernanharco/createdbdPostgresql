# Infraestructura Global

Proyecto de infraestructura global que proporciona una base de datos PostgreSQL centralizada para múltiples servicios en la red `harco_network`.

## 🏗️ Arquitectura

- **Base de Datos**: PostgreSQL 17 Alpine
- **Red Docker**: `harco_network` (compartida entre servicios)
- **Persistencia**: Volumen Docker `global_db_data`
- **Health Check**: Monitoreo automático de disponibilidad

## 📁 Estructura del Proyecto

```
infra-global/
├── .env                 # Variables de entorno de la base de datos
├── docker-compose.yml   # Configuración de servicios Docker
├── setup.sh             # Script de inicialización
└── README.md            # Este archivo
```

## ⚙️ Configuración

### 1. Variables de Entorno

Crea el archivo `.env` con las siguientes variables:

```bash
PGUSER=admin_harco
PGPASSWORD=tu_password_super_segura_de_produccion
PGDATABASE=db_global_manager
```

### 2. Red Docker

El proyecto utiliza la red `harco_network` que debe existir antes de levantar los servicios.

## 🚀 Inicio Rápido

### Opción 1: Usando el Script Automático

```bash
# Ejecutar el script de configuración
./setup.sh production
```

El script automáticamente:
- ✅ Crea la red `harco_network` si no existe
- ✅ Levanta la base de datos global
- ✅ Verifica el estado de los contenedores

### Opción 2: Manual

```bash
# Crear la red si no existe
docker network create harco_network

# Levantar la base de datos
docker compose up -d
```

## 🔧 Servicios

### global-db

- **Imagen**: `postgres:17-alpine`
- **Puerto**: `5432:5432`
- **Contenedor**: `global-db`
- **Reinicio**: `always`
- **Health Check**: Verificación cada 10 segundos

## 🌐 Conexión

### Desde otros contenedores en la misma red:

```bash
# Host: global-db
# Puerto: 5432
# Usuario: ${PGUSER}
# Password: ${PGPASSWORD}
# Database: ${PGDATABASE}
```

### Desde el host local:

```bash
# Host: localhost
# Puerto: 5432
psql -h localhost -U ${PGUSER} -d ${PGDATABASE}
```

## 📊 Monitoreo

### Ver estado de los contenedores:

```bash
docker compose ps
```

### Ver logs:

```bash
docker compose logs -f global-db
```

### Ver health check:

```bash
docker inspect global-db | grep Health -A 10
```

## 🛠️ Comandos Útiles

```bash
# Reiniciar servicios
docker compose restart

# Detener servicios
docker compose down

# Eliminar volúmenes (cuidado: se pierden datos)
docker compose down -v

# Acceder a la base de datos
docker exec -it global-db psql -U ${PGUSER} -d ${PGDATABASE}
```

## 🔐 Seguridad

- Cambiar el password por defecto en producción
- Utilizar passwords seguras
- Considerar cifrado de datos sensibles
- Restringir acceso a la red según sea necesario

## 📝 Notas

- El volumen `global_db_data` persiste los datos entre reinicios
- La red `harco_network` es externa y puede ser compartida con otros servicios
- El health check asegura que la base de datos esté disponible antes de aceptar conexiones

## 🚨 Troubleshooting

### Problemas comunes:

1. **Red no existe**: Ejecutar `docker network create harco_network`
2. **Permisos del .env**: Asegurar que el archivo tenga los permisos correctos
3. **Puerto en uso**: Verificar que el puerto 5432 no esté ocupado
4. **Contenedor no inicia**: Revisar logs con `docker compose logs`

### Verificación de sistema:

```bash
# Verificar red
docker network ls | grep harco_network

# Verificar contenedor
docker ps | grep global-db

# Verificar volumen
docker volume ls | grep global_db_data
```

---

**Desarrollado para la infraestructura global de Harco** 🚀
# createdbdPostgresql
# createdbdPostgresql
