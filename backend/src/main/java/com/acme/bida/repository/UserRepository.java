package com.acme.bida.repository;

import com.acme.bida.domain.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    List<User> findByCompanyId(Long companyId);
    List<User> findByClubId(Long clubId);
    List<User> findByCompanyIdAndRole(Long companyId, User.UserRole role);
}
