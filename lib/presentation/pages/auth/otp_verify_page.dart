import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'reset_password_page.dart';

class OTPVerifyPage extends StatefulWidget {
  final String verificationId;
  final String email;

  const OTPVerifyPage({
    super.key,
    required this.verificationId,
    required this.email, required String phone,
  });

  @override
  State<OTPVerifyPage> createState() => _OTPVerifyPageState();
}

class _OTPVerifyPageState extends State<OTPVerifyPage> with CodeAutoFill {
  String otpCode = "";
  bool loading = false;

  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    listenForCode();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    cancel();
    super.dispose();
  }

  // ---------- TIMER ----------
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining == 0) {
        setState(() => enableResend = true);
        timer?.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  // ---------- AUTO OTP LISTENER ----------
  @override
  void codeUpdated() {
    setState(() => otpCode = code ?? "");

    if (otpCode.length == 6) verifyOTP();
  }

  // ---------- RESEND ----------
  Future<void> resendOTP() async {
    showError("Requesting resend…");

    setState(() {
      secondsRemaining = 60;
      enableResend = false;
    });

    startTimer();

    // IMPORTANT:
    // Call verifyPhoneNumber again in ForgotPasswordPage
  }

  // ---------- VERIFY ----------
  Future<void> verifyOTP() async {
    if (otpCode.length < 6) return;

    try {
      setState(() => loading = true);

      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordPage(email: widget.email),
        ),
      );
    } catch (e) {
      showError("Invalid OTP");
    } finally {
      setState(() => loading = false);
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb51837), Color(0xff301939)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Enter the 6-digit code sent to your phone",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 40),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: PinFieldAutoFill(
                  currentCode: otpCode,
                  codeLength: 6,
                  decoration: UnderlineDecoration(
                    textStyle: TextStyle(fontSize: 20, color: Colors.white),
                    colorBuilder: FixedColorBuilder(Colors.white),
                  ),
                  onCodeChanged: (code) {
                    setState(() => otpCode = code ?? "");
                    if (otpCode.length == 6) verifyOTP();
                  },
                ),
              ),

              const SizedBox(height: 30),

              loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : GestureDetector(
                      onTap: verifyOTP,
                      child: Container(
                        height: 55,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Verify",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),

              const SizedBox(height: 25),

              enableResend
                  ? TextButton(
                      onPressed: resendOTP,
                      child: const Text(
                        "Resend OTP",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Text(
                      "Resend in $secondsRemaining sec",
                      style: const TextStyle(color: Colors.white70),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
