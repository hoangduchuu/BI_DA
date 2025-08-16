    # Git Commit Rules - Billiard Club Management System

## Commit Message Format
```
[PREFIX] Subject line (50 characters max)

Optional body (wrap at 72 characters)
- Detail 1
- Detail 2

Optional footer
```

## Commit Prefixes

### **[DEV]** - New Development/Features
- New feature implementation
- New functionality added
- Initial development work
- **Example**: `[DEV] Implement authentication system for all 3 Flutter apps`

### **[TEST]** - Testing Related
- Adding tests
- Updating test cases
- Test fixes
- Testing infrastructure
- **Example**: `[TEST] Add unit tests for authentication providers`

### **[FIX]** - Bug Fixes
- Bug fixes
- Error corrections
- Issue resolutions
- Hotfixes
- **Example**: `[FIX] Resolve JWT token refresh issue in AuthProvider`

### **[DOCS]** - Documentation
- Documentation updates
- README changes
- Code comments
- API documentation
- **Example**: `[DOCS] Update API documentation with authentication endpoints`

### **[RFT]** - Refactoring
- Code refactoring
- Structure improvements
- Code optimization
- Performance improvements
- **Example**: `[RFT] Restructure data layer with repository pattern`

## Additional Prefixes (Optional)

### **[STYLE]** - Code Style/Formatting
- Code formatting
- Linting fixes
- Style guide compliance
- **Example**: `[STYLE] Fix Flutter analyze warnings in all apps`

### **[DEPS]** - Dependencies
- Dependency updates
- Package additions/removals
- Version bumps
- **Example**: `[DEPS] Update Flutter dependencies to latest versions`

### **[CONFIG]** - Configuration
- Configuration changes
- Environment setup
- Build configuration
- **Example**: `[CONFIG] Add Docker compose configuration for development`

### **[SECURITY]** - Security Related
- Security improvements
- Vulnerability fixes
- Authentication/authorization
- **Example**: `[SECURITY] Implement JWT token validation middleware`

## Commit Rules

### Subject Line Rules:
1. **50 character limit** for subject line
2. **Capitalize** the first letter after prefix
3. **No period** at the end
4. Use **imperative mood** ("Add" not "Added")

### Body Rules:
1. **Wrap at 72 characters**
2. Use bullet points for multiple changes
3. Explain **what** and **why**, not how
4. Reference issue numbers if applicable

### Examples of Good Commits:

```bash
[DEV] Implement multi-tenant authentication system

- Add JWT-based login/logout for staff, user, and admin apps
- Integrate shared data layer with repositories
- Support role-based access control
- Connect to backend API at localhost:8080

[FIX] Resolve Flutter analyze warnings in user_app

- Add missing dependencies in pubspec.yaml
- Fix import statements for shared packages
- Update test files to reference correct app classes

[RFT] Restructure Flutter apps with clean architecture

- Separate domain, data, and presentation layers
- Implement dependency injection pattern
- Add repository interfaces and implementations
- Create reusable authentication providers
```

## Branch Naming Convention

- `feature/authentication-system`
- `bugfix/jwt-token-refresh`
- `hotfix/login-validation`
- `docs/api-documentation`
- `refactor/data-layer-structure`

## Pre-commit Checklist

- [ ] Code passes lint checks (`flutter analyze`)
- [ ] All tests pass
- [ ] No debug/console logs in production code
- [ ] Documentation updated if needed
- [ ] Commit message follows format rules

## Tools Integration

### VS Code Git Commit Template
```json
{
  "git.inputValidationSubjectLength": 50,
  "git.inputValidationLength": 72
}
```

### Git Hooks (Optional)
- Pre-commit: Run lint checks
- Commit-msg: Validate commit message format
- Pre-push: Run tests

---
*Last updated: August 17, 2025*
*Project: Billiard Club Management System*
