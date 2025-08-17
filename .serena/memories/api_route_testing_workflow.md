# API Route Testing Workflow for BI_DA Project

## 🎯 **Complete Testing Flow After Adding an API Route**

### **Step 1: Modify Code**
```bash
# 1. Add/Modify Java Controller
vim backend/src/main/java/com/acme/bida/controller/YourController.java

# 2. Add/Modify Service Layer (if needed)
vim backend/src/main/java/com/acme/bida/service/YourService.java

# 3. Add/Modify Repository Layer (if needed)
vim backend/src/main/java/com/acme/bida/repository/YourRepository.java

# 4. Add/Modify Entity/DTO (if needed)
vim backend/src/main/java/com/acme/bida/domain/entity/YourEntity.java
vim backend/src/main/java/com/acme/bida/dto/YourDTO.java
```

### **Step 2: Build Java Application**
```bash
# Navigate to backend directory
cd backend

# Clean and build the project
./gradlew clean build

# Check for compilation errors
./gradlew compileJava

# Run tests (if any exist)
./gradlew test

# Build JAR file
./gradlew bootJar
```

### **Step 3: Start Docker Services**
```bash
# Navigate back to project root
cd ..

# Option 1: Use the provided script
./scripts/docker-dev.sh start

# Option 2: Manual Docker commands
docker-compose down
docker-compose up --build -d

# Check if services are running
docker-compose ps

# Check service health
./scripts/docker-dev.sh health
```

### **Step 4: Wait for Services to Be Ready**
```bash
# Check backend logs
docker-compose logs -f backend

# Wait for these indicators:
# - "Started BidaApplication in X.XXX seconds"
# - "Tomcat started on port(s): 8080"
# - Database connection established
```

### **Step 5: Run All Test Cases**

#### **A. Unit Tests (if implemented)**
```bash
cd backend
./gradlew test
```

#### **B. Integration Tests (if implemented)**
```bash
cd backend
./gradlew integrationTest
```

#### **C. API Contract Tests (if implemented)**
```bash
cd backend
./gradlew contractTest
```

### **Step 6: API Testing with Curl**

#### **A. Health Check First**
```bash
# Test if backend is responding
curl -X GET http://localhost:8080/api/v1/health
curl -X GET http://localhost:8080/api/v1/simple/health
```

#### **B. Authentication (if required)**
```bash
# Login to get JWT token
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"password123"}'

# Extract JWT token from response
JWT_TOKEN="your_jwt_token_here"
```

#### **C. Test Your New API Route**

**Example: Testing a GET endpoint**
```bash
# Without authentication
curl -X GET http://localhost:8080/api/v1/your-endpoint

# With authentication
curl -X GET http://localhost:8080/api/v1/your-endpoint \
  -H "Authorization: Bearer $JWT_TOKEN"
```

**Example: Testing a POST endpoint**
```bash
# Create new resource
curl -X POST http://localhost:8080/api/v1/your-endpoint \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d '{
    "field1": "value1",
    "field2": "value2"
  }'
```

**Example: Testing a PUT endpoint**
```bash
# Update existing resource
curl -X PUT http://localhost:8080/api/v1/your-endpoint/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -d '{
    "field1": "updated_value1",
    "field2": "updated_value2"
  }'
```

**Example: Testing a DELETE endpoint**
```bash
# Delete resource
curl -X DELETE http://localhost:8080/api/v1/your-endpoint/1 \
  -H "Authorization: Bearer $JWT_TOKEN"
```

### **Step 7: Run Complete API Test Suite**
```bash
# Use the comprehensive test script
./scripts/test_api.sh

# This script tests:
# - Health checks
# - Authentication
# - Login/logout
# - All CRUD operations
# - Error handling
# - Protected endpoints
# - Swagger UI accessibility
```

### **Step 8: Manual Testing with Swagger UI**
```bash
# Open Swagger UI in browser
open http://localhost:8080/api/v1/swagger-ui/index.html

# Or use curl to get OpenAPI spec
curl http://localhost:8080/api/v1/api-docs
```

### **Step 9: Database Verification**
```bash
# Access PostgreSQL database
./scripts/docker-dev.sh db

# Or direct access
docker-compose exec postgres psql -U bida_user -d bida_db

# Check if data was created/updated correctly
SELECT * FROM your_table_name;
```

### **Step 10: Log Analysis**
```bash
# Check backend logs for errors
docker-compose logs backend | grep ERROR

# Check application logs
docker-compose logs backend | grep "YourController"

# Monitor real-time logs
docker-compose logs -f backend
```

## 🔧 **Useful Testing Commands**

### **Quick Health Check**
```bash
# One-liner to check if everything is working
curl -s http://localhost:8080/api/v1/health | jq .
```

### **Test with Different HTTP Methods**
```bash
# Test all HTTP methods
curl -X GET http://localhost:8080/api/v1/your-endpoint
curl -X POST http://localhost:8080/api/v1/your-endpoint -d '{}'
curl -X PUT http://localhost:8080/api/v1/your-endpoint/1 -d '{}'
curl -X DELETE http://localhost:8080/api/v1/your-endpoint/1
```

### **Test Error Scenarios**
```bash
# Test with invalid data
curl -X POST http://localhost:8080/api/v1/your-endpoint \
  -H "Content-Type: application/json" \
  -d '{"invalid": "data"}'

# Test with missing authentication
curl -X GET http://localhost:8080/api/v1/your-endpoint

# Test with invalid ID
curl -X GET http://localhost:8080/api/v1/your-endpoint/999999
```

### **Performance Testing**
```bash
# Test response time
time curl -X GET http://localhost:8080/api/v1/your-endpoint

# Load testing (if you have ab installed)
ab -n 100 -c 10 http://localhost:8080/api/v1/your-endpoint
```

## 📋 **Testing Checklist**

### **Before Testing**
- [ ] Code compiles without errors
- [ ] Docker services are running
- [ ] Database is accessible
- [ ] JWT token is obtained (if authentication required)

### **During Testing**
- [ ] Health check passes
- [ ] Authentication works
- [ ] CRUD operations work correctly
- [ ] Error handling works
- [ ] Response format is correct
- [ ] Database state is consistent

### **After Testing**
- [ ] All tests pass
- [ ] Logs show no errors
- [ ] Swagger UI reflects changes
- [ ] Documentation is updated (if needed)

## 🚨 **Common Issues and Solutions**

### **Build Issues**
```bash
# Clean and rebuild
cd backend
./gradlew clean build

# Check for dependency issues
./gradlew dependencies
```

### **Docker Issues**
```bash
# Restart services
./scripts/docker-dev.sh restart

# Reset database
./scripts/docker-dev.sh reset

# Check service status
docker-compose ps
```

### **API Issues**
```bash
# Check if backend is running
curl http://localhost:8080/api/v1/health

# Check logs
docker-compose logs backend

# Verify database connection
docker-compose exec postgres psql -U bida_user -d bida_db -c "SELECT 1;"
```

## 📊 **Expected Test Results**

### **Successful Response Examples**
```json
// GET /api/v1/your-endpoint
{
  "id": 1,
  "name": "Test Resource",
  "createdAt": "2024-01-01T00:00:00Z"
}

// POST /api/v1/your-endpoint
{
  "id": 2,
  "name": "New Resource",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### **Error Response Examples**
```json
// 401 Unauthorized
{
  "error": "Unauthorized",
  "message": "Access denied"
}

// 404 Not Found
{
  "error": "Not Found",
  "message": "Resource not found"
}

// 400 Bad Request
{
  "error": "Bad Request",
  "message": "Validation failed",
  "details": ["Field 'name' is required"]
}
```

This comprehensive testing workflow ensures that your new API route is properly implemented, tested, and ready for production use.