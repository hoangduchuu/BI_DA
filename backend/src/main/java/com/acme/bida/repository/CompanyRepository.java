package com.acme.bida.repository;

import com.acme.bida.domain.entity.Company;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CompanyRepository extends JpaRepository<Company, Long> {
    // Basic CRUD operations are provided by JpaRepository
    // Add custom query methods if needed
}
