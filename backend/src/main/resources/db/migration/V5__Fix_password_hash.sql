-- Fix password hash for all users to use a known working hash for 'password123'
-- This hash was generated using BCrypt with strength 10

UPDATE users
SET password_hash = '$2a$10$ODnJVZ4gqnJP9vPYwkHFFu39gO9S6D78o49j3DAL7vdaanOJBJ3cK'
WHERE username IN ('admin', 'manager_d7', 'manager_d1', 'staff_d7_1', 'staff_d7_2', 'staff_d1_1', 'elite_manager', 'elite_staff', 'premium_manager', 'premium_staff', 'customer1', 'customer2', 'customer3');
