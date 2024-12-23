import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matka_game_app/services/user_service.dart';

class UserRepository {
  Stream<List<UserData>> streamUsers() {
    final user = FirebaseAuth.instance.currentUser?.email;
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isNotEqualTo: user)
        .snapshots()
        .map(
      (event) {
        return event.docs.map(
          (e) {
            return UserData.fromJson(e.data());
          },
        ).toList();
      },
    );
  }

  Future<void> updateUser(UserData user) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      result.docs.first.reference.update(user.toMap());
    } else {
      throw "User not found";
    }
  }

  Future<void> unblockUser(UserData user) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      result.docs.first.reference.update({'status': 1});
    } else {
      throw "User not found";
    }
  }

  Future<void> blockUser(UserData user) async {
    final result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      result.docs.first.reference.update({'status': 0});
    } else {
      throw "User not found";
    }
  }
}
