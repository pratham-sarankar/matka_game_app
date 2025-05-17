import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/market.dart';

/// A repository for CRUD operations on [Market]s.
class MarketRepository {
  /// Creates a new [Market] in the database.
  ///
  /// A unique ID is automatically generated for the market and returned.
  /// Throws an error if the operation fails.
  Future<String> create(Market market) async {
    final DocumentReference result = await FirebaseFirestore.instance
        .collection('markets')
        .add(market.toMap());
    return result.id;
  }

  /// Updates an existing [Market] in the database.
  ///
  /// Throws an error if the operation fails.
  Future<void> update(Market market) async {
    await FirebaseFirestore.instance
        .collection('markets')
        .doc(market.id)
        .update(market.toMap());
  }

  /// Deletes an existing [Market] from the database.
  ///
  /// Throws an error if the operation fails.
  Future<void> delete(uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('markets').doc(uid).get();
    await snapshot.reference.delete();
  }

  /// Streams all [Market]s from the database.
  Stream<List<Market>> streamAll() {
    return FirebaseFirestore.instance
        .collection('markets')
        .snapshots()
        .map((ss) => ss.docs.map(Market.fromDoc).toList());
  }
}
