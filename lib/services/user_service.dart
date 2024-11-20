import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/core/utils/user_role.dart';

class UserService extends GetxService {
  Rx<UserRole> role = UserRole.user.obs;

  RxBool adminMode = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void setAdminMode(bool value) {
    if (role.value == UserRole.admin) {
      adminMode.value = value;
    }
  }

  @override
  void onInit() {
    _fetchDetails();
    ever(
      adminMode,
      (mode) {
        // If trying to set admin mode as true, then check if the role is
        // admin or not.
        if (mode) {
          if (role.value != UserRole.admin) {
            adminMode.value = false;
          }
        }
      },
    );
    super.onInit();
  }

  void _fetchDetails() async {
    final user = _auth.currentUser;
    if (user == null) return;
    // Fetch user details from the cloud firestore
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('users').doc(user.uid).get();
    role.value = UserRoleExtension.fromCode(snapshot.data()?['role']);
  }
}
