package com.acme.bida.repository;

import com.acme.bida.domain.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByTableId(Long tableId);
    List<Booking> findByUserId(Long userId);
    List<Booking> findByTableIdAndStartTimeBetween(Long tableId, LocalDateTime start, LocalDateTime end);
    List<Booking> findByStatus(Booking.BookingStatus status);
}
