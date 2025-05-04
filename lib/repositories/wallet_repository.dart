import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/services/user_service.dart';

class WalletRepository {
  final String _collection = 'wallet_transactions';
  final UserService _userService = Get.find<UserService>();

  Query<Map<String, dynamic>> query({
    double? minAmount,
    double? maxAmount,
    DateTime? fromDate,
    DateTime? toDate,
    WalletTransactionType? selectedType,
    WalletTransactionStatus? selectedStatus,
  }) {
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection(_collection)
        .orderBy('requestedAt', descending: true);

    // Only filter by user ID if the current user is not an admin
    if (!_userService.isAdmin) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      query = query.where('userID', isEqualTo: userId);
    }

    if (minAmount != null) {
      query = query.where('amount', isGreaterThanOrEqualTo: minAmount);
    }
    if (maxAmount != null) {
      query = query.where('amount', isLessThanOrEqualTo: maxAmount);
    }
    if (fromDate != null) {
      query = query.where('requestedAt', isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where('requestedAt', isLessThanOrEqualTo: toDate);
    }
    if (selectedType != null) {
      query = query.where('type', isEqualTo: selectedType.name);
    }
    if (selectedStatus != null) {
      query = query.where('status', isEqualTo: selectedStatus.name);
    }

    return query;
  }

  Future<void> addTransaction(WalletTransaction transaction) async {
    transaction.requestedAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection(_collection)
        .add(transaction.toMap());
  }

  Future<void> deleteTransaction(WalletTransaction transaction) {
    return FirebaseFirestore.instance
        .collection(_collection)
        .doc(transaction.id)
        .delete();
  }
}
