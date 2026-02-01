<?php
/**
 * Database Configuration
 * MySQL connection settings for the E-Commerce API
 * 
 * SETUP INSTRUCTIONS:
 * 1. Install XAMPP and start Apache + MySQL
 * 2. Open phpMyAdmin (http://localhost/phpmyadmin)
 * 3. Create a new database called 'ecommerce_db'
 * 4. Copy this entire 'ecommerce_api' folder to C:\xampp\htdocs\
 */

class Database {
    // Database credentials - UPDATE THESE IF NEEDED
    private $host = "localhost";
    private $db_name = "ecommerce_db";
    private $username = "root";
    private $password = ""; // Default XAMPP password is empty
    
    public $conn;
    
    /**
     * Get database connection
     * @return PDO|null
     */
    public function getConnection() {
        $this->conn = null;
        
        try {
            $this->conn = new PDO(
                "mysql:host=" . $this->host . ";dbname=" . $this->db_name,
                $this->username,
                $this->password
            );
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->conn->exec("set names utf8");
        } catch(PDOException $exception) {
            // Return connection error as JSON
            http_response_code(500);
            echo json_encode([
                "success" => false,
                "message" => "Database connection error: " . $exception->getMessage()
            ]);
            exit;
        }
        
        return $this->conn;
    }
}
?>
