# Docker Setup Guide

## Overview

This guide explains how to set up and run the Billiard Club Management System using Docker. The system consists of:

- **PostgreSQL Database**: Stores all application data
- **Spring Boot Backend**: REST API server with JWT authentication

## Prerequisites

1. **Docker Desktop**: Install Docker Desktop for macOS
   - Download from: https://www.docker.com/products/docker-desktop
   - Start Docker Desktop before running any commands

2. **Docker Compose**: Usually included with Docker Desktop

## Quick Start

### 1. Start All Services

```bash
# Using the development script (recommended)
./scripts/docker-dev.sh start

# Or using docker-compose directly
docker-compose up --build -d
```

### 2. Check Service Status

```bash
./scripts/docker-dev.sh status
```

### 3. View Logs

```bash
# View backend logs
./scripts/docker-dev.sh logs backend

# View all logs
./scripts/docker-dev.sh logs-all
```

### 4. Check Health

```bash
./scripts/docker-dev.sh health
```

## Service Details

### PostgreSQL Database

- **Container**: `bida_postgres`
- **Port**: `5432` (mapped to host)
- **Database**: `bida_db`
- **User**: `bida_user`
- **Password**: `bida_password`

### Spring Boot Backend

- **Container**: `bida_backend`
- **Port**: `8080` (mapped to host)
- **API Base URL**: `http://localhost:8080/api/v1`
- **Swagger UI**: `http://localhost:8080/api/v1/swagger-ui.html`
- **Health Check**: `http://localhost:8080/api/v1/actuator/health`

## Development Commands

### Using the Development Script

```bash
# Start services
./scripts/docker-dev.sh start

# Stop services
./scripts/docker-dev.sh stop

# Restart services
./scripts/docker-dev.sh restart

# View logs
./scripts/docker-dev.sh logs backend
./scripts/docker-dev.sh logs postgres

# Access database
./scripts/docker-dev.sh db

# Reset database (delete all data)
./scripts/docker-dev.sh reset-db

# Check health
./scripts/docker-dev.sh health

# Show status
./scripts/docker-dev.sh status

# Clean up
./scripts/docker-dev.sh cleanup

# Show help
./scripts/docker-dev.sh help
```

### Using Docker Compose Directly

```bash
# Start services
docker-compose up -d

# Build and start
docker-compose up --build -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f backend
docker-compose logs -f postgres

# Access database
docker-compose exec postgres psql -U bida_user -d bida_db

# Reset database
docker-compose down -v
docker-compose up --build -d
```

## API Testing

Once the services are running, you can test the API:

### 1. Health Check

```bash
curl http://localhost:8080/api/v1/actuator/health
```

### 2. Swagger UI

Open in browser: `http://localhost:8080/api/v1/swagger-ui.html`

### 3. Sample API Calls

```bash
# Get companies (requires authentication)
curl -H "Authorization: Bearer YOUR_TOKEN" \
     http://localhost:8080/api/v1/companies

# Login
curl -X POST http://localhost:8080/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{"username":"admin","password":"password123"}'
```

## Database Management

### Access Database

```bash
./scripts/docker-dev.sh db
```

### Reset Database

```bash
./scripts/docker-dev.sh reset-db
```

### View Database Logs

```bash
./scripts/docker-dev.sh logs postgres
```

## Troubleshooting

### Common Issues

1. **Port Already in Use**
   ```bash
   # Check what's using the port
   lsof -i :8080
   lsof -i :5432
   
   # Stop conflicting services
   docker-compose down
   ```

2. **Database Connection Issues**
   ```bash
   # Check if PostgreSQL is running
   docker-compose ps
   
   # Check PostgreSQL logs
   docker-compose logs postgres
   ```

3. **Backend Build Issues**
   ```bash
   # Clean and rebuild
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

4. **Permission Issues**
   ```bash
   # Make script executable
   chmod +x scripts/docker-dev.sh
   ```

### Logs and Debugging

```bash
# View all logs
./scripts/docker-dev.sh logs-all

# View specific service logs
./scripts/docker-dev.sh logs backend
./scripts/docker-dev.sh logs postgres

# Follow logs in real-time
docker-compose logs -f
```

### Clean Up

```bash
# Stop and remove containers, networks, and volumes
./scripts/docker-dev.sh cleanup

# Or manually
docker-compose down -v --remove-orphans
docker system prune -f
```

## Environment Variables

The following environment variables can be customized in `docker-compose.yml`:

- `POSTGRES_DB`: Database name (default: `bida_db`)
- `POSTGRES_USER`: Database user (default: `bida_user`)
- `POSTGRES_PASSWORD`: Database password (default: `bida_password`)
- `JWT_SECRET`: JWT signing secret
- `JWT_EXPIRATION`: JWT token expiration (milliseconds)
- `JWT_REFRESH_EXPIRATION`: Refresh token expiration (milliseconds)

## Production Considerations

For production deployment:

1. **Change default passwords**
2. **Use strong JWT secrets**
3. **Configure proper logging**
4. **Set up monitoring**
5. **Use external database if needed**
6. **Configure SSL/TLS**
7. **Set up backup strategies**

## Next Steps

After setting up Docker:

1. **Test API endpoints** using Swagger UI
2. **Verify database connectivity**
3. **Test authentication flow**
4. **Integrate with Flutter apps**
5. **Set up CI/CD pipeline**
