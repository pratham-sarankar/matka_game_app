import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  static bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  final _auth = FirebaseAuth.instance;

  /// Logs in the user with the given [email] and [password].
  ///
  /// If the user doen't exist, it will create a new user
  /// with the given [email] and [password].
  Future<UserCredential?> loginWithEmailAndPassword(
      String email, String password) async {
    late final UserCredential? credentials;
    try {
      credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        credentials = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        rethrow;
      }
    }
    return credentials;
  }
}
