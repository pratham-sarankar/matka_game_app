import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/firebase_options.dart';
import 'package:matka_game_app/navigation/pages.dart';
import 'package:matka_game_app/navigation/routes.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/services/auth_service.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/theme.dart';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Put Services
  Get.put(AuthService(), permanent: true);
  await Get.putAsync(UserService().init, permanent: true);

  // Put Repositories
  Get.put(UserRepository());

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
      getPages: AppPages.pages,
      initialRoute: AuthService.isLoggedIn ? Routes.home : Routes.login,
    );
  }
}
