import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matka_game_app/models/bid.dart';

class BidRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<void> placeBid(Bid bid) async {
    // Start a transaction to ensure atomicity
    await _firestore.runTransaction((transaction) async {
      // Get user's current balance
      final userDoc =
          await transaction.get(_firestore.collection('users').doc(bid.userId));

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final currentBalance =
          (userDoc.data()?['balance'] as num?)?.toDouble() ?? 0.0;

      // Check if user has sufficient balance
      if (currentBalance < bid.amount) {
        throw Exception(
            'Insufficient balance. Required: ₹${bid.amount}, Available: ₹$currentBalance');
      }

      // Deduct amount from user's balance
      transaction.update(_firestore.collection('users').doc(bid.userId),
          {'balance': currentBalance - bid.amount});

      // Add the bid
      final bidRef = _firestore.collection('bids').doc();
      transaction.set(bidRef, bid.toMap());
    });
  }

  Stream<List<Bid>> getBidsForMarket(String marketId) {
    return _firestore
        .collection('bids')
        .where('marketId', isEqualTo: marketId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Bid.fromDoc(doc)).toList();
    });
  }

  Stream<List<Bid>> getUserBids(String userId) {
    return _firestore
        .collection('bids')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Bid.fromDoc(doc)).toList();
    });
  }
}
