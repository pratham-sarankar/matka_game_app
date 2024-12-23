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
  final Rx<UserType> mode = Rx<UserType>(UserType.user);

  final Rx<UserData> userData = Rx(UserData('', '', '', UserType.user));

  /// Initializes the service by fetching the user role from Firestore.
  Future<UserService> init() async {
    if (FirebaseAuth.instance.currentUser == null) return this;

    final result = await _fetchUserData();
    userData.value = result;

    // Reload user
    await FirebaseAuth.instance.currentUser?.reload();

    return this;
  }

  /// Sends a password reset email to the user's email address.
  Future<void> sendPasswordResetEmail() async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in!");
    await _auth.sendPasswordResetEmail(email: user.email!);
  }

  /// Switches the user mode between `User` and `Admin`.
  void switchMode() async {
    if (userData.value.role == UserType.admin) {
      mode.value =
          mode.value == UserType.admin ? UserType.user : UserType.admin;
    } else {
      Get.snackbar('Error', 'You are not authorized to switch modes!');
    }
  }

  /// Fetches the user data from Firestore.
  ///
  /// If the user is not logged in, it throws an exception.
  /// It fetches the user's full name, email, and phone number.
  /// If the user document is not found in Firestore, it creates a new document.
  Future<UserData> _fetchUserData() async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in!");

    // Get user document
    final DocumentSnapshot doc =
        await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      final email = user.email ?? '';
      final data = UserData(email, '', '', UserType.user);
      await _firestore.collection('users').doc(user.uid).set(data.toMap());
      return data;
    } else {
      return UserData.fromJson(doc.data() as Map<String, dynamic>);
    }
  }

  Future<void> updateUserData(UserData data) async {
    final User? user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in!");

    await _firestore.collection('users').doc(user.uid).update(data.toMap());
  }
}

class UserData {
  String email;
  UserType role;
  num balance;
  num status;
  String fullName;
  String phoneNumber;
  String upiId;
  String bankAccNumber;
  String bankIfscCode;
  String bankName;
  String accountHolderName;

  UserData(
    this.email,
    this.fullName,
    this.phoneNumber,
    this.role, {
    this.balance = 0,
    this.status = 1,
    this.upiId = '',
    this.bankAccNumber = '',
    this.bankIfscCode = '',
    this.bankName = '',
    this.accountHolderName = '',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['email'] as String,
      json['fullName'] as String,
      json['phoneNumber'] as String,
      UserType.values[json['role'] as int],
      balance: json['balance'] as num,
      status: json['status'] as num,
      upiId: json['upiId'] as String,
      bankAccNumber: json['bankAccNumber'] as String,
      bankIfscCode: json['bankIfscCode'] as String,
      bankName: json['bankName'] as String,
      accountHolderName: json['accountHolderName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role.index,
      'balance': balance,
      'status': status,
      'upiId': upiId,
      'bankAccNumber': bankAccNumber,
      'bankIfscCode': bankIfscCode,
      'bankName': bankName,
      'accountHolderName': accountHolderName,
    };
  }

  bool get isBlocked => status == 0;
}
