package com.acme.bida.repository;

import com.acme.bida.domain.entity.Table;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TableRepository extends JpaRepository<Table, Long> {
    List<Table> findByClubId(Long clubId);
    List<Table> findByClubIdAndStatus(Long clubId, Table.TableStatus status);
}
