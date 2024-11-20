import 'package:cloud_firestore/cloud_firestore.dart';

class Market {
  final String name;
  final Timestamp openTime;
  final Timestamp closeTime;

  Market({required this.name, required this.openTime, required this.closeTime});

  factory Market.fromMap(Map<String, dynamic> map) {
    return Market(
      name: map['name'],
      openTime: Timestamp.fromDate(DateTime.parse(map['openTime'])),
      closeTime: Timestamp.fromDate(DateTime.parse(map['closeTime'])),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'openTime': openTime,
      'closeTime': closeTime,
    };
  }
}
