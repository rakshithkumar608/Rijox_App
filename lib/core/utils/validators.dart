class Validators {
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    if (!RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    ).hasMatch(value.trim())) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) return "Phone number is required";
    if (value.length < 10) return "Enter a valid Phone number";
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return "Name cannot be empty";
    if (value.length < 3) return "Name must be at least 3 characters";
    return null;
  }

  static String? nonEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return "$fieldName cannot be empty";
    return null;
  }

  static String? otp(String? value) {
    if (value == null || value.isEmpty) return "OTP is required";
    if (value.length != 6) return "OTP must be exactly 6 digits";
    if (!RegExp(r'^\d{6}\$').hasMatch(value)) {
      return "OTP must contain only digits";
    }
    return null;
  }
}
