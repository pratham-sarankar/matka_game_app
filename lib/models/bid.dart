import 'package:cloud_firestore/cloud_firestore.dart';

enum BidStatus {
  pending,
  won,
  lost;

  String get name {
    switch (this) {
      case BidStatus.pending:
        return 'Pending';
      case BidStatus.won:
        return 'Won';
      case BidStatus.lost:
        return 'Lost';
    }
  }
}

class Bid {
  final String id;
  final String userId;
  final String marketId;
  final String gameType;
  final String digit;
  final double amount;
  final DateTime timestamp;
  final BidStatus status;
  final String session; // 'open' or 'close'

  Bid({
    required this.id,
    required this.userId,
    required this.marketId,
    required this.gameType,
    required this.digit,
    required this.amount,
    required this.timestamp,
    this.status = BidStatus.pending,
    required this.session,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'marketId': marketId,
      'gameType': gameType,
      'digit': digit,
      'amount': amount,
      'timestamp': timestamp,
      'status': status.name,
      'session': session,
    };
  }

  factory Bid.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Bid(
      id: doc.id,
      userId: data['userId'] as String,
      marketId: data['marketId'] as String,
      gameType: data['gameType'] as String,
      digit: data['digit'] as String,
      amount: (data['amount'] as num).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      status: BidStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => BidStatus.pending,
      ),
      session: data['session'] as String,
    );
  }
}
