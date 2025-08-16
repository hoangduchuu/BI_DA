package com.acme.bida.repository;

import com.acme.bida.domain.entity.Bill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface BillRepository extends JpaRepository<Bill, Long> {
    List<Bill> findByTableId(Long tableId);
    List<Bill> findByUserId(Long userId);
    List<Bill> findByStatus(Bill.BillStatus status);
    List<Bill> findByTableIdAndStatus(Long tableId, Bill.BillStatus status);
}
