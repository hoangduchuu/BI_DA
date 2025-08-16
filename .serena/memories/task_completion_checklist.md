# Task Completion Checklist

## Before Completing Any Task

### Code Quality Checks
- [ ] **Code Formatting**: Run formatter for the language
  - Java: `mvn spotless:apply`
  - Dart: `dart format .`
- [ ] **Linting**: Check for code quality issues
  - Java: `mvn spotless:check`
  - Dart: `flutter analyze`
- [ ] **Type Safety**: Ensure all types are properly defined
- [ ] **Null Safety**: Check for null safety compliance (Dart)
- [ ] **Documentation**: Add/update relevant documentation

### Testing
- [ ] **Unit Tests**: Write/update unit tests for new functionality
- [ ] **Integration Tests**: Test component interactions
- [ ] **API Tests**: Verify API contracts (when applicable)
- [ ] **Manual Testing**: Test the feature manually
- [ ] **Cross-platform Testing**: Test on different platforms (Flutter)

### Code Review Checklist
- [ ] **Architecture Compliance**: Follow project architecture patterns
- [ ] **Naming Conventions**: Use consistent naming across the project
- [ ] **Error Handling**: Proper exception handling and user feedback
- [ ] **Performance**: No obvious performance issues
- [ ] **Security**: Follow security best practices
- [ ] **Multi-tenancy**: Ensure proper tenant isolation (backend)

### Documentation Updates
- [ ] **API Documentation**: Update OpenAPI spec if needed
- [ ] **Code Comments**: Add inline documentation for complex logic
- [ ] **README Updates**: Update relevant documentation
- [ ] **Change Log**: Document significant changes

## Language-Specific Checks

### Java (Backend)
- [ ] **Spring Boot Conventions**: Follow Spring Boot best practices
- [ ] **JPA/Hibernate**: Proper entity relationships and queries
- [ ] **Database Migrations**: Add Flyway migrations for schema changes
- [ ] **Service Layer**: Business logic in service classes
- [ ] **Controller Layer**: REST endpoints properly defined
- [ ] **Exception Handling**: Global exception handling configured

### Dart/Flutter (Frontend)
- [ ] **Widget Structure**: Proper widget hierarchy and composition
- [ ] **State Management**: Use Provider pattern consistently
- [ ] **Repository Pattern**: Data access through repository layer
- [ ] **Navigation**: Proper routing and navigation
- [ ] **UI/UX**: Follow Material Design principles
- [ ] **Responsive Design**: Work on different screen sizes

### Shared Packages
- [ ] **Package Dependencies**: Proper dependency management
- [ ] **API Contracts**: Generated client code is up to date
- [ ] **Shared Components**: Reusable components properly abstracted
- [ ] **Version Compatibility**: Ensure compatibility across apps

## Final Steps
- [ ] **Git Operations**: Commit changes with descriptive messages
- [ ] **Branch Management**: Merge feature branches appropriately
- [ ] **Deployment**: Test in development environment
- [ ] **Monitoring**: Ensure proper logging and monitoring
- [ ] **Performance**: Verify no performance regressions