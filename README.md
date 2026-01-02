# Rijox App

## Overview

Rijox is a Flutter-based application designed to provide a seamless user experience with features like authentication, secure storage, and validation utilities. This document outlines the key components of the app, including routes, validators, and authentication mechanisms.

---

## Routes

The app uses a centralized routing system defined in `app_routes.dart`. Below are the available routes and their purposes:

| Route             | Description                          |
|-------------------|--------------------------------------|
| `/`               | Splash screen                       |
| `/onboarding`     | Onboarding screen                   |
| `/home`           | Home screen                         |
| `/login`          | Login screen                        |
| `/register`       | Registration screen                 |
| `/forgot_password`| Forgot Password screen              |
| `/otp_verify`     | OTP Verification screen             |
| `/reset_password` | Reset Password screen               |

### How It Works

- Routes are defined as constants in the `AppRoutes` class.
- Each route is mapped to a corresponding widget in the `routes` map.
- Navigation is handled using `Navigator.pushNamed` or `Navigator.pushReplacementNamed`.

---

## Validators

The app includes a set of validators to ensure data integrity. These are defined in `validators.dart`:

### Available Validators

1. **Email Validator**
   - Ensures the email is not empty and follows a valid email format.
   - Example: `Validators.email(value)`

2. **Password Validator**
   - Ensures the password is not empty and has at least 8 characters.
   - Example: `Validators.password(value)`

3. **Phone Number Validator**
   - Ensures the phone number is not empty and has at least 10 digits.
   - Example: `Validators.phone(value)`

4. **Name Validator**
   - Ensures the name is not empty and has at least 3 characters.
   - Example: `Validators.name(value)`

5. **OTP Validator**
   - Ensures the OTP is exactly 6 digits and contains only numbers.
   - Example: `Validators.otp(value)`

6. **Non-Empty Field Validator**
   - Ensures a field is not empty.
   - Example: `Validators.nonEmpty(value, "Field Name")`

---

## Authentication

The app uses Firebase for authentication, including email/password and Google sign-in methods. Below are the key functionalities:

### Login

- **File:** `login_page.dart`
- **Description:**
  - Validates user credentials.
  - Uses `FirebaseAuth` to sign in with email and password.
  - Supports Google sign-in.
- **Error Handling:**
  - Displays appropriate error messages for invalid credentials or unexpected errors.

### Register

- **File:** `register_page.dart`
- **Description:**
  - Validates user input.
  - Uses `FirebaseAuth` to create a new user with email and password.
  - Supports Google sign-in.
- **Error Handling:**
  - Handles errors like email already in use, invalid email, and weak passwords.

### Logout

- **File:** `logout_page.dart`
- **Description:**
  - Logs out the user from Firebase.
  - Signs out from Google if the user is logged in via Google.
  - Navigates back to the login screen.
- **Error Handling:**
  - Displays an error message if logout fails.

---

## Secure Storage

The app uses `flutter_secure_storage` to securely store sensitive data like authentication tokens. Below are the available methods:

- **Save Token:**
  - `SecureStorageService.saveToken(String token)`
- **Get Token:**
  - `SecureStorageService.getToken()`
- **Clear Storage:**
  - `SecureStorageService.clear()`

---

## Conclusion

This documentation provides an overview of the Rijox app's core components. For further details, refer to the respective files in the `lib` directory.
