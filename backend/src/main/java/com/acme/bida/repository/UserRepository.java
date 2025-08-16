package com.acme.bida.repository;

import com.acme.bida.domain.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
    
    Optional<User> findByEmail(String email);
    
    @Query("SELECT u FROM User u WHERE u.companyId = :companyId")
    List<User> findByCompanyId(@Param("companyId") Long companyId);
    
    @Query("SELECT u FROM User u WHERE u.clubId = :clubId")
    List<User> findByClubId(@Param("clubId") Long clubId);
    
    @Query("SELECT u FROM User u WHERE u.companyId = :companyId AND u.role = :role")
    List<User> findByCompanyIdAndRole(@Param("companyId") Long companyId, @Param("role") User.UserRole role);
    
    @Query("SELECT u FROM User u WHERE u.clubId = :clubId AND u.role = :role")
    List<User> findByClubIdAndRole(@Param("clubId") Long clubId, @Param("role") User.UserRole role);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
}
