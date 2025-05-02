import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/utils/user_role.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'users';

  CollectionReference<UserData> _getCollection() {
    return _firestore.collection(_collection).withConverter<UserData>(
          fromFirestore: (snapshot, _) => UserData.fromJson(
            snapshot.id,
            snapshot.data()!,
          ),
          toFirestore: (user, _) => user.toMap(),
        );
  }

  Query<UserData> query({
    UserRole? role,
    bool? isActive,
  }) {
    Query<UserData> query = _getCollection();

    if (role != null) {
      query = query.where('role', isEqualTo: role.code);
    }

    if (isActive != null) {
      query = query.where('isActive', isEqualTo: isActive);
    }

    return query;
  }

  /// Streams all users except the current user
  Stream<List<UserData>> streamUsers({
    UserRole? role,
    bool? isActive,
  }) {
    return query(role: role, isActive: isActive).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  /// Updates a user's data
  /// Only admins can update other users' data
  Future<void> updateUser(UserData user) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in!");

    // Get current user's role
    final currentUserDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    final isAdmin = currentUserDoc.data()?['role'] == UserRole.admin.code;

    // If not admin, can only update own data
    if (!isAdmin && currentUser.uid != user.uid) {
      throw Exception("You are not authorized to update other users' data!");
    }

    // If not admin, cannot change role
    if (!isAdmin &&
        user.role !=
            UserRoleExtension.fromCode(currentUserDoc.data()?['role'])) {
      throw Exception("You are not authorized to change user roles!");
    }

    await _getCollection().doc(user.uid).update(user.toMap());
  }

  /// Activates a user
  /// Only admins can activate users
  Future<void> activateUser(UserData user) async {
    await _updateUserStatus(user, true);
  }

  /// Deactivates a user
  /// Only admins can deactivate users
  Future<void> deactivateUser(UserData user) async {
    await _updateUserStatus(user, false);
  }

  /// Updates user status (activate/deactivate)
  Future<void> _updateUserStatus(UserData user, bool isActive) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in!");

    // Verify admin role
    final currentUserDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    if (currentUserDoc.data()?['role'] != UserRole.admin.code) {
      throw Exception("Only admins can change user status!");
    }

    await _getCollection().doc(user.uid).update({'isActive': isActive});
  }

  /// Changes a user's role
  /// Only admins can change roles
  Future<void> changeUserRole(String userEmail, UserRole newRole) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in!");

    // Verify admin role
    final currentUserDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();
    if (currentUserDoc.data()?['role'] != UserRole.admin.code) {
      throw Exception("Only admins can change user roles!");
    }

    // Prevent changing own role
    if (currentUser.email == userEmail) {
      throw Exception("You cannot change your own role!");
    }

    await _getCollection().doc(userEmail).update({'role': newRole.code});
  }

  /// Updates user's bank details
  Future<void> updateBankDetails(
      String userEmail, BankDetails bankDetails) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in!");

    // Users can only update their own bank details
    if (currentUser.email != userEmail) {
      final currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (currentUserDoc.data()?['role'] != UserRole.admin.code) {
        throw Exception("You can only update your own bank details!");
      }
    }

    await _getCollection()
        .doc(userEmail)
        .update({'bankDetails': bankDetails.toMap()});
  }

  Future<void> createUser(UserData user) async {
    await _getCollection().doc(user.email).set(user);
  }

  Future<void> deleteUser(String userEmail) async {
    await _getCollection().doc(userEmail).delete();
  }

  Future<UserData?> getUser(String userEmail) async {
    final doc = await _getCollection().doc(userEmail).get();
    return doc.data();
  }
}
