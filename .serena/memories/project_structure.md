# Project Structure

## Repository Layout (Monorepo Hybrid)
```
BI_DA/
├── backend/                          # Java Spring Boot backend
│   └── src/main/java/com/acme/bida/
│       ├── config/                   # Configuration classes
│       ├── auth/                     # Authentication & authorization
│       ├── table/                    # Table management
│       ├── pricing/                  # Pricing rules and calculations
│       ├── booking/                  # Booking system
│       ├── product/                  # F&B product management
│       ├── order/                    # Order processing
│       ├── billing/                  # Billing and invoicing
│       ├── loyalty/                  # Loyalty program
│       ├── report/                   # Reporting and analytics
│       └── integration/              # External integrations
├── apps/                             # Flutter applications
│   ├── staff_app/                    # Staff mobile app
│   ├── user_app/                     # Customer mobile app
│   └── admin_web/                    # Admin web interface
├── packages/                         # Shared Flutter packages
│   ├── core_ui/                      # UI components and theme
│   ├── core_domain/                  # Business entities and use cases
│   ├── core_data/                    # Data layer and repositories
│   └── api_client/                   # Generated API client
├── api/                              # API documentation and mocks
│   ├── openapi.yaml                  # OpenAPI specification
│   └── mock/                         # Mock services
├── devops/                           # Infrastructure and deployment
│   ├── docker-compose.yml            # Local development setup
│   └── nginx.conf                    # Web server configuration
└── docs/                             # Project documentation
    ├── PROJECT_PLAN.md
    ├── ARCHITECTURE.md
    └── CONVENTIONS.md
```

## Flutter App Structure (per app)
```
lib/
├── main.dart                         # App entry point
├── app.dart                          # App configuration
└── core/                             # Core functionality
    ├── router/                       # Navigation
    ├── di/                           # Dependency injection
    └── env/                          # Environment configuration
└── features/                         # Feature modules
    ├── auth/                         # Authentication
    ├── table/                        # Table management
    ├── booking/                      # Booking system
    ├── order/                        # Order management
    ├── billing/                      # Billing and payment
    └── loyalty/                      # Loyalty program
```

## Shared Packages Purpose
- **core_domain**: Business entities, use cases, abstract repositories
- **core_data**: Dio client, data sources, repository implementations, mappers
- **api_client**: OpenAPI code generation (dart-dio)
- **core_ui**: Theme, atomic design components (atoms/molecules/organisms)