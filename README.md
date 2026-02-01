# E-Commerce App - Authentication System

A production-ready **Sign In / Sign Up authentication system** for a mobile e-commerce app with modern Uber-like UX.

## 🎯 Features

- ✅ User Registration with validation
- ✅ User Login with secure password verification
- ✅ Session management using SharedPreferences
- ✅ Auto-redirect for logged-in users
- ✅ Modern Uber-style UI design
- ✅ Form validation with error handling
- ✅ Secure password hashing (bcrypt)
- ✅ RESTful API architecture

---

## 🧱 Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (latest stable) |
| **Backend** | PHP 7.4+ |
| **Database** | MySQL (XAMPP) |
| **HTTP Client** | http package |
| **Local Storage** | shared_preferences |

---

## 📁 Project Structure

### Flutter (lib/)
```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants.dart           # App-wide constants
│   ├── theme.dart               # Uber-style theme
│   └── api_endpoints.dart       # Centralized API URLs
├── models/
│   └── user_model.dart          # User data model
├── services/
│   ├── api_service.dart         # HTTP request handler
│   └── auth_service.dart        # Authentication logic
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart    # Login UI
│   │   ├── signup_screen.dart   # Registration UI
│   │   └── auth_wrapper.dart    # Auth state handler
│   └── dashboard/
│       └── dashboard_screen.dart # Main dashboard
├── widgets/
│   ├── custom_button.dart       # Reusable button
│   └── custom_textfield.dart    # Reusable input field
└── utils/
    └── validators.dart          # Input validators
```

### PHP Backend (C:\xampp\htdocs\ecommerce_api\)
```
ecommerce_api/
├── config/
│   └── db.php                   # Database connection
├── auth/
│   ├── signup.php               # Registration endpoint
│   └── login.php                # Login endpoint
└── response.php                 # JSON response helpers
```

---

## 🗄️ Database Setup (XAMPP)

### Step 1: Start XAMPP
1. Open XAMPP Control Panel
2. Start **Apache** and **MySQL**

### Step 2: Create Database
1. Open phpMyAdmin: http://localhost/phpmyadmin
2. Click "New" to create database
3. Database name: `ecommerce_app`
4. Collation: `utf8mb4_unicode_ci`
5. Click "Create"

### Step 3: Create Users Table
Run this SQL in phpMyAdmin:

```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## 🚀 Run Instructions

### Backend Setup

1. **Verify XAMPP is running**
   - Apache: Running on port 80
   - MySQL: Running on port 3306

2. **Verify API files exist at:**
   ```
   C:\xampp\htdocs\ecommerce_api\
   ├── config\db.php
   ├── auth\signup.php
   ├── auth\login.php
   └── response.php
   ```

3. **Test API endpoints:**
   ```bash
   # Test signup
   curl -X POST http://localhost/ecommerce_api/auth/signup.php \
     -H "Content-Type: application/json" \
     -d '{"name":"Test User","email":"test@example.com","password":"password123"}'

   # Test login
   curl -X POST http://localhost/ecommerce_api/auth/login.php \
     -H "Content-Type: application/json" \
     -d '{"email":"test@example.com","password":"password123"}'
   ```

### Flutter Setup

1. **Install dependencies:**
   ```bash
   cd e:\flutterProject\test1\flutter_application_1
   flutter pub get
   ```

2. **Run on Android Emulator:**
   ```bash
   flutter run
   ```

3. **Run on physical device:**
   - Update `api_endpoints.dart` with your computer's local IP
   - Example: `http://192.168.1.x/ecommerce_api`

---

## 🧪 Testing Steps

### Test 1: User Registration
1. Launch the app
2. Click "Sign Up"
3. Enter:
   - Name: Test User
   - Email: test@example.com
   - Password: password123
   - Confirm Password: password123
4. Accept Terms & Conditions
5. Click "Create Account"
6. ✅ Should navigate to Dashboard

### Test 2: User Login
1. Logout from Dashboard
2. Enter registered credentials
3. Click "Sign In"
4. ✅ Should navigate to Dashboard

### Test 3: Session Persistence
1. Close the app completely
2. Reopen the app
3. ✅ Should auto-navigate to Dashboard (no login required)

### Test 4: Validation
1. Try submitting empty form
2. Try invalid email format
3. Try short password (<6 chars)
4. Try mismatched passwords
5. ✅ Should show appropriate error messages

### Test 5: Duplicate Email
1. Try registering with existing email
2. ✅ Should show "Account already exists" error

---

## 🔐 Security Features

| Feature | Implementation |
|---------|----------------|
| Password Hashing | `password_hash()` with BCRYPT (cost 12) |
| Password Verification | `password_verify()` |
| SQL Injection Prevention | PDO Prepared Statements |
| XSS Prevention | Input sanitization |
| CORS | Proper headers configured |
| Error Messages | Generic auth errors (no email enumeration) |

---

## ⚠️ Known Limitations

1. **No JWT/Token Auth** - Session based on local storage only
2. **No Password Reset** - Feature not implemented
3. **No Email Verification** - Users are active immediately
4. **No Rate Limiting** - Should be added for production
5. **No HTTPS** - XAMPP uses HTTP by default

---

## 🔧 Configuration Notes

### Android Emulator
- Uses `10.0.2.2` to access host machine's localhost
- Already configured in `api_endpoints.dart`

### iOS Simulator
- Uses `localhost` directly
- Update `api_endpoints.dart` if needed

### Physical Device
- Must use computer's local IP address
- Example: `192.168.1.100`
- Ensure device and computer are on same network

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0
  shared_preferences: ^2.2.2
```

---

## 🏗️ Architecture

- **Separation of Concerns**: UI, Services, Models separated
- **Singleton Services**: ApiService and AuthService
- **Centralized Configuration**: All constants and endpoints
- **Reusable Widgets**: CustomButton, CustomTextField
- **Clean Error Handling**: Try-catch with user-friendly messages

---

## 📝 License

This project is for educational/demonstration purposes.
