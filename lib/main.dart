import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_storage/firebase_ui_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/firebase_options.dart';
import 'package:matka_game_app/navigation/pages.dart';
import 'package:matka_game_app/navigation/routes.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/theme.dart';

void main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  //sdljgvbdsougblsdukfbgdfcfwfwersfsrgergerfbftbe

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configure Firebase UI Auth
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);

  // Configure Firebase UI Storage
  final storage = FirebaseStorage.instance;
  final config = FirebaseUIStorageConfiguration(
    storage: storage,
    uploadRoot: storage.ref('files'),
    namingPolicy: UuidFileUploadNamingPolicy(),
  );
  await FirebaseUIStorage.configure(config);

  // Put Services
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
      //done setting up github actions
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: MaterialTheme(GoogleFonts.poppinsTextTheme()).light(),
      getPages: AppPages.pages,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? Routes.home
          : Routes.login,
    );
  }
}
