# Suggested Commands for Development

## Project Setup and Dependencies

### Backend (Java Spring Boot)
```bash
# Navigate to backend directory
cd backend

# Build with Maven (when pom.xml is added)
mvn clean install

# Run Spring Boot application
mvn spring-boot:run

# Run tests
mvn test

# Run integration tests
mvn verify

# Format code
mvn spotless:apply

# Check code style
mvn spotless:check
```

### Flutter Apps
```bash
# Navigate to specific app
cd apps/staff_app
cd apps/user_app
cd apps/admin_web

# Get dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Build for release
flutter build apk  # Android
flutter build ios  # iOS
flutter build web  # Web

# Format code
dart format .

# Analyze code
flutter analyze
```

### Shared Packages
```bash
# Navigate to package
cd packages/core_ui
cd packages/core_domain
cd packages/core_data
cd packages/api_client

# Get dependencies
flutter pub get

# Run tests
flutter test

# Format code
dart format .
```

## Development Tools

### Docker (Local Development)
```bash
# Start development environment
docker-compose up -d

# Stop development environment
docker-compose down

# View logs
docker-compose logs -f
```

### Database
```bash
# Connect to PostgreSQL
psql -h localhost -U postgres -d bida_club

# Run Flyway migrations
mvn flyway:migrate
```

### API Development
```bash
# Generate OpenAPI client
openapi-generator-cli generate -i api/openapi.yaml -g dart-dio -o packages/api_client

# Start mock server
npx prism mock api/openapi.yaml
```

## Utility Commands

### File Operations
```bash
# List files recursively
find . -name "*.dart" -o -name "*.java" -o -name "*.py"

# Search for patterns
grep -r "TableService" .

# Find files by name
find . -name "main.dart"

# Count lines of code
find . -name "*.dart" -o -name "*.java" | xargs wc -l
```

### Git Operations
```bash
# Check status
git status

# Add changes
git add .

# Commit changes
git commit -m "feat: add table management feature"

# Push changes
git push origin main

# Create feature branch
git checkout -b feature/table-management
```

### System Commands (macOS)
```bash
# List directory contents
ls -la

# Change directory
cd apps/staff_app

# Create directories
mkdir -p lib/features/table

# Copy files
cp template.dart lib/features/table/table_service.dart

# Move files
mv old_file.dart new_file.dart

# Remove files
rm unused_file.dart
```

## Testing Commands

### Backend Testing
```bash
# Unit tests
mvn test

# Integration tests
mvn verify

# Run specific test
mvn test -Dtest=TableServiceTest
```

### Flutter Testing
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Run specific test
flutter test test/table_service_test.dart

# Coverage report
flutter test --coverage
```

## Code Quality

### Linting and Formatting
```bash
# Java (when configured)
mvn spotless:apply

# Dart/Flutter
dart format .
flutter analyze
```

### Performance
```bash
# Flutter performance profiling
flutter run --profile

# Memory profiling
flutter run --trace-startup
```