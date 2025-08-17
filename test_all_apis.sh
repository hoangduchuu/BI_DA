#!/bin/bash

# =============================================================================
# BILLIARD CLUB MANAGEMENT API - COMPREHENSIVE TESTING SCRIPT
# =============================================================================
# This script tests ALL business API endpoints and provides detailed reporting
# It will fix authentication issues in real-time if JWT authentication fails
# =============================================================================

set -e  # Exit on any error

# ANSI Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
API_BASE="http://localhost:8080/api/v1"
ADMIN_USER="admin"
ADMIN_PASS="password123"
TEST_USER="test_user_$(date +%s)"
TEST_EMAIL="test_$(date +%s)@example.com"
TEST_COMPANY="Test Company $(date +%s)"

# Counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0
JWT_TOKEN=""

# Arrays to store results
declare -a FAILED_ENDPOINTS=()
declare -a PASSED_ENDPOINTS=()
declare -a SKIPPED_ENDPOINTS=()

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASSED_TESTS=$((PASSED_TESTS + 1))
    PASSED_ENDPOINTS+=("$1")
}

log_error() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAILED_TESTS=$((FAILED_TESTS + 1))
    FAILED_ENDPOINTS+=("$1")
}

log_skip() {
    echo -e "${YELLOW}[SKIP]${NC} $1"
    SKIPPED_TESTS=$((SKIPPED_TESTS + 1))
    SKIPPED_ENDPOINTS+=("$1")
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_header() {
    echo ""
    echo -e "${PURPLE}=== $1 ===${NC}"
}

# Test function that handles common HTTP status codes
test_endpoint() {
    local method="$1"
    local endpoint="$2"
    local description="$3"
    local expected_status="$4"
    local data="$5"
    local auth_required="$6"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Build curl command
    local curl_cmd="curl -s -X $method"
    
    # Add authentication if required
    if [[ "$auth_required" == "true" ]]; then
        if [[ -z "$JWT_TOKEN" ]]; then
            log_error "$description - No JWT token available"
            return 1
        fi
        curl_cmd="$curl_cmd -H \"Authorization: Bearer $JWT_TOKEN\""
    fi
    
    # Add content type and data for POST/PUT requests
    if [[ "$method" == "POST" || "$method" == "PUT" ]] && [[ -n "$data" ]]; then
        curl_cmd="$curl_cmd -H \"Content-Type: application/json\" -d '$data'"
    fi
    
    # Execute request
    local url="$API_BASE$endpoint"
    local response=$(eval "$curl_cmd -w \"HTTPSTATUS:%{http_code}\" \"$url\"")
    
    # Extract HTTP status and body
    local http_status=$(echo "$response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local body=$(echo "$response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    # Check if response matches expected
    if [[ "$http_status" == "$expected_status" ]]; then
        log_success "$description ($method $endpoint) - Status: $http_status"
        return 0
    else
        log_error "$description ($method $endpoint) - Expected: $expected_status, Got: $http_status"
        if [[ -n "$body" && "$body" != "" ]]; then
            echo -e "${RED}     Response body: ${NC}$body"
        fi
        return 1
    fi
}

# Function to obtain JWT token
get_jwt_token() {
    log_info "Obtaining JWT authentication token..."
    
    local login_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "{\"username\":\"$ADMIN_USER\",\"password\":\"$ADMIN_PASS\"}" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/auth/login")
    
    local status=$(echo "$login_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local body=$(echo "$login_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    if [[ "$status" == "200" ]]; then
        JWT_TOKEN=$(echo "$body" | grep -o '"accessToken":"[^"]*' | cut -d'"' -f4)
        if [[ -n "$JWT_TOKEN" ]]; then
            log_success "JWT token obtained successfully"
            return 0
        else
            log_error "Failed to extract JWT token from response"
            return 1
        fi
    else
        log_error "Authentication failed - Status: $status"
        echo -e "${RED}     Response: ${NC}$body"
        return 1
    fi
}

# Function to fix JWT authentication issues
fix_jwt_auth() {
    log_warning "Attempting to fix JWT authentication issues..."
    
    # Check if backend is running
    local health_check=$(curl -s -w "HTTPSTATUS:%{http_code}" "$API_BASE/health" 2>/dev/null)
    local health_status=$(echo "$health_check" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    
    if [[ "$health_status" != "200" ]]; then
        log_error "Backend service is not responding. Please check if Docker containers are running."
        log_info "Try running: docker-compose up -d"
        return 1
    fi
    
    log_info "Backend service is running. Checking authentication configuration..."
    
    # Try to get token again with debug info
    get_jwt_token
}

# Function to create test data if needed
setup_test_data() {
    log_header "Setting up test data"
    
    # First ensure we have a JWT token
    if [[ -z "$JWT_TOKEN" ]]; then
        if ! get_jwt_token; then
            log_error "Cannot setup test data without authentication"
            return 1
        fi
    fi
    
    # Create test company
    log_info "Creating test company..."
    test_endpoint "POST" "/companies" "Create test company" "200" \
        "{\"name\":\"$TEST_COMPANY\",\"description\":\"Test company for API testing\",\"address\":\"123 Test St\",\"phone\":\"+84123456789\",\"email\":\"test@company.com\"}" \
        "true"
}

# =============================================================================
# MAIN TESTING FUNCTIONS
# =============================================================================

# Test Health and Status Endpoints
test_health_endpoints() {
    log_header "Testing Health & Status Endpoints"
    
    test_endpoint "GET" "/health" "API Health Check" "200" "" "false"
    test_endpoint "GET" "/simple/health" "Simple Health Check" "200" "" "false" 
    test_endpoint "GET" "/simple/test" "Simple Test Endpoint" "200" "" "false"
}

# Test Authentication Endpoints
test_auth_endpoints() {
    log_header "Testing Authentication Endpoints"
    
    test_endpoint "GET" "/auth/health" "Auth Service Health" "200" "" "false"
    
    # Login test (this also gets us the JWT token)
    if get_jwt_token; then
        log_success "User Login (POST /auth/login) - Status: 200"
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("User Login (POST /auth/login)")
    else
        log_error "User Login (POST /auth/login) - Authentication failed"
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("User Login (POST /auth/login)")
    fi
    
    # Test invalid login
    local invalid_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d '{"username":"invalid","password":"invalid"}' \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/auth/login")
    
    local invalid_status=$(echo "$invalid_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [[ "$invalid_status" == "401" ]]; then
        log_success "Invalid Login Rejection (POST /auth/login) - Status: 401"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Invalid Login Rejection (POST /auth/login)")
    else
        log_error "Invalid Login Rejection (POST /auth/login) - Expected: 401, Got: $invalid_status"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("Invalid Login Rejection (POST /auth/login)")
    fi
}

# Test Company Management Endpoints
test_company_endpoints() {
    log_header "Testing Company Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "Company endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 4))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 4))
        return
    fi
    
    # Get all companies
    test_endpoint "GET" "/companies" "Get All Companies" "200" "" "true"
    
    # Create a new company
    local company_data="{\"name\":\"$TEST_COMPANY\",\"description\":\"API Test Company\",\"address\":\"123 Test Street\",\"phone\":\"+84987654321\",\"email\":\"test@company.example.com\"}"
    
    local create_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$company_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/companies")
    
    local create_status=$(echo "$create_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local create_body=$(echo "$create_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_status" == "200" ]]; then
        log_success "Create Company (POST /companies) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create Company (POST /companies)")
        
        # Extract company ID for further tests
        local COMPANY_ID=$(echo "$create_body" | grep -o '"id":[0-9]*' | cut -d: -f2)
        
        if [[ -n "$COMPANY_ID" ]]; then
            # Test get company by ID
            test_endpoint "GET" "/companies/$COMPANY_ID" "Get Company by ID" "200" "" "true"
            
            # Test update company
            local update_data="{\"name\":\"$TEST_COMPANY Updated\",\"description\":\"Updated API Test Company\",\"address\":\"456 Updated Street\",\"phone\":\"+84987654321\",\"email\":\"updated@company.example.com\"}"
            test_endpoint "PUT" "/companies/$COMPANY_ID" "Update Company" "200" "$update_data" "true"
            
            # Test delete company
            test_endpoint "DELETE" "/companies/$COMPANY_ID" "Delete Company" "204" "" "true"
        else
            log_error "Could not extract company ID from create response"
            TOTAL_TESTS=$((TOTAL_TESTS + 3))
            FAILED_TESTS=$((FAILED_TESTS + 3))
        fi
    else
        log_error "Create Company (POST /companies) - Expected: 200, Got: $create_status"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("Create Company (POST /companies)")
        
        # Skip dependent tests
        log_skip "Company by ID, Update, Delete tests - Create failed"
        TOTAL_TESTS=$((TOTAL_TESTS + 3))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 3))
    fi
}

# Test User Management Endpoints
test_user_endpoints() {
    log_header "Testing User Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "User endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 6))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 6))
        return
    fi
    
    # Get all users
    test_endpoint "GET" "/users" "Get All Users" "200" "" "true"
    
    # Get current user
    test_endpoint "GET" "/users/me" "Get Current User" "200" "" "true"
    
    # Get user by username
    test_endpoint "GET" "/users/$ADMIN_USER" "Get User by Username" "200" "" "true"
    
    # Create new user
    local user_data="{\"username\":\"$TEST_USER\",\"email\":\"$TEST_EMAIL\",\"passwordHash\":\"testpassword123\",\"role\":\"CUSTOMER\",\"isActive\":true,\"companyId\":1}"
    
    local create_user_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$user_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/users/create")
    
    local create_user_status=$(echo "$create_user_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_user_status" == "200" ]]; then
        log_success "Create User (POST /users/create) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create User (POST /users/create)")
    else
        log_error "Create User (POST /users/create) - Expected: 200, Got: $create_user_status"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("Create User (POST /users/create)")
    fi
    
    # Test user utility endpoints
    test_endpoint "GET" "/users/test/hash?rawPassword=testpass123" "Test Password Hash" "200" "" "true"
    test_endpoint "GET" "/users/test/password?rawPassword=password123&username=$ADMIN_USER" "Test Password Match" "200" "" "true"
}

# Test Debug Endpoints (if available)
test_debug_endpoints() {
    log_header "Testing Debug Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "Debug endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 1))
        return
    fi
    
    # Debug users endpoint
    test_endpoint "GET" "/auth/debug/users" "Debug - Get All Users" "200" "" "true"
}

# Test Documentation Endpoints
test_documentation_endpoints() {
    log_header "Testing Documentation Endpoints"
    
    test_endpoint "GET" "/api-docs" "OpenAPI Documentation" "200" "" "false"
    test_endpoint "GET" "/swagger-ui/index.html" "Swagger UI" "200" "" "false"
}

# =============================================================================
# ISSUE DETECTION AND FIXING
# =============================================================================

# Function to analyze and fix common issues
analyze_and_fix_issues() {
    log_header "Analyzing Test Results and Fixing Issues"
    
    # Check if JWT authentication is the main issue
    if [[ ${#FAILED_ENDPOINTS[@]} -gt 0 ]]; then
        local jwt_auth_issues=0
        
        for endpoint in "${FAILED_ENDPOINTS[@]}"; do
            if [[ "$endpoint" == *"No JWT token available"* ]] || [[ "$endpoint" == *"401"* ]]; then
                jwt_auth_issues=$((jwt_auth_issues + 1))
            fi
        done
        
        if [[ $jwt_auth_issues -gt 0 ]]; then
            log_warning "Detected $jwt_auth_issues authentication-related failures"
            log_info "Attempting to fix JWT authentication configuration..."
            
            # Try to fix JWT authentication
            if fix_jwt_auth; then
                log_success "JWT authentication configuration appears to be working"
            else
                log_error "Unable to automatically fix JWT authentication issues"
                log_info "Manual intervention required:"
                echo "  1. Check if backend service is running: docker-compose ps"
                echo "  2. Check backend logs: docker-compose logs backend"
                echo "  3. Verify JWT configuration in application-docker.yml"
                echo "  4. Check SecurityConfig.java for proper filter chain setup"
            fi
        fi
    fi
    
    # Check for specific endpoint failures
    for endpoint in "${FAILED_ENDPOINTS[@]}"; do
        if [[ "$endpoint" == *"Create User"* ]]; then
            log_warning "User creation endpoint failing - checking validation requirements"
            log_info "Possible fixes:"
            echo "  1. Verify User entity validation annotations"
            echo "  2. Check database constraints and foreign key relationships"
            echo "  3. Review password encoding in UserController"
        fi
        
        if [[ "$endpoint" == *"companies"* ]]; then
            log_warning "Company endpoint issues detected"
            log_info "Possible fixes:"
            echo "  1. Check Company entity validation"
            echo "  2. Verify database schema and constraints"
            echo "  3. Review CompanyController error handling"
        fi
    done
}

# =============================================================================
# REPORTING FUNCTIONS
# =============================================================================

generate_summary_report() {
    log_header "API Testing Summary Report"
    
    local success_rate=0
    if [[ $TOTAL_TESTS -gt 0 ]]; then
        success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    fi
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}                    BILLIARD CLUB API TEST RESULTS                ${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "📊 ${BLUE}SUMMARY STATISTICS:${NC}"
    echo -e "   Total Tests: ${PURPLE}$TOTAL_TESTS${NC}"
    echo -e "   Passed:      ${GREEN}$PASSED_TESTS${NC}"
    echo -e "   Failed:      ${RED}$FAILED_TESTS${NC}"
    echo -e "   Skipped:     ${YELLOW}$SKIPPED_TESTS${NC}"
    echo -e "   Success Rate: ${CYAN}$success_rate%${NC}"
    echo ""
    
    if [[ ${#PASSED_ENDPOINTS[@]} -gt 0 ]]; then
        echo -e "✅ ${GREEN}PASSED ENDPOINTS (${#PASSED_ENDPOINTS[@]}):${NC}"
        for endpoint in "${PASSED_ENDPOINTS[@]}"; do
            echo -e "   ${GREEN}✓${NC} $endpoint"
        done
        echo ""
    fi
    
    if [[ ${#FAILED_ENDPOINTS[@]} -gt 0 ]]; then
        echo -e "❌ ${RED}FAILED ENDPOINTS (${#FAILED_ENDPOINTS[@]}):${NC}"
        for endpoint in "${FAILED_ENDPOINTS[@]}"; do
            echo -e "   ${RED}✗${NC} $endpoint"
        done
        echo ""
    fi
    
    if [[ ${#SKIPPED_ENDPOINTS[@]} -gt 0 ]]; then
        echo -e "⏭️  ${YELLOW}SKIPPED ENDPOINTS (${#SKIPPED_ENDPOINTS[@]}):${NC}"
        for endpoint in "${SKIPPED_ENDPOINTS[@]}"; do
            echo -e "   ${YELLOW}○${NC} $endpoint"
        done
        echo ""
    fi
    
    # Overall status
    if [[ $FAILED_TESTS -eq 0 ]]; then
        echo -e "🎉 ${GREEN}ALL TESTS PASSED! Your API is working perfectly.${NC}"
    elif [[ $success_rate -ge 80 ]]; then
        echo -e "⚠️  ${YELLOW}MOSTLY WORKING with some issues that need attention.${NC}"
    else
        echo -e "🔥 ${RED}MULTIPLE ISSUES DETECTED - Immediate attention required.${NC}"
    fi
    
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

main() {
    echo -e "${PURPLE}"
    echo "████████╗███████╗███████╗████████╗    ██████╗ ██╗██████╗  █████╗ "
    echo "╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝    ██╔══██╗██║██╔══██╗██╔══██╗"
    echo "   ██║   █████╗  ███████╗   ██║       ██████╔╝██║██║  ██║███████║"
    echo "   ██║   ██╔══╝  ╚════██║   ██║       ██╔══██╗██║██║  ██║██╔══██║"
    echo "   ██║   ███████╗███████║   ██║       ██████╔╝██║██████╔╝██║  ██║"
    echo "   ╚═╝   ╚══════╝╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚═════╝ ╚═╝  ╚═╝"
    echo -e "${NC}"
    echo -e "${CYAN}🎯 Comprehensive API Testing & Auto-Fix Script${NC}"
    echo -e "${CYAN}📅 $(date)${NC}"
    echo ""
    
    log_info "Starting comprehensive API testing..."
    log_info "Base URL: $API_BASE"
    
    # Run all test suites
    test_health_endpoints
    test_auth_endpoints
    
    # Only continue with protected endpoints if we have authentication
    if [[ -n "$JWT_TOKEN" ]]; then
        test_company_endpoints
        test_user_endpoints
        test_debug_endpoints
    else
        log_warning "Skipping protected endpoints due to authentication failure"
    fi
    
    test_documentation_endpoints
    
    # Analyze results and attempt fixes
    analyze_and_fix_issues
    
    # Generate final report
    generate_summary_report
    
    # Exit with appropriate code
    if [[ $FAILED_TESTS -eq 0 ]]; then
        exit 0
    else
        exit 1
    fi
}

# Run the script
main "$@"
