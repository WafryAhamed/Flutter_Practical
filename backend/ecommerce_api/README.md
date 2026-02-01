# E-Commerce API Backend

PHP + MySQL backend for the Flutter E-Commerce application.

## 📋 Setup Instructions

### Step 1: Install XAMPP
1. Download XAMPP from https://www.apachefriends.org/
2. Install with default settings
3. Open XAMPP Control Panel

### Step 2: Start Services
1. Click **Start** next to **Apache**
2. Click **Start** next to **MySQL**
3. Both should show green "Running" status

### Step 3: Create Database
1. Open your browser
2. Go to: **http://localhost/phpmyadmin**
3. Click **"SQL"** tab at the top
4. Copy contents of `setup/create_database.sql`
5. Paste into the SQL text area
6. Click **"Go"** button

### Step 4: Copy API Files
Copy the entire `ecommerce_api` folder to:
```
C:\xampp\htdocs\ecommerce_api
```

Your folder structure should look like:
```
C:\xampp\htdocs\
    └── ecommerce_api\
        ├── config\
        │   └── database.php
        ├── models\
        │   └── User.php
        ├── auth\
        │   ├── signup.php
        │   └── login.php
        └── setup\
            └── create_database.sql
```

### Step 5: Test API
Open your browser and go to:
- http://localhost/ecommerce_api/auth/signup.php

You should see:
```json
{"success":false,"message":"Method not allowed. Use POST."}
```

This means the API is working! (It only accepts POST requests)

### Step 6: Update Flutter App
In your Flutter app, set `useMockData = false`:
```dart
// lib/core/constants.dart
static const bool useMockData = false;
```

## 🔌 API Endpoints

### Sign Up
- **URL:** `POST /auth/signup.php`
- **Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123"
}
```

### Login
- **URL:** `POST /auth/login.php`
- **Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

## 🔧 Troubleshooting

### "Connection refused" error
- Make sure Apache and MySQL are running in XAMPP
- Check if the `ecommerce_api` folder is in `C:\xampp\htdocs\`

### "Database connection error"
- Make sure MySQL is running
- Create the database using phpMyAdmin
- Check credentials in `config/database.php`

### CORS errors
- The API already includes CORS headers for all origins
- If issues persist, check browser console for details
