<?php
/**
 * User Registration (Sign Up) API
 * POST /auth/signup.php
 * 
 * Request Body:
 * {
 *   "name": "John Doe",
 *   "email": "john@example.com",
 *   "password": "password123"
 * }
 * 
 * Response:
 * {
 *   "success": true,
 *   "message": "User registered successfully",
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
    empty($data->name) ||
    empty($data->email) ||
    empty($data->password)
) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "All fields are required: name, email, password"
    ]);
    exit;
}

// Validate email format
if (!filter_var($data->email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Invalid email format"
    ]);
    exit;
}

// Validate password length
if (strlen($data->password) < 6) {
    http_response_code(400);
    echo json_encode([
        "success" => false,
        "message" => "Password must be at least 6 characters"
    ]);
    exit;
}

// Set user properties
$user->name = trim($data->name);
$user->email = strtolower(trim($data->email));
$user->password = $data->password;

// Check if email already exists
if ($user->emailExists()) {
    http_response_code(409);
    echo json_encode([
        "success" => false,
        "message" => "Email already registered. Please use a different email or login."
    ]);
    exit;
}

// Create the user
if ($user->create()) {
    http_response_code(201);
    echo json_encode([
        "success" => true,
        "message" => "User registered successfully",
        "user" => [
            "id" => $user->id,
            "name" => $user->name,
            "email" => $user->email,
            "created_at" => $user->created_at
        ]
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "success" => false,
        "message" => "Unable to register user. Please try again."
    ]);
}
?>
