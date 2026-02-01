<?php
/**
 * User Login API
 * POST /auth/login.php
 * 
 * Request Body:
 * {
 *   "email": "john@example.com",
 *   "password": "password123"
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "message": "Login successful",
 *   "user": {
 *     "id": 1,
 *     "name": "John Doe",
 *     "email": "john@example.com",
 *     "created_at": "2026-02-01 10:30:00"
 *   }
 * }
 */

// Headers
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Only allow POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode([
        "success" => false,
        "message" => "Method not allowed. Use POST."
    ]);
    exit;
}

// Include database and user model
include_once '../config/database.php';
include_once '../models/User.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Create user object
$user = new User($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Validate required fields
if (
    empty($data->email) ||
    empty($data->password)
) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Email and password are required"
    ]);
    exit;
}

// Set email to check
$user->email = strtolower(trim($data->email));

// Check if user exists
if (!$user->emailExists()) {
    http_response_code(404);
    echo json_encode([
        "success" => false,
        "message" => "No account found with this email"
    ]);
    exit;
}

// Verify password
if (password_verify($data->password, $user->password)) {
    http_response_code(200);
    echo json_encode([
        "success" => true,
        "message" => "Login successful",
        "user" => [
            "id" => $user->id,
            "name" => $user->name,
            "email" => $user->email,
            "created_at" => $user->created_at
        ]
    ]);
} else {
    http_response_code(401);
    echo json_encode([
        "success" => false,
        "message" => "Incorrect password. Please try again."
    ]);
}
?>
