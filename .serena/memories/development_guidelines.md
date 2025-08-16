# Development Guidelines

## Project Philosophy
- **Multi-tenant First**: All features must support multi-tenancy
- **Real-time Updates**: Prioritize real-time user experience
- **Mobile-First**: Design for mobile apps, adapt for web
- **API-First**: OpenAPI as the single source of truth
- **Test-Driven**: Write tests alongside feature development

## Architecture Principles
- **Clean Architecture**: Separation of concerns across layers
- **Domain-Driven Design**: Business logic in domain layer
- **Repository Pattern**: Abstract data access layer
- **Provider Pattern**: State management in Flutter apps
- **Adapter Pattern**: External service integrations

## Code Organization

### Backend (Java)
- **Package Structure**: `com.acme.bida.{module}`
- **Layer Separation**: Controller → Service → Repository → Entity
- **Configuration**: Environment-specific configuration
- **Security**: JWT authentication with role-based access
- **Database**: PostgreSQL with Flyway migrations

### Frontend (Flutter)
- **Feature-based Structure**: Each feature in its own directory
- **Shared Packages**: Common functionality extracted
- **State Management**: Provider pattern with repositories
- **Navigation**: Declarative routing
- **UI Components**: Atomic design system

## Development Workflow
1. **Feature Planning**: Define requirements and API contracts
2. **Backend Development**: Implement API endpoints and business logic
3. **Frontend Development**: Build UI components and integration
4. **Testing**: Unit, integration, and end-to-end tests
5. **Code Review**: Peer review and quality checks
6. **Deployment**: Staging and production deployment

## Quality Standards
- **Code Coverage**: Minimum 80% test coverage
- **Performance**: Sub-second API response times
- **Security**: OWASP compliance for web applications
- **Accessibility**: WCAG 2.1 AA compliance
- **Internationalization**: Support for Vietnamese and English

## Best Practices
- **Error Handling**: Graceful error handling with user feedback
- **Logging**: Structured logging for debugging and monitoring
- **Configuration**: Environment-specific configuration management
- **Documentation**: Comprehensive API and code documentation
- **Version Control**: Semantic versioning and conventional commits