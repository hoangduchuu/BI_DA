-- Sample data for testing and development

-- Insert sample company
INSERT INTO companies (name, address, phone, email) VALUES 
('ACME Billiard Group', '123 Nguyen Van Linh, District 7, Ho Chi Minh City', '+84 28 1234 5678', 'info@acme-bida.com')
ON CONFLICT DO NOTHING;

-- Insert sample club
INSERT INTO clubs (company_id, name, address, phone, email, opening_hours) VALUES 
(1, 'ACME Billiard Club - District 7', '456 Le Van Viet, District 7, Ho Chi Minh City', '+84 28 8765 4321', 'd7@acme-bida.com', '09:00-23:00 Daily')
ON CONFLICT DO NOTHING;

-- Insert sample users (password: 'password123' - should be hashed in production)
INSERT INTO users (username, email, password_hash, role, company_id, club_id) VALUES 
('admin', 'admin@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'OWNER', 1, NULL),
('manager', 'manager@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CLUB_MANAGER', 1, 1),
('staff1', 'staff1@acme-bida.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'STAFF', 1, 1),
('customer1', 'customer1@example.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'CUSTOMER', NULL, NULL)
ON CONFLICT (username) DO NOTHING;

-- Insert sample tables
INSERT INTO tables (club_id, name, type, status, hourly_rate) VALUES 
(1, 'Table 1', 'POOL_8_BALL', 'AVAILABLE', 150000),
(1, 'Table 2', 'POOL_8_BALL', 'AVAILABLE', 150000),
(1, 'Table 3', 'POOL_9_BALL', 'AVAILABLE', 180000),
(1, 'Table 4', 'SNOOKER', 'AVAILABLE', 200000),
(1, 'Table 5', 'CAROM', 'MAINTENANCE', 120000)
ON CONFLICT DO NOTHING;

-- Insert sample products
INSERT INTO products (club_id, name, description, category, price, is_available) VALUES 
-- Beverages
(1, 'Coca Cola', '330ml can', 'BEVERAGE', 15000, true),
(1, 'Pepsi', '330ml can', 'BEVERAGE', 15000, true),
(1, 'Heineken', '330ml bottle', 'BEVERAGE', 25000, true),
(1, 'Tiger Beer', '330ml bottle', 'BEVERAGE', 22000, true),
(1, 'Coffee', 'Vietnamese coffee', 'BEVERAGE', 20000, true),
(1, 'Tea', 'Green tea', 'BEVERAGE', 15000, true),

-- Food
(1, 'Pho', 'Vietnamese noodle soup', 'FOOD', 45000, true),
(1, 'Com Tam', 'Broken rice with pork', 'FOOD', 35000, true),
(1, 'Banh Mi', 'Vietnamese sandwich', 'FOOD', 25000, true),
(1, 'Spring Rolls', 'Fresh spring rolls', 'FOOD', 30000, true),

-- Snacks
(1, 'Peanuts', 'Roasted peanuts', 'SNACK', 15000, true),
(1, 'Chips', 'Potato chips', 'SNACK', 20000, true),
(1, 'Nuts Mix', 'Mixed nuts', 'SNACK', 25000, true),

-- Other
(1, 'Cue Tip', 'Pool cue tip replacement', 'OTHER', 50000, true),
(1, 'Chalk', 'Pool chalk', 'OTHER', 10000, true)
ON CONFLICT DO NOTHING;

-- Note: Bookings, orders, and bills will be inserted in V3 migration after all tables and users are created
