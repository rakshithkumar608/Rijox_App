import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rijox/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RijoxApp());
}

class RijoxApp extends StatelessWidget {
  const RijoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rijox",
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
