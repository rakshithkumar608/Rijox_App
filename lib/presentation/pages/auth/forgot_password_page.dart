import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp_verify_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool loading = false;

  void showMessage(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  // ---------------- EMAIL RESET ----------------
  Future<void> resetWithEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showMessage("Enter email", error: true);
      return;
    }

    try {
      setState(() => loading = true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showMessage("Password reset link sent to email");
    } catch (e) {
      showMessage(e.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  // ---------------- PHONE RESET ----------------
  Future<void> resetWithPhone() async {
    final phone = phoneController.text.trim();

    if (!phone.startsWith("+")) {
      showMessage(
        "Phone must start with country code. Ex: +91XXXXXXXXXX",
        error: true,
      );
      return;
    }

    try {
      setState(() => loading = true);

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (_) {},
        verificationFailed: (e) => showMessage(e.message!, error: true),
        codeSent: (verificationId, token) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OTPVerifyPage(
                verificationId: verificationId,
                email: emailController.text.trim(), phone: '',
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (e) {
      showMessage(e.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb51837), Color(0xff661c3a), Color(0xff301939)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ---------------- EMAIL ----------------
                      const Text(
                        "Reset using Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xffb51837),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: loading ? null : resetWithEmail,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffb51837), Color(0xff661c3a)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Send Reset Link",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text("OR"),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // ---------------- PHONE ----------------
                      const Text(
                        "Reset using Phone OTP",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xffb51837),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: "Ex: +91XXXXXXXXXX",
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: loading ? null : resetWithPhone,
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffb51837), Color(0xff661c3a)],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
