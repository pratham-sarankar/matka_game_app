import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/features/home/presentation/screens/home_screen.dart';
import 'package:matka_game_app/features/login/presentation/screens/login_screen.dart';
import 'package:matka_game_app/firebase_options.dart';
import 'package:matka_game_app/services/auth_service.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/theme.dart';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Put Dependencies
  Get.put(AuthService(), permanent: true);
  Get.put(UserService(), permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MaterialTheme(GoogleFonts.merriweatherTextTheme()).light(),
      home: AuthService.isLoggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }
}
