# Docker Deployment Guide

This guide explains how to run the Local Search Platform using Docker.

## Prerequisites

- Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop))
- Docker Compose (included with Docker Desktop)
- OpenAI API Key (optional, for AI features)

## Quick Start

### 1. Set Environment Variables

**Windows (PowerShell):**
```powershell
$env:OPENAI_API_KEY="your-actual-api-key-here"
```

**Windows (Command Prompt):**
```cmd
set OPENAI_API_KEY=your-actual-api-key-here
```

**Linux/Mac:**
```bash
export OPENAI_API_KEY=your-actual-api-key-here
```

### 2. Start All Services

Run the following command from the project root directory:

```bash
docker-compose up -d
```

This will:
- Start MySQL database on port `3306`
- Build and start Spring Boot backend on port `8080`
- Create a Docker network for service communication
- Create a persistent volume for MySQL data

### 3. Verify Services

Check if all services are running:

```bash
docker-compose ps
```

View logs:

```bash
# All services
docker-compose logs -f

# Backend only
docker-compose logs -f backend

# MySQL only
docker-compose logs -f mysql
```

### 4. Access the Application

- **Backend API:** http://localhost:8080
- **Health Check:** http://localhost:8080/actuator/health
- **MySQL Database:** localhost:3306

## Docker Commands

### Build and Start Services
```bash
# Build and start in detached mode
docker-compose up -d

# Build without cache
docker-compose build --no-cache

# Start specific service
docker-compose up backend
```

### Stop Services
```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes database data)
docker-compose down -v
```

### View Logs
```bash
# Follow logs for all services
docker-compose logs -f

# View last 100 lines
docker-compose logs --tail=100

# Specific service
docker-compose logs -f backend
```

### Restart Services
```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart backend
```

### Execute Commands in Container
```bash
# Access backend container shell
docker exec -it localsearch-backend sh

# Access MySQL container
docker exec -it localsearch-mysql mysql -uroot -proot localsearch
```

## Backend Dockerfile Explained

The [`backend/Dockerfile`](file:///D:/Outskill%20workspace/Agentic%20LangGraph%20Breakout/local-search-platform/backend/Dockerfile) uses a **multi-stage build**:

### Stage 1: Build
- Uses Maven 3.9 with Java 17
- Downloads dependencies (cached for faster rebuilds)
- Compiles and packages the application

### Stage 2: Runtime
- Uses lightweight JRE Alpine image
- Runs as non-root user for security
- Includes health check configuration
- Optimized JVM settings for containers

## Configuration

### Environment Variables

You can customize the backend configuration by modifying the `docker-compose.yml` file:

```yaml
environment:
  SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/localsearch
  SPRING_DATASOURCE_USERNAME: localsearch
  SPRING_DATASOURCE_PASSWORD: localsearch123
  OPENAI_API_KEY: ${OPENAI_API_KEY}
```

### Port Mapping

Change ports in `docker-compose.yml`:

```yaml
ports:
  - "8080:8080"  # Change first number for host port
```

## Troubleshooting

### Container won't start
```bash
# Check logs
docker-compose logs backend

# Rebuild container
docker-compose build --no-cache backend
docker-compose up backend
```

### Database connection errors
```bash
# Check if MySQL is healthy
docker-compose ps mysql

# Wait for MySQL to be ready (it may take 20-30 seconds on first start)
docker-compose logs mysql

# Restart backend after MySQL is ready
docker-compose restart backend
```

### Out of memory errors
Increase Docker Desktop memory allocation:
- Docker Desktop → Settings → Resources → Memory

### Clean slate restart
```bash
# Stop and remove everything
docker-compose down -v

# Remove all images
docker-compose down --rmi all

# Start fresh
docker-compose up -d --build
```

## Production Considerations

> [!WARNING]
> The default configuration is for **development only**. For production:

1. **Use secrets management** instead of environment variables
2. **Change default passwords** for MySQL
3. **Enable SSL/TLS** for database connections
4. **Configure proper resource limits**
5. **Use external database** instead of containerized MySQL
6. **Set up proper logging and monitoring**
7. **Enable HTTPS** with reverse proxy (nginx/traefik)

## Next Steps

- Add frontend to Docker Compose
- Set up CI/CD pipeline with Docker
- Deploy to cloud platforms (Azure, AWS, GCP)
- Configure container orchestration (Kubernetes)
