# Phase 1 Completion - Table Management Implementation

## Status: READY FOR IMPLEMENTATION

### TableController Implementation Required

**File to create:** `backend/src/main/java/com/acme/bida/controller/TableController.java`

```java
package com.acme.bida.controller;

import com.acme.bida.domain.entity.Table;
import com.acme.bida.domain.entity.Table.TableStatus;
import com.acme.bida.repository.TableRepository;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/tables")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER', 'STAFF')")
public class TableController {
    
    private final TableRepository tableRepository;
    
    @GetMapping
    @PreAuthorize("hasRole('OWNER')")
    public ResponseEntity<List<Table>> getAllTables() {
        List<Table> tables = tableRepository.findAll();
        return ResponseEntity.ok(tables);
    }
    
    @GetMapping("/club/{clubId}")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER', 'STAFF')")
    public ResponseEntity<List<Table>> getTablesByClubId(@PathVariable Long clubId) {
        List<Table> tables = tableRepository.findByClubId(clubId);
        return ResponseEntity.ok(tables);
    }
    
    @GetMapping("/club/{clubId}/status/{status}")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER', 'STAFF')")
    public ResponseEntity<List<Table>> getTablesByClubIdAndStatus(
            @PathVariable Long clubId, 
            @PathVariable TableStatus status) {
        List<Table> tables = tableRepository.findByClubIdAndStatus(clubId, status);
        return ResponseEntity.ok(tables);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Table> getTableById(@PathVariable Long id) {
        return tableRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER')")
    public ResponseEntity<Table> createTable(@Valid @RequestBody Table table) {
        table.setStatus(TableStatus.AVAILABLE);
        Table savedTable = tableRepository.save(table);
        return ResponseEntity.ok(savedTable);
    }
    
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER')")
    public ResponseEntity<Table> updateTable(@PathVariable Long id, @Valid @RequestBody Table table) {
        if (!tableRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        table.setId(id);
        Table updatedTable = tableRepository.save(table);
        return ResponseEntity.ok(updatedTable);
    }
    
    @PatchMapping("/{id}/status")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER', 'STAFF')")
    public ResponseEntity<Table> updateTableStatus(@PathVariable Long id, @RequestBody TableStatusUpdateRequest request) {
        return tableRepository.findById(id)
                .map(table -> {
                    table.setStatus(request.getStatus());
                    Table updatedTable = tableRepository.save(table);
                    return ResponseEntity.ok(updatedTable);
                })
                .orElse(ResponseEntity.notFound().build());
    }
    
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER')")
    public ResponseEntity<Void> deleteTable(@PathVariable Long id) {
        if (!tableRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }
        tableRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/club/{clubId}/available")
    @PreAuthorize("hasAnyRole('OWNER', 'CLUB_MANAGER', 'STAFF', 'CUSTOMER')")
    public ResponseEntity<List<Table>> getAvailableTablesByClubId(@PathVariable Long clubId) {
        List<Table> tables = tableRepository.findByClubIdAndStatus(clubId, TableStatus.AVAILABLE);
        return ResponseEntity.ok(tables);
    }
    
    public static class TableStatusUpdateRequest {
        private TableStatus status;
        
        public TableStatus getStatus() {
            return status;
        }
        
        public void setStatus(TableStatus status) {
            this.status = status;
        }
    }
}
```

### Test Script Updates

**Add to `scripts/test_api.sh` before the Summary section:**

```bash
# Test 11: Tables endpoints (if we have a token)
if [ -n "$JWT_TOKEN" ]; then
    echo "🎱 Testing Tables Endpoints"
    echo "---------------------------"
    test_endpoint "GET" "/tables" "200" "Get all tables" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/tables/club/1" "200" "Get tables by club ID" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/tables/club/1/available" "200" "Get available tables for club" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/tables/club/1/status/AVAILABLE" "200" "Get tables by club and status" "" "Authorization: Bearer $JWT_TOKEN"
    test_endpoint "GET" "/tables/1" "200" "Get table by ID" "" "Authorization: Bearer $JWT_TOKEN"
    
    # Create a new table
    new_table_data='{"clubId":1,"name":"Test Table 1","type":"POOL_8_BALL","hourlyRate":25000}'
    test_endpoint "POST" "/tables" "200" "Create new table" "$new_table_data" "Authorization: Bearer $JWT_TOKEN"
    
    # Update table status
    status_update_data='{"status":"OCCUPIED"}'
    test_endpoint "PATCH" "/tables/1/status" "200" "Update table status" "$status_update_data" "Authorization: Bearer $JWT_TOKEN"
    
    # Update table
    update_table_data='{"clubId":1,"name":"Updated Test Table","type":"SNOOKER","hourlyRate":35000,"status":"AVAILABLE"}'
    test_endpoint "PUT" "/tables/1" "200" "Update table" "$update_table_data" "Authorization: Bearer $JWT_TOKEN"
else
    print_status "WARN" "Skipping tables endpoints - no JWT token available"
fi
echo ""

# Test 12: Test protected table endpoints without token
echo "🔒 Testing Protected Table Endpoints Without Token"
echo "------------------------------------------------"
test_endpoint "GET" "/tables" "401" "Get tables without token"
test_endpoint "GET" "/tables/club/1" "401" "Get club tables without token"
test_endpoint "POST" "/tables" "401" "Create table without token" '{"clubId":1,"name":"Test","type":"POOL_8_BALL","hourlyRate":25000}'
echo ""
```

### Implementation Steps

1. **Create the TableController.java file** with the code above
2. **Add the test script additions** to test_api.sh before the summary
3. **Restart backend**: `docker-compose restart backend`
4. **Run tests**: `./scripts/test_api.sh`

### Expected Results

- **New API Endpoints**: 8 new table management endpoints
- **Security**: Role-based access control for all operations
- **Features**: CRUD operations + status management + club filtering
- **Tests**: 11 additional test cases for comprehensive coverage

This completes the Table Management component of Phase 1.