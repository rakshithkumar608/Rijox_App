import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

Future<void> logout(BuildContext context) async {
  try {
    // 1. Firebase logout
    await FirebaseAuth.instance.signOut();

    // 2. Google sign-out if user signed in via Google
    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    // 3. Navigate to login or onboarding
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logout failed: ${e.toString()}"),
        backgroundColor: Colors.red.shade400,
      ),
    );
  }
}
