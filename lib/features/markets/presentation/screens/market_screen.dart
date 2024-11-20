import 'package:flutter/material.dart';
import 'package:matka_game_app/features/home/presentation/widgets/home_card.dart';
import 'package:matka_game_app/features/markets/data/repositories/market_repository.dart';
import 'package:matka_game_app/features/markets/domain/models/market.dart';
import 'package:matka_game_app/features/markets/domain/repositories/market_repository.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  final MarketRepository repository = MarketRepositoryImpl();
  List<Market> markets = [];

  @override
  void initState() {
    repository.fetchMarkets().then((value) {
      setState(() {
        markets = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color(0xff530b47),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarket,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: width * 0.05,
          ),
          children: [
            const Text(
              "Markets",
              style: TextStyle(
                color: Color(0xFFecd7b4),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 18),
            for (final market in markets)
              MarketCard(
                text: "Sridevi",
                isRunning: false,
                onPlayNow: () {},
              ),
          ],
        ),
      ),
    );
  }

  void _addMarket() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            top: 25,
            bottom: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Market",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Market Name",
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}
