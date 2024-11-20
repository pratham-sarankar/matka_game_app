import 'package:matka_game_app/features/markets/domain/models/market.dart';

abstract class MarketRepository {
  void addMarket(Market market);
  void editMarket(Market market);
  void deleteMarket(Market market);
  Future<List<Market>> fetchMarkets();
}
