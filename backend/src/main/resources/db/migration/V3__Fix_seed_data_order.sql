-- Fix seed data order - insert clubs first, then users
-- Clear existing data
DELETE FROM bill_orders;
DELETE FROM bills;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM bookings;
DELETE FROM products;
DELETE FROM tables;
DELETE FROM users WHERE username != 'admin';
DELETE FROM clubs;

-- Insert sample clubs first (only using existing company ID=1)
INSERT INTO clubs (id, company_id, name, address, phone, email, opening_hours) VALUES 
(1, 1, 'ACME Billiard Club - District 7', '456 Le Van Viet, District 7, Ho Chi Minh City', '+84 28 8765 4321', 'd7@acme-bida.com', '09:00-23:00 Daily'),
(2, 1, 'ACME Billiard Club - District 1', '789 Dong Khoi, District 1, Ho Chi Minh City', '+84 28 8765 4322', 'd1@acme-bida.com', '10:00-24:00 Daily')
ON CONFLICT (id) DO NOTHING;

-- Now insert users with proper club references
INSERT INTO users (username, email, password_hash, role, company_id, club_id) VALUES 
-- Company 1 (ACME) users
('manager_d7', 'manager.d7@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CLUB_MANAGER', 1, 1),
('manager_d1', 'manager.d1@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CLUB_MANAGER', 1, 2),
('staff_d7_1', 'staff.d7.1@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 1),
('staff_d7_2', 'staff.d7.2@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 1),
('staff_d1_1', 'staff.d1.1@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 2),

-- Additional Company 1 users
('elite_manager', 'manager@elite-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CLUB_MANAGER', 1, 1),
('elite_staff', 'staff@elite-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 1),

-- Additional Company 1 users
('premium_manager', 'manager@premium-pool.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CLUB_MANAGER', 1, 2),
('premium_staff', 'staff@premium-pool.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 2),

-- Customer users
('customer1', 'customer1@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CUSTOMER', NULL, NULL),
('customer2', 'customer2@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CUSTOMER', NULL, NULL),
('customer3', 'customer3@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CUSTOMER', NULL, NULL)
ON CONFLICT (username) DO NOTHING;

-- Insert sample tables with explicit IDs
INSERT INTO tables (id, club_id, name, type, status, hourly_rate) VALUES 
(1, 1, 'Table 1', 'POOL_8_BALL', 'AVAILABLE', 150000),
(2, 1, 'Table 2', 'POOL_8_BALL', 'AVAILABLE', 150000),
(3, 1, 'Table 3', 'POOL_9_BALL', 'AVAILABLE', 180000),
(4, 1, 'Table 4', 'SNOOKER', 'AVAILABLE', 200000),
(5, 1, 'Table 5', 'CAROM', 'MAINTENANCE', 120000)
ON CONFLICT (id) DO NOTHING;

-- Insert sample products with explicit IDs
INSERT INTO products (id, club_id, name, description, category, price, is_available) VALUES 
-- Beverages
(1, 1, 'Coca Cola', '330ml can', 'BEVERAGE', 15000, true),
(2, 1, 'Pepsi', '330ml can', 'BEVERAGE', 15000, true),
(3, 1, 'Heineken', '330ml bottle', 'BEVERAGE', 25000, true),
(4, 1, 'Tiger Beer', '330ml bottle', 'BEVERAGE', 22000, true),
(5, 1, 'Coffee', 'Vietnamese coffee', 'BEVERAGE', 20000, true),
(6, 1, 'Tea', 'Green tea', 'BEVERAGE', 15000, true),

-- Food
(7, 1, 'Pho', 'Vietnamese noodle soup', 'FOOD', 45000, true),
(8, 1, 'Com Tam', 'Broken rice with pork', 'FOOD', 35000, true),
(9, 1, 'Banh Mi', 'Vietnamese sandwich', 'FOOD', 25000, true),
(10, 1, 'Spring Rolls', 'Fresh spring rolls', 'FOOD', 30000, true),

-- Snacks
(11, 1, 'Peanuts', 'Roasted peanuts', 'SNACK', 15000, true),
(12, 1, 'Chips', 'Potato chips', 'SNACK', 20000, true),
(13, 1, 'Nuts Mix', 'Mixed nuts', 'SNACK', 25000, true),

-- Other
(14, 1, 'Cue Tip', 'Pool cue tip replacement', 'OTHER', 50000, true),
(15, 1, 'Chalk', 'Pool chalk', 'OTHER', 10000, true)
ON CONFLICT (id) DO NOTHING;

-- Insert sample booking (using customer1 user) with explicit ID
INSERT INTO bookings (id, table_id, user_id, start_time, end_time, status) VALUES 
(1, 1, (SELECT id FROM users WHERE username = 'customer1'), CURRENT_TIMESTAMP + INTERVAL '1 hour', CURRENT_TIMESTAMP + INTERVAL '3 hours', 'CONFIRMED')
ON CONFLICT (id) DO NOTHING;

-- Insert sample order (using customer1 user) with explicit ID
INSERT INTO orders (id, table_id, user_id, status, total_amount) VALUES 
(1, 1, (SELECT id FROM users WHERE username = 'customer1'), 'PENDING', 45000)
ON CONFLICT (id) DO NOTHING;

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price) VALUES 
(1, 1, 2, 15000, 30000),
(1, 11, 1, 15000, 15000)
ON CONFLICT DO NOTHING;

-- Insert sample bill (using customer1 user) with explicit ID
INSERT INTO bills (id, table_id, booking_id, user_id, table_fee, total_amount, status, payment_method) VALUES 
(1, 1, 1, (SELECT id FROM users WHERE username = 'customer1'), 300000, 345000, 'PENDING', 'CASH')
ON CONFLICT (id) DO NOTHING;

-- Link bill to order
INSERT INTO bill_orders (bill_id, order_id) VALUES (1, 1)
ON CONFLICT DO NOTHING;
