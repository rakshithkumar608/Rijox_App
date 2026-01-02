import 'package:flutter/material.dart';
import 'package:rijox/presentation/pages/auth/forgot_password_page.dart';
import 'package:rijox/presentation/pages/auth/login_page.dart';
import 'package:rijox/presentation/pages/auth/register_page.dart';
import 'package:rijox/presentation/pages/home/home_page.dart';
import 'package:rijox/presentation/pages/onboarding/onboarding_page.dart';
// import 'package:rijox/presentation/pages/root/root_page.dart';
import 'package:rijox/presentation/pages/splash/splash_page.dart';
import 'package:rijox/presentation/pages/auth/otp_verify_page.dart';
import 'package:rijox/presentation/pages/auth/reset_password_page.dart';

class AppRoutes {
  // static const root = "/";
  static const splash = "/";
  static const onboarding = "/onboarding";
  static const home = "/home";
  static const login = "/login";
  static const register = "/register";
  static const forgotPassword = "/forgot_password";
  static const otpVerify = "/otp_verify";
  static const resetPassword = "/reset_password";

  static Map<String, WidgetBuilder> routes = {
    // root:(_) => const RootPage(),
    splash: (_) => const SplashPage(),
    onboarding: (_) => const OnboardingPage(),
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    forgotPassword: (_) => const ForgotPasswordPage(),
    otpVerify: (_) => const OTPVerifyPage(),
    resetPassword:(_) => const ResetPasswordPage(),
  };
}
