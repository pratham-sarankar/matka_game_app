import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/repositories/market_repository.dart';
import 'package:matka_game_app/screens/home/presentation/widgets/market_card.dart';
import 'package:matka_game_app/screens/markets/market_form.dart';
import 'package:matka_game_app/utils/time_of_day_extension.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final MarketRepository _marketRepository = MarketRepository();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    print(TimeOfDayExtension.fromString("23:15"));
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: _addMarket,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Markets"),
      ),
      body: StreamBuilder<Iterable<Market>>(
        stream: _marketRepository.streamAll(),
        builder: (context, snapshot) {
          return SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final market = snapshot.data!.elementAt(index);
                return MarketCard(
                  market: market,
                  onTap: () {
                    _editMarket(market);
                  },
                  onPlay: () {},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),
          );
        },
      ),
    );
  }

  void _addMarket() async {
    try {
      Market? market =
          await Get.to(MarketForm(onDelete: _marketRepository.delete));
      if (market != null) {
        await _marketRepository.create(market);
      }
    } catch (e) {
      Get.snackbar(
          "Error", "An error occurred while adding market. Please try again.");
    }
  }

  void _editMarket(Market market) async {
    try {
      Market? result = await Get.to(MarketForm(
        market: market,
        onDelete: _marketRepository.delete,
      ));
      if (result != null) {
        await _marketRepository.update(result);
      }
    } catch (e) {
      Get.snackbar(
          "Error", "An error occurred while editing market. Please try again.");
    }
  }
}
