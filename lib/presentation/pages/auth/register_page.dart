import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rijox/core/utils/validators.dart';
import 'package:rijox/presentation/pages/auth/login_page.dart';
import 'package:rijox/presentation/pages/home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool googleLoading = false;

  /// EMAIL/PASSWORD REGISTRATION
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      setState(() => loading = true);

      // 1. Create user with email/password
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Save display name in Firebase
      await userCredential.user?.updateDisplayName(name);
      await userCredential.user?.reload();

      // 3. Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Account created successfully 🎉"),
        ),
      );

      // 4. Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? "Registration failed";

      if (e.code == "email-already-in-use") {
        message = "This email is already registered.";
      } else if (e.code == "invalid-email") {
        message = "Enter a valid email.";
      } else if (e.code == "weak-password") {
        message = "Password must be at least 6 characters.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  /// GOOGLE SIGN-IN
  Future<void> signInWithGoogle() async {
    try {
      setState(() => googleLoading = true);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Google sign-in failed: $e"),
        ),
      );
    } finally {
      setState(() => googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffb51837), Color(0xff661c3a), Color(0xff301939)],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 30, top: 30),
                  child: Text(
                    "\nCreate Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        const Text(
                          "Full Name",
                          style: TextStyle(
                            color: Color(0xffb51837),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: Validators.name,
                          decoration: const InputDecoration(
                            hintText: "Enter your Name",
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email
                        const Text(
                          "Email",
                          style: TextStyle(
                            color: Color(0xffb51837),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: emailController,
                          validator: Validators.email,
                          decoration: const InputDecoration(
                            hintText: "Enter your Email",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        const Text(
                          "Password",
                          style: TextStyle(
                            color: Color(0xffb51837),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          validator: Validators.password,
                          decoration: const InputDecoration(
                            hintText: "Enter your Password",
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Register Button
                        GestureDetector(
                          onTap: loading ? null : registerUser,
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xffb51837),
                                  Color(0xff661c3a),
                                  Color(0xff301939),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Google Sign-in Button
                        Center(
                          child: GestureDetector(
                            onTap: googleLoading ? null : signInWithGoogle,
                            child: Container(
                              height: 55,
                              width: 260,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/google.webp",
                                    height: 28,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Sign up with Google",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  if (googleLoading) ...[
                                    const SizedBox(width: 10),
                                    const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? ",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginPage(),
                                ),
                              ),
                              child: const Text(
                                "SIGN IN",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
