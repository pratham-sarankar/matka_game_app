import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';

class WalletRepository {
  Stream<List<WalletTransaction>> streamTransactions() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('wallet_transaction')
        .where('userID', isEqualTo: uid)
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((event) => event.docs.map(WalletTransaction.fromDoc).toList());
  }

  Future<void> addTransaction(WalletTransaction transaction) async {
    transaction.requestedAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection('wallet_transaction')
        .add(transaction.toMap());
  }

  Future<void> deleteTransaction(WalletTransaction transaction) {
    return FirebaseFirestore.instance
        .collection('wallet_transaction')
        .doc(transaction.id)
        .delete();
  }
}
