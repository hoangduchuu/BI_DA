# Billiard Club Management API - Endpoints Reference

## Base URL
`http://localhost:8080/api/v1`

## Authentication
All protected endpoints require JWT token in Authorization header:
```
Authorization: Bearer <jwt-token>
```

## Endpoints by Category

### 🔍 Health & Status
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/health` | ✅ 200 | API health check with service info |
| GET | `/simple/health` | ✅ 200 | Simple health check |
| GET | `/simple/test` | ✅ 200 | Simple test endpoint |

### 🔐 Authentication
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/auth/health` | ✅ 200 | Auth service health check |
| POST | `/auth/login` | ✅ 200 | Login with username/password |
| GET | `/auth/debug/users` | ✅ 200 | Get all users (debug) |

### 🏢 Companies
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/companies` | ✅ 200 | Get all companies |
| GET | `/companies/{id}` | ✅ 200 | Get company by ID |
| POST | `/companies` | ✅ 200 | Create new company |
| PUT | `/companies/{id}` | ✅ 200 | Update company |
| DELETE | `/companies/{id}` | ⚠️ | Not implemented |

### 👥 Users
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/users` | ✅ 200 | Get all users |
| GET | `/users/{username}` | ✅ 200 | Get user by username |
| POST | `/users/create` | ❌ 500 | Create new user (error) |
| PUT | `/users/{username}` | ⚠️ | Not implemented |
| DELETE | `/users/{username}` | ⚠️ | Not implemented |

### 🐛 Debug Endpoints
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/users/test/hash` | ✅ 200 | Generate password hash |
| GET | `/users/test/password` | ✅ 200 | Test password matching |

### 📚 Documentation
| Method | Endpoint | Status | Description |
|--------|----------|--------|-------------|
| GET | `/api-docs` | ✅ 200 | OpenAPI specification |
| GET | `/swagger-ui/index.html` | ✅ 200 | Swagger UI interface |

## Request/Response Examples

### Login Request
```json
POST /auth/login
{
  "username": "admin",
  "password": "password123"
}
```

### Login Response
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiJ9...",
  "tokenType": null,
  "expiresIn": 86400000,
  "userInfo": {
    "id": 1,
    "username": "admin",
    "email": "admin@acme-bida.com",
    "role": "OWNER",
    "companyId": 1,
    "clubId": null
  }
}
```

### Company Response
```json
{
  "id": 1,
  "name": "ACME Billiard Group",
  "address": "123 Nguyen Van Linh, District 7, Ho Chi Minh City",
  "phone": "+84 28 1234 5678",
  "email": "info@acme-bida.com",
  "createdAt": "2025-08-16T16:25:32.374555",
  "updatedAt": "2025-08-16T16:25:32.374555"
}
```

### User Response
```json
{
  "id": 1,
  "username": "admin",
  "email": "admin@acme-bida.com",
  "passwordHash": "$2a$10$ODnJVZ4gqnJP9vPYwkHFFu39gO9S6D78o49j3DAL7vdaanOJBJ3cK",
  "role": "OWNER",
  "companyId": 1,
  "clubId": null,
  "isActive": true,
  "createdAt": "2025-08-16T16:25:20.361286",
  "updatedAt": "2025-08-16T16:25:32.410153"
}
```

## Error Responses

### 401 Unauthorized
```json
{
  "timestamp": "2025-08-16T17:05:32.04914309",
  "status": 401,
  "error": "Unauthorized",
  "path": "/api/v1/protected-endpoint"
}
```

### 500 Internal Server Error
```json
{
  "timestamp": "2025-08-17T00:05:18",
  "status": 500,
  "error": "Internal Server Error",
  "path": "/api/v1/users/create"
}
```

## Security Status
- ✅ JWT authentication working
- ✅ BCrypt password hashing working
- ❌ Protected endpoints not properly secured
- ⚠️ Debug endpoints accessible in production

## Testing
Use the provided test script:
```bash
./scripts/test_api.sh
```

## Swagger UI
Access interactive documentation at:
http://localhost:8080/api/v1/swagger-ui/index.html