<?php
/**
 * User Model
 * Handles all user-related database operations
 */

class User {
    // Database connection and table
    private $conn;
    private $table_name = "users";
    
    // User properties
    public $id;
    public $name;
    public $email;
    public $password;
    public $created_at;
    
    /**
     * Constructor
     * @param PDO $db Database connection
     */
    public function __construct($db) {
        $this->conn = $db;
    }
    
    /**
     * Create new user (Sign Up)
     * @return bool
     */
    public function create() {
        $query = "INSERT INTO " . $this->table_name . " 
                  SET name = :name, 
                      email = :email, 
                      password = :password, 
                      created_at = :created_at";
        
        $stmt = $this->conn->prepare($query);
        
        // Sanitize inputs
        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->email = htmlspecialchars(strip_tags($this->email));
        $this->created_at = date('Y-m-d H:i:s');
        
        // Hash password
        $password_hash = password_hash($this->password, PASSWORD_BCRYPT);
        
        // Bind parameters
        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":email", $this->email);
        $stmt->bindParam(":password", $password_hash);
        $stmt->bindParam(":created_at", $this->created_at);
        
        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        
        return false;
    }
    
    /**
     * Check if email already exists
     * @return bool
     */
    public function emailExists() {
        $query = "SELECT id, name, email, password, created_at 
                  FROM " . $this->table_name . " 
                  WHERE email = :email 
                  LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        
        // Sanitize email
        $this->email = htmlspecialchars(strip_tags($this->email));
        
        $stmt->bindParam(":email", $this->email);
        $stmt->execute();
        
        if($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            
            $this->id = $row['id'];
            $this->name = $row['name'];
            $this->email = $row['email'];
            $this->password = $row['password'];
            $this->created_at = $row['created_at'];
            
            return true;
        }
        
        return false;
    }
    
    /**
     * Get user by ID
     * @return bool
     */
    public function getById() {
        $query = "SELECT id, name, email, created_at 
                  FROM " . $this->table_name . " 
                  WHERE id = :id 
                  LIMIT 1";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":id", $this->id);
        $stmt->execute();
        
        if($stmt->rowCount() > 0) {
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            
            $this->name = $row['name'];
            $this->email = $row['email'];
            $this->created_at = $row['created_at'];
            
            return true;
        }
        
        return false;
    }
    
    /**
     * Update user profile
     * @return bool
     */
    public function update() {
        $query = "UPDATE " . $this->table_name . " 
                  SET name = :name 
                  WHERE id = :id";
        
        $stmt = $this->conn->prepare($query);
        
        // Sanitize
        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->id = htmlspecialchars(strip_tags($this->id));
        
        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":id", $this->id);
        
        return $stmt->execute();
    }
}
?>
