-- Update password hashes to a known working hash for 'password123'
-- This hash was generated using BCrypt with strength 10

UPDATE users 
SET password_hash = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa' 
WHERE username IN ('admin', 'manager_d7', 'manager_d1', 'staff_d7_1', 'staff_d7_2', 'staff_d1_1', 'elite_admin', 'elite_manager', 'elite_staff', 'premium_admin', 'premium_manager', 'premium_staff', 'customer1', 'customer2', 'customer3');
