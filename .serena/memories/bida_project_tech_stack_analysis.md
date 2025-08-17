# BI_DA Project - Technology Stack Analysis

## Project Overview
BI_DA is a **Billiard Club Management System** built with **Java Spring Boot** backend and **Flutter** frontend applications. This is a multi-tenant system supporting multiple companies, clubs, and tables with comprehensive business management features.

## Technology Stack

### Backend (Java Spring Boot)
- **Framework**: Spring Boot 3.2.0 with Java 21
- **Database**: PostgreSQL 15 with Flyway migrations
- **Security**: Spring Security with JWT authentication
- **API Documentation**: OpenAPI/Swagger 2.2.0
- **Build Tool**: Gradle with Kotlin DSL
- **Key Dependencies**:
  - Spring Boot Starters (Web, Data JPA, Security, Validation, WebSocket, Actuator)
  - JWT (jjwt-api 0.12.3)
  - PostgreSQL driver
  - Lombok for boilerplate reduction
  - Testcontainers for integration testing

### Frontend (Flutter)
- **Framework**: Flutter with Dart SDK ^3.4.0-^3.8.1
- **State Management**: Provider ^6.1.2
- **Navigation**: Go Router ^14.2.7
- **HTTP Client**: Dio ^5.4.3+1
- **Local Storage**: Shared Preferences ^2.2.3
- **UI Components**: Flutter SVG ^2.0.10+1, Cupertino Icons ^1.0.8
- **Date/Time**: Intl ^0.19.0

### Applications Architecture
The project follows a **monorepo structure** with shared packages:

#### Flutter Applications:
1. **admin_web** (`bida_admin_web`) - Web dashboard for administrators
2. **staff_app** (`bida_staff_app`) - Mobile app for staff members
3. **user_app** (`bida_user_app`) - Mobile app for customers

#### Shared Packages:
- **core_ui** - Shared UI components and theme
- **core_domain** - Business entities and use cases
- **core_data** - Data layer and repository implementations
- **api_client** - HTTP client for backend communication

### API Client Configuration
- **Base URL**: `https://3f3d8a3a8bb0.ngrok-free.app/api/v1`
- **Authentication**: JWT with Bearer token
- **Token Management**: Automatic refresh token handling
- **Error Handling**: 401 auto-refresh with retry mechanism

### Backend Package Structure
```
com.acme.bida/
├── config/          # Configuration classes
├── auth/           # Authentication & authorization
├── controller/     # REST controllers
├── service/        # Business logic services
├── repository/     # Data access layer
├── domain/         # Entity models
├── dto/           # Data transfer objects
├── table/         # Table management
├── booking/       # Booking system
├── order/         # Food & beverage orders
├── billing/       # Billing & payments
├── loyalty/       # Loyalty program
├── pricing/       # Dynamic pricing
├── product/       # Product management
├── report/        # Reporting system
└── integration/   # External integrations
```

### Database & Infrastructure
- **Database**: PostgreSQL with Flyway migrations
- **Containerization**: Docker with docker-compose
- **Development**: Local development with Docker Compose
- **Deployment**: Supports Raspberry Pi 5 (ARM64) and cloud deployment

### Business Features
1. **Multi-tenancy**: Company → Club → Table hierarchy
2. **Table Management**: Status tracking (available/occupied/reserved)
3. **Booking System**: Session management with start/stop/pause
4. **Pricing**: Dynamic pricing based on peak/off-peak hours
5. **F&B Orders**: Food and beverage ordering system
6. **Billing**: Comprehensive billing with payment integration
7. **Loyalty Program**: Points, tiers, and promotions
8. **Reporting**: Operational and financial reports
9. **Real-time Updates**: WebSocket integration for live status

### Payment Integration
- **Supported Providers**: Momo, ZaloPay
- **Webhook Support**: Payment confirmation callbacks
- **Adapter Pattern**: Extensible for additional payment methods

### Development Workflow
- **API-First**: OpenAPI specification drives development
- **Mocking**: Prism/Mockoon for frontend development
- **Testing**: Unit, integration, and contract testing
- **CI/CD**: GitHub Actions with Docker deployment

### Security Features
- **JWT Authentication**: Access and refresh tokens
- **Role-Based Access**: Owner, Club Manager, Staff, Customer roles
- **CORS Configuration**: Domain-specific access control
- **Rate Limiting**: Protection for sensitive endpoints

### Key Configuration Files
- `backend/build.gradle.kts` - Backend dependencies and build configuration
- `apps/*/pubspec.yaml` - Flutter app dependencies
- `packages/*/pubspec.yaml` - Shared package configurations
- `docker-compose.yml` - Development environment setup
- `packages/api_client/lib/src/api_client.dart` - API client configuration

### Development Commands
- Backend: `./gradlew bootRun` (from backend directory)
- Flutter Apps: `flutter run` (from respective app directories)
- Docker: `docker-compose up` (from root directory)

### Important Notes
- **No Python**: This project uses Java Spring Boot, not Python
- **Flutter Web**: Admin dashboard runs on Flutter Web
- **Multi-platform**: Flutter apps support Android, iOS, Web, Desktop
- **Shared Architecture**: Common packages ensure consistency across apps
- **Real-time Features**: WebSocket integration for live updates
- **Scalable Design**: Multi-tenant architecture supports multiple clubs