# BI_DA Billiard Club Management System - Complete Setup Guide

## 🎯 **Overview**
This guide covers the complete setup and deployment flow for the BI_DA billiard club management system, including backend API, database, ngrok tunneling, and Flutter applications.

## 📋 **Prerequisites**
- macOS/Linux/Windows
- Docker & Docker Compose
- Java 17+ (for Spring Boot)
- Flutter SDK
- ngrok account (free tier available)
- PostgreSQL (via Docker)

## 🏗️ **System Architecture**
```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐
│   Flutter Apps  │────│  ngrok Tunnel │────│  Spring Boot API │
│  (Admin/Staff/  │    │  (Public URL) │    │   (Backend)     │
│   User Apps)    │    └──────────────┘    └─────────────────┘
└─────────────────┘                                │
                                                   │
                                        ┌─────────────────┐
                                        │   PostgreSQL    │
                                        │   (Database)    │
                                        └─────────────────┘
```

## 🚀 **Complete Setup Flow**

### Step 1: Start Database with Docker

```bash
# Navigate to project root
cd /path/to/BI_DA

# Start PostgreSQL database
docker-compose up -d postgres

# Verify database is running
docker ps | grep postgres
```

**Expected Output:**
```
CONTAINER ID   IMAGE         COMMAND                  CREATED         STATUS         PORTS                    NAMES
abc123def456   postgres:15   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:5432->5432/tcp   bida-postgres
```

### Step 2: Start Spring Boot Backend

```bash
# Navigate to backend directory
cd backend

# Build and run Spring Boot application
./gradlew bootRun

# Alternative: Run with specific profile
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**Expected Output:**
```
Started BidaBackendApplication in 3.456 seconds (JVM running for 4.123)
Server running on: http://localhost:8080
Swagger UI: http://localhost:8080/api/v1/swagger-ui/index.html
```

### Step 3: Create ngrok Tunnel

#### 3.1 Install ngrok
```bash
# macOS with Homebrew
brew install ngrok

# Or download from https://ngrok.com/download
```

#### 3.2 Setup ngrok Authentication
```bash
# Sign up at https://ngrok.com and get your authtoken
ngrok config add-authtoken YOUR_AUTHTOKEN_HERE
```

#### 3.3 Create HTTP Tunnel
```bash
# Create tunnel to Spring Boot backend
ngrok http 8080

# For custom subdomain (paid plan)
ngrok http 8080 --subdomain=bida-api
```

**Expected Output:**
```
Session Status                online
Account                       your-email@example.com
Version                       3.x.x
Region                        United States (us)
Latency                       45ms
Web Interface                 http://127.0.0.1:4040
Forwarding                    https://abc123def456.ngrok-free.app -> http://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

**Important:** Copy the `https://abc123def456.ngrok-free.app` URL - this is your public API endpoint.

### Step 4: Update Flutter App Endpoints

#### 4.1 Update API Configuration
```bash
# Edit the centralized API config
nano packages/api_client/lib/src/config/api_config.dart
```

**Update the baseUrl:**
```dart
class ApiConfig {
  // Replace with your ngrok URL
  static const String baseUrl = 'https://abc123def456.ngrok-free.app/api/v1';
  
  // Other configurations...
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

#### 4.2 Verify All Apps Use Centralized Config
Check that all apps import the centralized config:
- `apps/admin_web/lib/core/di/dependency_injection.dart`
- `apps/staff_app/lib/core/di/dependency_injection.dart`
- `apps/user_app/lib/core/di/dependency_injection.dart`

### Step 5: Run Flutter Applications

#### 5.1 Setup Flutter Environment
```bash
# Set Flutter SDK path
export PATH="/Users/huu/Documents/flutter/bin:$PATH"

# Verify Flutter installation
flutter doctor
```

#### 5.2 Get Dependencies for All Packages
```bash
# Navigate to project root
cd /path/to/BI_DA

# Get dependencies for all packages
cd packages/api_client && flutter pub get
cd ../core_domain && flutter pub get
cd ../core_data && flutter pub get
cd ../core_ui && flutter pub get
```

#### 5.3 Get Dependencies for All Apps
```bash
# Get dependencies for all apps
cd ../../apps/admin_web && flutter pub get
cd ../staff_app && flutter pub get
cd ../user_app && flutter pub get
```

#### 5.4 Run Applications

**Admin Web App (Chrome):**
```bash
cd apps/admin_web
flutter run -d chrome --web-port=8081
```
Access: `http://localhost:8081`

**Staff App (Chrome):**
```bash
cd apps/staff_app
flutter run -d chrome --web-port=8082
```
Access: `http://localhost:8082`

**User App (Chrome):**
```bash
cd apps/user_app
flutter run -d chrome --web-port=8083
```
Access: `http://localhost:8083`

**User App (macOS Desktop):**
```bash
cd apps/user_app
flutter run -d macos
```

## 🔧 **Configuration Files**

### Docker Compose Configuration
Location: `docker-compose.yml`
```yaml
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: bida_db
      POSTGRES_USER: bida_user
      POSTGRES_PASSWORD: bida_password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Spring Boot Configuration
Location: `backend/src/main/resources/application.yml`
```yaml
server:
  port: 8080

spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/bida_db
    username: bida_user
    password: bida_password
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
```

### Flutter API Configuration
Location: `packages/api_client/lib/src/config/api_config.dart`
```dart
class ApiConfig {
  static const String baseUrl = 'https://YOUR_NGROK_URL.ngrok-free.app/api/v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

## 🚨 **Troubleshooting**

### Common Issues and Solutions

#### 1. Database Connection Failed
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Restart database
docker-compose restart postgres

# Check logs
docker-compose logs postgres
```

#### 2. ngrok Tunnel Not Working
```bash
# Check ngrok status
curl -s http://localhost:4040/api/tunnels | jq

# Restart ngrok
pkill ngrok
ngrok http 8080
```

#### 3. Flutter App Can't Connect to API
- Verify ngrok URL is updated in `ApiConfig`
- Check if backend is running on port 8080
- Test API directly: `curl https://your-ngrok-url.ngrok-free.app/api/v1/health`

#### 4. CORS Issues
Add to Spring Boot `application.yml`:
```yaml
spring:
  web:
    cors:
      allowed-origins: "*"
      allowed-methods: "*"
      allowed-headers: "*"
```

## 📊 **System Status Check**

### Health Check Commands
```bash
# Check database
docker exec -it bida-postgres psql -U bida_user -d bida_db -c "SELECT version();"

# Check backend API
curl http://localhost:8080/api/v1/health

# Check ngrok tunnel
curl https://your-ngrok-url.ngrok-free.app/api/v1/health

# Check Flutter apps
curl http://localhost:8081  # Admin Web
curl http://localhost:8082  # Staff App
curl http://localhost:8083  # User App
```

## 🎯 **Quick Start Script**

Create `start-system.sh`:
```bash
#!/bin/bash
echo "🚀 Starting BI_DA System..."

# Start database
echo "📊 Starting PostgreSQL..."
docker-compose up -d postgres

# Wait for database
sleep 10

# Start backend
echo "🔧 Starting Spring Boot backend..."
cd backend && ./gradlew bootRun &
BACKEND_PID=$!

# Wait for backend
sleep 30

# Start ngrok
echo "🌐 Starting ngrok tunnel..."
ngrok http 8080 &
NGROK_PID=$!

echo "✅ System started successfully!"
echo "📊 Database: Running on port 5432"
echo "🔧 Backend: http://localhost:8080"
echo "🌐 ngrok: Check http://localhost:4040 for public URL"
echo "📱 Update Flutter apps with ngrok URL and run them"

# Keep script running
wait $BACKEND_PID
```

Make executable and run:
```bash
chmod +x start-system.sh
./start-system.sh
```

## 📝 **Development Workflow**

1. **Start Infrastructure**: Database + Backend + ngrok
2. **Update API Endpoints**: Copy ngrok URL to Flutter config
3. **Run Flutter Apps**: Start all three applications
4. **Development**: Use hot reload for rapid development
5. **Testing**: Test API endpoints via Swagger UI
6. **Deployment**: Update production endpoints when ready

## 🔗 **Useful URLs**

- **Backend API**: `http://localhost:8080`
- **Swagger UI**: `http://localhost:8080/api/v1/swagger-ui/index.html`
- **ngrok Dashboard**: `http://localhost:4040`
- **Admin Web**: `http://localhost:8081`
- **Staff App**: `http://localhost:8082`
- **User App**: `http://localhost:8083`
- **Database**: `localhost:5432`

---

**📞 Support**: For issues, check the troubleshooting section or review application logs.
