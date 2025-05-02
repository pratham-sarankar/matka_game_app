import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/utils/user_role.dart';

/// A service class that provides user-related functionalities.
class UserService extends GetxService {
  // Firebase and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// It holds the current logged in mode of the user.
  ///
  /// Only `Admin` are allowed to switch between modes.
  final Rx<UserRole> mode = Rx<UserRole>(UserRole.user);

  /// Holds the current user's data
  final Rx<UserData?> userData = Rx<UserData?>(UserData.empty());

  /// Initializes the service by setting up auth state listener and fetching initial data
  Future<UserService> init() async {
    // Set up auth state listener
    _auth.authStateChanges().listen(_handleAuthStateChange);

    // If user is already logged in, fetch their data
    if (_auth.currentUser != null) {
      await _fetchUserData();
    }

    return this;
  }

  /// Handles auth state changes
  Future<void> _handleAuthStateChange(User? user) async {
    if (user == null) {
      // User signed out
      userData.value = null;
      mode.value = UserRole.user;
    } else {
      // User signed in or registered
      await _fetchUserData();
    }
  }

  /// Fetches user data from Firestore and creates document if it doesn't exist
  Future<void> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get user document
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        // Create new user document
        final newUserData = UserData(
          uid: user.uid,
          email: user.email ?? '',
          role: UserRole.user,
          isActive: true,
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(newUserData.toMap());
        userData.value = newUserData;
      } else {
        // Update existing user data
        userData.value =
            UserData.fromJson(doc.id, doc.data() as Map<String, dynamic>);
      }

      // Set initial mode to user's role
      mode.value = userData.value?.role ?? UserRole.user;
    } catch (e) {
      print('Error fetching user data: $e');
      // Handle error appropriately
    }
  }

  /// Sends a password reset email to the user's email address.
  Future<void> sendPasswordResetEmail() async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in!");
    await _auth.sendPasswordResetEmail(email: user.email!);
  }

  /// Switches the user mode between `User` and `Admin`.
  /// Only users with admin role can switch modes.
  Future<void> switchMode() async {
    if (!isAdmin) {
      Get.snackbar('Error', 'You are not authorized to switch modes!');
      return;
    }

    // Verify admin role in Firestore before switching
    final userDoc =
        await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
    if (!userDoc.exists || userDoc.data()?['role'] != UserRole.admin.code) {
      Get.snackbar('Error', 'Your admin privileges have been revoked!');
      return;
    }

    mode.value = mode.value == UserRole.admin ? UserRole.user : UserRole.admin;
  }

  /// Checks if the current user has admin privileges
  bool get isAdmin => userData.value?.role.isAdmin ?? false;

  /// Checks if the current user is in admin mode
  bool get isInAdminMode => mode.value.isAdmin;

  /// Updates user data in Firestore
  Future<void> updateUserData(UserData data) async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in!");

    // Prevent non-admin users from changing their role
    if (!isAdmin && data.role != userData.value!.role) {
      throw Exception("You are not authorized to change user roles!");
    }

    await _firestore.collection('users').doc(user.uid).update(data.toMap());
    userData.value = data;
  }

  /// Updates another user's data (admin only)
  Future<void> updateOtherUserData(String userId, UserData data) async {
    if (!isAdmin) {
      throw Exception("Only admins can update other users' data!");
    }

    await _firestore.collection('users').doc(userId).update(data.toMap());
  }

  /// Checks if the current user is active
  Future<bool> isUserActive() async {
    final User? user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    return doc.data()?['isActive'] as bool? ?? false;
  }
}

class UserData {
  final String uid;
  final String email;
  final UserRole role;
  final double balance;
  final bool isActive;
  final String fullName;
  final String phoneNumber;
  final BankDetails bankDetails;
  final String upiId;

  UserData({
    required this.uid,
    required this.email,
    required this.role,
    this.balance = 0.0,
    this.isActive = true,
    this.fullName = '',
    this.phoneNumber = '',
    this.bankDetails = const BankDetails(),
    this.upiId = '',
  });

  factory UserData.fromJson(String uid, Map<String, dynamic> json) {
    return UserData(
      uid: uid,
      email: json['email'] ?? "",
      role: UserRole.values[json['role'] as int],
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] as bool? ?? true,
      fullName: json['fullName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      bankDetails: BankDetails.fromJson(
          json['bankDetails'] as Map<String, dynamic>? ?? {}),
      upiId: json['upiId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role.code,
      'balance': balance,
      'isActive': isActive,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'bankDetails': bankDetails.toMap(),
      'upiId': upiId,
    };
  }

  UserData copyWith({
    String? uid,
    String? email,
    UserRole? role,
    double? balance,
    bool? isActive,
    String? fullName,
    String? phoneNumber,
    BankDetails? bankDetails,
    String? upiId,
  }) {
    return UserData(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      balance: balance ?? this.balance,
      isActive: isActive ?? this.isActive,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bankDetails: bankDetails ?? this.bankDetails,
      upiId: upiId ?? this.upiId,
    );
  }

  static UserData empty() {
    return UserData(
      uid: '',
      email: '',
      role: UserRole.user,
    );
  }
}

class BankDetails {
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String accountHolderName;

  const BankDetails({
    this.accountNumber = '',
    this.ifscCode = '',
    this.bankName = '',
    this.accountHolderName = '',
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      accountNumber: json['accountNumber'] as String? ?? '',
      ifscCode: json['ifscCode'] as String? ?? '',
      bankName: json['bankName'] as String? ?? '',
      accountHolderName: json['accountHolderName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
    };
  }

  BankDetails copyWith({
    String? accountNumber,
    String? ifscCode,
    String? bankName,
    String? accountHolderName,
  }) {
    return BankDetails(
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
    );
  }
}
