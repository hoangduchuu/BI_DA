# Code Style and Conventions

## Java (Spring Boot Backend)
- **Package Naming**: `com.acme.bida.{module}`
- **Class Naming**: PascalCase (e.g., `BidaApplication`, `TableService`)
- **Method Naming**: camelCase (e.g., `getTableStatus`, `createBooking`)
- **Constants**: UPPER_SNAKE_CASE
- **Annotations**: Spring Boot annotations (`@SpringBootApplication`, `@RestController`)
- **Documentation**: JavaDoc for public APIs

## Dart/Flutter (Frontend Apps)
- **File Naming**: snake_case (e.g., `main.dart`, `table_service.dart`)
- **Class Naming**: PascalCase (e.g., `BidaStaffApp`, `HomePage`)
- **Variable/Method Naming**: camelCase (e.g., `tableStatus`, `createBooking`)
- **Constants**: lowerCamelCase with `const` keyword
- **Widget Naming**: PascalCase with descriptive names
- **Documentation**: Triple-slash comments for public APIs

## Project Structure Conventions
- **Feature-based Organization**: Each feature has its own directory
- **Separation of Concerns**: UI, business logic, and data layers separated
- **Shared Packages**: Common functionality extracted to packages
- **Naming**: Descriptive, domain-specific names

## Code Quality Standards
- **Type Safety**: Strong typing in both Java and Dart
- **Null Safety**: Dart null safety enabled
- **Error Handling**: Proper exception handling and user feedback
- **Testing**: Unit tests, integration tests, and contract tests
- **Documentation**: Clear, concise documentation for public APIs

## File Organization
- **Backend**: Package-based organization with clear module separation
- **Frontend**: Feature-based organization with shared packages
- **Configuration**: Environment-specific configuration files
- **Documentation**: Markdown files for project documentation