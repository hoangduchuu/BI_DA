# Architecture Design

## System Architecture
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Staff App     │    │   User App      │    │   Admin Web     │
│   (Flutter)     │    │   (Flutter)     │    │   (Flutter Web) │
└─────────┬───────┘    └─────────┬───────┘    └─────────┬───────┘
          │                      │                      │
          └──────────────────────┼──────────────────────┘
                                 │
                    ┌─────────────▼─────────────┐
                    │      Backend API          │
                    │   (Spring Boot 3)         │
                    │  REST + WebSocket/STOMP   │
                    └─────────────┬─────────────┘
                                  │
                    ┌─────────────▼─────────────┐
                    │      PostgreSQL           │
                    │      (Database)           │
                    └─────────────┬─────────────┘
                                  │
                    ┌─────────────▼─────────────┐
                    │   External Services       │
                    │  • Momo/ZaloPay           │
                    │  • E-Invoice/ERP          │
                    └───────────────────────────┘
```

## Multi-Tenancy Design
- **Data Isolation**: Every table has `company_id` and `club_id`
- **Role-Based Access**: Owner(Admin Company), Club Manager, Staff, Customer
- **Performance**: Indexed by `club_id`, `table_id`, and time
- **Security**: Tenant filtering at repository/service layer

## Real-time Communication
- **Protocol**: Spring WebSocket + STOMP
- **Topics**: `/topic/clubs/{clubId}/tables`
- **Events**: Table status changes, orders, billing updates
- **Future**: Spring WebFlux/RSocket for reactive architecture

## Payment Integration
- **Service Pattern**: `PaymentService` interface with provider implementations
- **Flow**: Create payment → Redirect → Webhook confirmation → Update bill → WS event
- **Audit**: `payment_attempts` table for tracking status, payload, and signatures

## API Design
- **Documentation**: OpenAPI (Swagger) as the single source of truth
- **Code Generation**: dart-dio for Flutter client generation
- **Contract Testing**: API contracts for frontend-backend integration
- **Mocking**: Prism/Mockoon for frontend development before backend completion