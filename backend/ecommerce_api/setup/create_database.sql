-- ============================================
-- E-Commerce Database Setup Script
-- ============================================
-- 
-- HOW TO USE:
-- 1. Open XAMPP Control Panel
-- 2. Start Apache and MySQL
-- 3. Open phpMyAdmin (http://localhost/phpmyadmin)
-- 4. Click on "SQL" tab at the top
-- 5. Copy and paste this entire script
-- 6. Click "Go" to execute
--
-- This will create the database and users table
-- ============================================

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS ecommerce_db;

-- Use the database
USE ecommerce_db;

-- Drop existing table if needed (WARNING: This deletes all data!)
-- DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT(11) AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert a test user (password: test123)
-- Password hash generated with password_hash('test123', PASSWORD_BCRYPT)
INSERT INTO users (name, email, password, created_at) VALUES 
('Test User', 'test@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', NOW())
ON DUPLICATE KEY UPDATE name = name;

-- Verify table was created
SELECT 'Database setup complete!' AS status;
SELECT * FROM users;
