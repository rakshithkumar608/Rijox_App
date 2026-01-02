import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();

  bool loading = false;
  bool show1 = false;
  bool show2 = false;

  Future<void> resetPassword() async {
    final p1 = pass1.text.trim();
    final p2 = pass2.text.trim();

    if (p1 != p2) {
      showMsg("Passwords do not match", true);
      return;
    }

    if (p1.length < 6) {
      showMsg("Password must be at least 6 characters", true);
      return;
    }

    try {
      setState(() => loading = true);

      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        showMsg("User not logged in. Please login again.", true);
        return;
      }

      await user.updatePassword(p1);

      showMsg("Password updated successfully 🎉", false);

      Navigator.popUntil(context, (route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        showMsg("Session expired. Please login again.", true);
      } else {
        showMsg(e.message ?? "Something went wrong", true);
      }
    } catch (e) {
      showMsg(e.toString(), true);
    } finally {
      setState(() => loading = false);
    }
  }

  void showMsg(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
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
                "Reset Password",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.all(25),
                child: TextField(
                  controller: pass1,
                  obscureText: !show1,
                  decoration: InputDecoration(
                    hintText: "Enter new password",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        show1 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => show1 = !show1),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: pass2,
                  obscureText: !show2,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: Icon(
                        show2 ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => show2 = !show2),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: loading ? null : resetPassword,
                child: Container(
                  height: 55,
                  width: 220,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text(
                          "Update Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
