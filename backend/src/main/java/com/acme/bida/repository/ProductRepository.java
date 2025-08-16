package com.acme.bida.repository;

import com.acme.bida.domain.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {
    List<Product> findByClubId(Long clubId);
    List<Product> findByClubIdAndIsAvailableTrue(Long clubId);
    List<Product> findByClubIdAndCategory(Long clubId, Product.ProductCategory category);
}
