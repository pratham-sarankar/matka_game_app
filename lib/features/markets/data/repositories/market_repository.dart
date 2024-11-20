import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matka_game_app/features/markets/domain/models/market.dart';
import 'package:matka_game_app/features/markets/domain/repositories/market_repository.dart';

class MarketRepositoryImpl extends MarketRepository {
  @override
  Future<List<Market>> fetchMarkets() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('markets').get();
    return snapshot.docs.map((doc) => Market.fromMap(doc.data())).toList();
  }

  @override
  Future<void> addMarket(Market market) async {
    await FirebaseFirestore.instance
        .collection('markets')
        .doc(market.name)
        .set(market.toMap());
  }

  @override
  Future<void> deleteMarket(Market market) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('markets')
        .where('name', isEqualTo: market.name)
        .limit(1)
        .get();
    final QueryDocumentSnapshot documentSnapshot = snapshot.docs.first;
    await documentSnapshot.reference.delete();
  }

  @override
  Future<void> editMarket(Market market) async {
    await FirebaseFirestore.instance
        .collection('markets')
        .doc(market.name)
        .update(market.toMap());
  }
}
