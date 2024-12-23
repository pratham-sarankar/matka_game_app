import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';

class UserWalletsRepository {
  Stream<List<WalletTransaction>> streamWalletRequests() {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('wallet_transaction')
        .where('status', isEqualTo: WalletTransactionStatus.pending.name)
        .snapshots()
        .map(
          (event) => event.docs.map(WalletTransaction.fromDoc).toList(),
        );
  }

  Future<void> updateTransactionStatus(
      WalletTransaction transaction, WalletTransactionStatus status) async {
    final firestore = FirebaseFirestore.instance;
    final update = {
      "status": status.name,
      "respondedAt": Timestamp.now(),
    };
    await firestore
        .collection('wallet_transaction')
        .doc(transaction.id)
        .update(update);

    // If the transaction is approved, update the user's wallet balance
    if (status == WalletTransactionStatus.approved) {
      final user =
          await firestore.collection('users').doc(transaction.userID).get();
      final currentBalance = user.data()?['balance'] ?? 0;
      final type = transaction.type;
      var newBalance = currentBalance;
      if (type == WalletTransactionType.deposit) {
        newBalance += transaction.amount;
      } else {
        newBalance -= transaction.amount;
      }
      await user.reference.update({"balance": newBalance});
    }
  }
}
