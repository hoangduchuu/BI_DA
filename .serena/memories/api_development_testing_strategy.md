# API Development & Testing Strategy for BI_DA Project

## 🎯 **STRATEGY OVERVIEW**

This document outlines the standardized approach for implementing new APIs in the BI_DA Billiard Club Management System and automatically adding them to the comprehensive testing framework.

## 📋 **NEW API IMPLEMENTATION WORKFLOW**

### **1. API Development Steps**
```
1. Create/Update Entity (if needed)
2. Create/Update Repository
3. Create/Update Service Layer
4. Create/Update Controller
5. Update SecurityConfig (if needed)
6. Add to test_all_apis.sh
7. Run comprehensive tests
8. Update API documentation
```

### **2. Controller Development Pattern**
All new controllers should follow the established pattern:

```java
@RestController
@RequestMapping("/your-endpoint")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Your Feature", description = "Your feature management endpoints")
public class YourController {
    
    private final YourRepository repository;
    
    @GetMapping
    public ResponseEntity<List<YourEntity>> getAll() {
        // Implementation
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<YourEntity> getById(@PathVariable Long id) {
        // Implementation
    }
    
    @PostMapping
    public ResponseEntity<YourEntity> create(@Valid @RequestBody YourEntity entity) {
        // Implementation
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<YourEntity> update(@PathVariable Long id, @Valid @RequestBody YourEntity entity) {
        // Implementation
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        // Implementation
    }
}
```

## 🔧 **ADDING NEW APIs TO test_all_apis.sh**

### **Step-by-Step Integration Process**

#### **1. Add New Test Function**
Add a new test function following the naming pattern `test_[feature]_endpoints()`:

```bash
# Test [Feature] Management Endpoints
test_[feature]_endpoints() {
    log_header "Testing [Feature] Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "[Feature] endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 5))  # Adjust based on number of endpoints
        SKIPPED_TESTS=$((SKIPPED_TESTS + 5))
        return
    fi
    
    # GET all
    test_endpoint "GET" "/[feature]" "Get All [Feature]s" "200" "" "true"
    
    # CREATE new
    local [feature]_data="{\"name\":\"Test [Feature]\",\"description\":\"API Test\"}"
    
    local create_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$[feature]_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/[feature]")
    
    local create_status=$(echo "$create_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local create_body=$(echo "$create_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_status" == "200" ]]; then
        log_success "Create [Feature] (POST /[feature]) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create [Feature] (POST /[feature])")
        
        # Extract ID for further tests
        local FEATURE_ID=$(echo "$create_body" | grep -o '"id":[0-9]*' | cut -d: -f2)
        
        if [[ -n "$FEATURE_ID" ]]; then
            # GET by ID
            test_endpoint "GET" "/[feature]/$FEATURE_ID" "Get [Feature] by ID" "200" "" "true"
            
            # UPDATE
            local update_data="{\"name\":\"Updated [Feature]\",\"description\":\"Updated Description\"}"
            test_endpoint "PUT" "/[feature]/$FEATURE_ID" "Update [Feature]" "200" "$update_data" "true"
            
            # DELETE
            test_endpoint "DELETE" "/[feature]/$FEATURE_ID" "Delete [Feature]" "204" "" "true"
        else
            log_error "Could not extract [feature] ID from create response"
            TOTAL_TESTS=$((TOTAL_TESTS + 3))
            FAILED_TESTS=$((FAILED_TESTS + 3))
        fi
    else
        log_error "Create [Feature] (POST /[feature]) - Expected: 200, Got: $create_status"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("Create [Feature] (POST /[feature])")
        
        # Skip dependent tests
        log_skip "[Feature] by ID, Update, Delete tests - Create failed"
        TOTAL_TESTS=$((TOTAL_TESTS + 3))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 3))
    fi
}
```

#### **2. Add Function Call to Main Execution**
In the `main()` function, add the new test function call:

```bash
main() {
    # ... existing code ...
    
    # Run all test suites
    test_health_endpoints
    test_auth_endpoints
    
    # Only continue with protected endpoints if we have authentication
    if [[ -n "$JWT_TOKEN" ]]; then
        test_company_endpoints
        test_user_endpoints
        test_[feature]_endpoints  # ADD NEW FUNCTION HERE
        test_debug_endpoints
    else
        log_warning "Skipping protected endpoints due to authentication failure"
    fi
    
    # ... rest of existing code ...
}
```

#### **3. Update Issue Analysis (if needed)**
Add specific error handling in `analyze_and_fix_issues()` function:

```bash
# Check for specific endpoint failures
for endpoint in "${FAILED_ENDPOINTS[@]}"; do
    # ... existing checks ...
    
    if [[ "$endpoint" == *"[feature]"* ]]; then
        log_warning "[Feature] endpoint issues detected"
        log_info "Possible fixes:"
        echo "  1. Check [Feature] entity validation"
        echo "  2. Verify database schema and constraints" 
        echo "  3. Review [Feature]Controller error handling"
    fi
done
```

## 🚀 **PRACTICAL EXAMPLES FOR UPCOMING FEATURES**

### **Example 1: Table Management API**

```bash
# Test Table Management Endpoints
test_table_endpoints() {
    log_header "Testing Table Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "Table endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 5))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 5))
        return
    fi
    
    # Get all tables
    test_endpoint "GET" "/tables" "Get All Tables" "200" "" "true"
    
    # Create a new table
    local table_data="{\"name\":\"Table 01\",\"type\":\"CAROM\",\"status\":\"AVAILABLE\",\"clubId\":1,\"hourlyRate\":50000}"
    
    local create_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$table_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/tables")
    
    local create_status=$(echo "$create_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local create_body=$(echo "$create_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_status" == "200" ]]; then
        log_success "Create Table (POST /tables) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create Table (POST /tables)")
        
        local TABLE_ID=$(echo "$create_body" | grep -o '"id":[0-9]*' | cut -d: -f2)
        
        if [[ -n "$TABLE_ID" ]]; then
            test_endpoint "GET" "/tables/$TABLE_ID" "Get Table by ID" "200" "" "true"
            
            local update_data="{\"name\":\"Table 01 Updated\",\"status\":\"MAINTENANCE\",\"hourlyRate\":60000}"
            test_endpoint "PUT" "/tables/$TABLE_ID" "Update Table" "200" "$update_data" "true"
            
            # Test table status update
            test_endpoint "PUT" "/tables/$TABLE_ID/status" "Update Table Status" "200" "{\"status\":\"OCCUPIED\"}" "true"
            
            test_endpoint "DELETE" "/tables/$TABLE_ID" "Delete Table" "204" "" "true"
        fi
    else
        log_error "Create Table (POST /tables) - Expected: 200, Got: $create_status"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        FAILED_ENDPOINTS+=("Create Table (POST /tables)")
        
        log_skip "Table by ID, Update, Delete tests - Create failed"
        TOTAL_TESTS=$((TOTAL_TESTS + 4))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 4))
    fi
}
```

### **Example 2: Booking System API**

```bash
# Test Booking Management Endpoints
test_booking_endpoints() {
    log_header "Testing Booking Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "Booking endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 6))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 6))
        return
    fi
    
    # Assume we have a table ID from previous tests or use hardcoded for testing
    local TABLE_ID=1
    
    # Get bookings for a table
    test_endpoint "GET" "/tables/$TABLE_ID/bookings" "Get Table Bookings" "200" "" "true"
    
    # Create a new booking
    local booking_data="{\"customerName\":\"John Doe\",\"customerPhone\":\"+84901234567\",\"startTime\":\"$(date -u +%Y-%m-%dT%H:%M:%S.000Z)\",\"estimatedDuration\":120}"
    
    local create_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$booking_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/tables/$TABLE_ID/bookings")
    
    local create_status=$(echo "$create_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local create_body=$(echo "$create_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_status" == "200" ]]; then
        log_success "Create Booking (POST /tables/$TABLE_ID/bookings) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create Booking (POST /tables/$TABLE_ID/bookings)")
        
        local BOOKING_ID=$(echo "$create_body" | grep -o '"id":[0-9]*' | cut -d: -f2)
        
        if [[ -n "$BOOKING_ID" ]]; then
            test_endpoint "GET" "/bookings/$BOOKING_ID" "Get Booking by ID" "200" "" "true"
            test_endpoint "PUT" "/bookings/$BOOKING_ID" "Update Booking" "200" "{\"estimatedDuration\":180}" "true"
            test_endpoint "POST" "/bookings/$BOOKING_ID/start" "Start Booking Session" "200" "" "true"
            test_endpoint "POST" "/bookings/$BOOKING_ID/stop" "Stop Booking Session" "200" "" "true"
        fi
    fi
}
```

### **Example 3: Order Management API**

```bash
# Test Order Management Endpoints  
test_order_endpoints() {
    log_header "Testing Order Management Endpoints"
    
    if [[ -z "$JWT_TOKEN" ]]; then
        log_skip "Order endpoints - No JWT token available"
        TOTAL_TESTS=$((TOTAL_TESTS + 5))
        SKIPPED_TESTS=$((SKIPPED_TESTS + 5))
        return
    fi
    
    local TABLE_ID=1
    
    # Get orders for a table
    test_endpoint "GET" "/tables/$TABLE_ID/orders" "Get Table Orders" "200" "" "true"
    
    # Create a new order
    local order_data="{\"items\":[{\"productId\":1,\"quantity\":2},{\"productId\":2,\"quantity\":1}],\"notes\":\"Extra ice\"}"
    
    local create_response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $JWT_TOKEN" \
        -d "$order_data" \
        -w "HTTPSTATUS:%{http_code}" \
        "$API_BASE/tables/$TABLE_ID/orders")
    
    local create_status=$(echo "$create_response" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    local create_body=$(echo "$create_response" | sed 's/HTTPSTATUS:[0-9]*$//')
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    if [[ "$create_status" == "200" ]]; then
        log_success "Create Order (POST /tables/$TABLE_ID/orders) - Status: 200"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        PASSED_ENDPOINTS+=("Create Order (POST /tables/$TABLE_ID/orders)")
        
        local ORDER_ID=$(echo "$create_body" | grep -o '"id":[0-9]*' | cut -d: -f2)
        
        if [[ -n "$ORDER_ID" ]]; then
            test_endpoint "GET" "/orders/$ORDER_ID" "Get Order by ID" "200" "" "true"
            test_endpoint "PUT" "/orders/$ORDER_ID" "Update Order Status" "200" "{\"status\":\"PREPARING\"}" "true"
            test_endpoint "POST" "/orders/$ORDER_ID/complete" "Complete Order" "200" "" "true"
        fi
    fi
}
```

## 📝 **TESTING BEST PRACTICES**

### **1. Test Data Management**
- Use dynamic test data with timestamps to avoid conflicts
- Clean up test data after tests (DELETE operations)
- Use realistic data that matches business requirements

### **2. Error Handling**
- Test both success and failure scenarios
- Validate proper HTTP status codes
- Check error response formats

### **3. Authentication Testing**
- Always check JWT token availability before protected endpoint tests
- Test both authenticated and unauthenticated scenarios
- Validate role-based access control

### **4. Dependencies Management**
- Handle endpoint dependencies gracefully (e.g., table needed for bookings)
- Skip dependent tests if prerequisites fail
- Use proper test ordering

## 🔄 **CONTINUOUS INTEGRATION WORKFLOW**

### **1. Development Cycle**
```
1. Implement new API endpoint(s)
2. Add tests to test_all_apis.sh
3. Run ./test_all_apis.sh locally
4. Fix any failing tests
5. Commit changes
6. Push to repository
7. CI/CD runs comprehensive tests
8. Deploy if tests pass
```

### **2. Test Automation Commands**
```bash
# Run full test suite
./test_all_apis.sh

# Run with verbose output
./test_all_apis.sh --verbose

# Run specific test categories (future enhancement)
./test_all_apis.sh --category=companies,users

# Generate test report (future enhancement)
./test_all_apis.sh --report=json
```

## 📊 **SUCCESS METRICS**

### **Target Success Rates**
- **New Features**: 100% test success required before deployment
- **Regression Testing**: 95%+ success rate maintained
- **Performance**: All endpoints < 200ms response time
- **Coverage**: All CRUD operations tested for each entity

### **Quality Gates**
- All endpoints must have corresponding tests
- Security endpoints must validate authentication/authorization
- Error scenarios must be tested
- Documentation must be updated

## 🚀 **FUTURE ENHANCEMENTS TO TEST SCRIPT**

### **Planned Improvements**
1. **Test Categories**: Ability to run specific test categories
2. **Parallel Testing**: Run tests concurrently for faster execution
3. **Data Validation**: Validate response data structure and content
4. **Performance Testing**: Measure and report response times
5. **Test Reports**: JSON/HTML report generation
6. **CI/CD Integration**: GitHub Actions integration
7. **Environment Support**: Test against different environments
8. **Mock Data**: Automated test data setup and cleanup

### **Configuration Enhancements**
```bash
# Future configuration options
API_BASE="http://localhost:8080/api/v1"
ENVIRONMENT="development"  # development, staging, production
TEST_CATEGORIES="all"      # all, auth, business, admin
PARALLEL_TESTS=true
GENERATE_REPORT=true
CLEANUP_TEST_DATA=true
```

## 📋 **CHECKLIST FOR NEW API IMPLEMENTATION**

### **Before Implementation**
- [ ] Define API endpoints and HTTP methods
- [ ] Design request/response data structures  
- [ ] Plan authentication/authorization requirements
- [ ] Consider database schema changes needed

### **During Implementation**
- [ ] Follow established controller patterns
- [ ] Implement proper error handling
- [ ] Add input validation
- [ ] Update security configuration if needed
- [ ] Add comprehensive logging

### **Testing Integration**
- [ ] Add test function to test_all_apis.sh
- [ ] Test all CRUD operations
- [ ] Test authentication requirements
- [ ] Test error scenarios
- [ ] Validate response formats
- [ ] Update issue analysis if needed

### **Documentation & Deployment**
- [ ] Update API documentation
- [ ] Update Serena memories
- [ ] Run comprehensive test suite
- [ ] Verify 95%+ success rate maintained
- [ ] Deploy to appropriate environment

---

This strategy ensures that every new API implementation follows a consistent pattern and is automatically integrated into our comprehensive testing framework, maintaining the high quality and reliability standards established for the BI_DA project.