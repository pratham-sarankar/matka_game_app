import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/utils/errors/request_limit_exception.dart';

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

  Future<void> deleteTransaction(WalletTransaction transaction) {
    return FirebaseFirestore.instance
        .collection(_collection)
        .doc(transaction.id)
        .delete();
  }

  Future<void> addWalletTransaction(WalletTransaction walletTransaction) async {
    await FirebaseFirestore.instance
        .runTransaction((firestoreTransaction) async {
      // Get user document
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(walletTransaction.userID);
      final userDoc = await firestoreTransaction.get(userRef);

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Get today's request count
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final requestCountQuery = FirebaseFirestore.instance
          .collection(_collection)
          .where('userID', isEqualTo: walletTransaction.userID)
          .where('requestedAt', isGreaterThanOrEqualTo: startOfDay)
          .where('requestedAt', isLessThan: endOfDay);

      final requestCountSnapshot = await requestCountQuery.get();
      final requestCount = requestCountSnapshot.docs.length;

      if (requestCount >= 10) {
        throw RequestLimitException(
          'You have reached the daily limit of 10 ${walletTransaction.type.name.toLowerCase()} requests. Please try again tomorrow.',
        );
      }

      // Check balance for withdrawal requests
      if (walletTransaction.type == WalletTransactionType.withdrawal) {
        final currentBalance =
            (userDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;

        if (currentBalance < walletTransaction.amount) {
          throw Exception(
            'Insufficient balance. Required: ₹${walletTransaction.amount}, Available: ₹$currentBalance',
          );
        }
      }

      // Add the transaction
      final transactionRef =
          FirebaseFirestore.instance.collection(_collection).doc();
      firestoreTransaction.set(transactionRef, {
        ...walletTransaction.toMap(),
        'requestedAt': Timestamp.now(),
      });
    });
  }
}
