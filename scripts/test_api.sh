#!/bin/bash

# Billiard Club Management API Test Script
# This script tests all the API endpoints

BASE_URL="http://localhost:8080/api/v1"
JWT_TOKEN=""

echo "🎱 Billiard Club Management API Test Suite"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    if [ "$status" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC}: $message"
    elif [ "$status" = "FAIL" ]; then
        echo -e "${RED}❌ FAIL${NC}: $message"
    elif [ "$status" = "INFO" ]; then
        echo -e "${BLUE}ℹ️  INFO${NC}: $message"
    elif [ "$status" = "WARN" ]; then
        echo -e "${YELLOW}⚠️  WARN${NC}: $message"
    fi
}

# Function to test endpoint
test_endpoint() {
    local method=$1
    local endpoint=$2
    local expected_status=$3
    local description=$4
    local data=$5
    
    echo -n "Testing $method $endpoint... "
    
    if [ "$method" = "GET" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json "$BASE_URL$endpoint")
    elif [ "$method" = "POST" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json -X POST -H "Content-Type: application/json" -d "$data" "$BASE_URL$endpoint")
    elif [ "$method" = "PUT" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json -X PUT -H "Content-Type: application/json" -d "$data" "$BASE_URL$endpoint")
    elif [ "$method" = "DELETE" ]; then
        response=$(curl -s -w "%{http_code}" -o /tmp/response.json -X DELETE "$BASE_URL$endpoint")
    fi
    
    http_code="${response: -3}"
    
    if [ "$http_code" = "$expected_status" ]; then
        print_status "PASS" "$description (Status: $http_code)"
        if [ -s /tmp/response.json ]; then
            echo "   Response: $(cat /tmp/response.json | head -c 100)..."
        fi
    else
        print_status "FAIL" "$description (Expected: $expected_status, Got: $http_code)"
        if [ -s /tmp/response.json ]; then
            echo "   Error: $(cat /tmp/response.json)"
        fi
    fi
    echo ""
}

# Test 1: Health Check
echo "🔍 Testing Health Check Endpoints"
echo "---------------------------------"
test_endpoint "GET" "/health" "200" "Health check endpoint"
test_endpoint "GET" "/simple/health" "200" "Simple health check endpoint"
test_endpoint "GET" "/simple/test" "200" "Simple test endpoint"

# Test 2: Authentication
echo "🔐 Testing Authentication Endpoints"
echo "-----------------------------------"
test_endpoint "GET" "/auth/health" "200" "Auth service health check"

# Test 3: Login with valid credentials
echo "🔑 Testing Login"
echo "----------------"
login_data='{"username":"admin","password":"password123"}'
response=$(curl -s -w "%{http_code}" -o /tmp/login_response.json -X POST -H "Content-Type: application/json" -d "$login_data" "$BASE_URL/auth/login")
http_code="${response: -3}"

if [ "$http_code" = "200" ]; then
    print_status "PASS" "Login successful (Status: $http_code)"
    JWT_TOKEN=$(cat /tmp/login_response.json | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$JWT_TOKEN" ]; then
        print_status "INFO" "JWT Token obtained: ${JWT_TOKEN:0:20}..."
    else
        print_status "WARN" "JWT Token not found in response"
    fi
else
    print_status "FAIL" "Login failed (Expected: 200, Got: $http_code)"
    if [ -s /tmp/login_response.json ]; then
        echo "   Error: $(cat /tmp/login_response.json)"
    fi
fi
echo ""

# Test 4: Debug endpoints (if we have a token)
if [ -n "$JWT_TOKEN" ]; then
    echo "🐛 Testing Debug Endpoints"
    echo "-------------------------"
    test_endpoint "GET" "/auth/debug/users" "200" "Get all users (debug)" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/users/test/hash?rawPassword=password123" "200" "Generate password hash" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/users/test/password?rawPassword=password123&username=admin" "200" "Test password matching" "" "Authorization: Bearer $JWT_TOKEN"
else
    print_status "WARN" "Skipping debug endpoints - no JWT token available"
fi
echo ""

# Test 5: Companies endpoints (if we have a token)
if [ -n "$JWT_TOKEN" ]; then
    echo "🏢 Testing Companies Endpoints"
    echo "-----------------------------"
    test_endpoint "GET" "/companies" "200" "Get all companies" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/companies/1" "200" "Get company by ID" "" "Authorization: Bearer $JWT_TOKEN"
    
    # Create a new company
    new_company_data='{"name":"Test Company","address":"123 Test St","phone":"+84 123 456 789","email":"test@company.com"}'
    test_endpoint "POST" "/companies" "200" "Create new company" "$new_company_data" "Authorization: Bearer $JWT_TOKEN"
    
    # Update company
    update_company_data='{"name":"Updated Test Company","address":"456 Updated St","phone":"+84 987 654 321","email":"updated@company.com"}'
    test_endpoint "PUT" "/companies/1" "200" "Update company" "$update_company_data" "Authorization: Bearer $JWT_TOKEN"
else
    print_status "WARN" "Skipping companies endpoints - no JWT token available"
fi
echo ""

# Test 6: Users endpoints (if we have a token)
if [ -n "$JWT_TOKEN" ]; then
    echo "👥 Testing Users Endpoints"
    echo "-------------------------"
    test_endpoint "GET" "/users" "200" "Get all users" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/users/admin" "200" "Get user by username" "" "Authorization: Bearer $JWT_TOKEN"
    
    # Create a new user
    new_user_data='{"username":"testuser","email":"testuser@example.com","passwordHash":"password123","role":"STAFF","companyId":1}'
    test_endpoint "POST" "/users/create" "200" "Create new user" "$new_user_data" "Authorization: Bearer $JWT_TOKEN"
else
    print_status "WARN" "Skipping users endpoints - no JWT token available"
fi
echo ""

# Test 7: Test with invalid credentials
echo "🚫 Testing Invalid Authentication"
echo "--------------------------------"
invalid_login_data='{"username":"invalid","password":"wrongpassword"}'
response=$(curl -s -w "%{http_code}" -o /tmp/invalid_login_response.json -X POST -H "Content-Type: application/json" -d "$invalid_login_data" "$BASE_URL/auth/login")
http_code="${response: -3}"

if [ "$http_code" = "401" ]; then
    print_status "PASS" "Invalid login correctly rejected (Status: $http_code)"
else
    print_status "FAIL" "Invalid login not properly handled (Expected: 401, Got: $http_code)"
fi
echo ""

# Test 8: Test protected endpoints without token
echo "🔒 Testing Protected Endpoints Without Token"
echo "-------------------------------------------"
test_endpoint "GET" "/companies" "401" "Get companies without token"
test_endpoint "GET" "/users" "401" "Get users without token"
test_endpoint "GET" "/auth/debug/users" "401" "Get debug users without token"

# Test 9: Swagger UI accessibility
echo "📚 Testing Swagger UI"
echo "--------------------"
swagger_response=$(curl -s -w "%{http_code}" -o /tmp/swagger_response.html "$BASE_URL/swagger-ui/index.html")
swagger_code="${swagger_response: -3}"

if [ "$swagger_code" = "200" ]; then
    print_status "PASS" "Swagger UI accessible (Status: $swagger_code)"
else
    print_status "FAIL" "Swagger UI not accessible (Expected: 200, Got: $swagger_code)"
fi

# Test 10: OpenAPI documentation
echo "📖 Testing OpenAPI Documentation"
echo "-------------------------------"
api_docs_response=$(curl -s -w "%{http_code}" -o /tmp/api_docs_response.json "$BASE_URL/api-docs")
api_docs_code="${api_docs_response: -3}"

if [ "$api_docs_code" = "200" ]; then
    print_status "PASS" "OpenAPI documentation accessible (Status: $api_docs_code)"
    echo "   Documentation contains $(cat /tmp/api_docs_response.json | wc -c) characters"
else
    print_status "FAIL" "OpenAPI documentation not accessible (Expected: 200, Got: $api_docs_code)"
fi
echo ""

# Summary
echo "📊 Test Summary"
echo "==============="
echo "✅ Swagger UI: http://localhost:8080/api/v1/swagger-ui/index.html"
echo "✅ OpenAPI Docs: http://localhost:8080/api/v1/api-docs"
echo "✅ Health Check: http://localhost:8080/api/v1/health"
echo ""
echo "🎯 API Endpoints Tested:"
echo "   - Health checks (3 endpoints)"
echo "   - Authentication (1 endpoint)"
echo "   - Login (1 endpoint)"
echo "   - Debug endpoints (3 endpoints)"
echo "   - Companies (4 endpoints)"
echo "   - Users (3 endpoints)"
echo "   - Invalid authentication (1 endpoint)"
echo "   - Protected endpoints without token (3 endpoints)"
echo "   - Swagger UI accessibility (1 endpoint)"
echo "   - OpenAPI documentation (1 endpoint)"
echo ""
echo "Total endpoints tested: 20+"
echo ""
echo "🚀 To view the interactive API documentation, open:"
echo "   http://localhost:8080/api/v1/swagger-ui/index.html"
echo ""
echo "📝 To get the raw OpenAPI specification:"
echo "   http://localhost:8080/api/v1/api-docs"
