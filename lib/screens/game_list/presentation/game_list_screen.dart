import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matka_game_app/screens/game_list/widgets/game_list_card.dart';
import 'package:matka_game_app/screens/games/single_digit/presentation/screens/single_digit_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milan Day"),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: const Color(0xff29031c),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xfffcdfa1),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 5,
                ),
                child: const Text(
                  "50.00",
                  style: TextStyle(
                    color: Color(0xFFecd7b4),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Positioned(
                top: -5,
                bottom: -5,
                left: -18,
                child: Image.asset(
                  "assets/images/coin.png",
                ),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return GridView.count(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.05,
            vertical: 10,
          ),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1,
          crossAxisSpacing: width * 0.035,
          mainAxisSpacing: width * 0.03,
          children: [
            GameListCard(
              text: "Single Digit",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const SingleDigitScreen();
                  },
                ));
              },
              icon: Center(
                child: Text(
                  '👆🏻',
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.05,
                  ),
                ),
              ),
            ),
            GameListCard(
              text: "Jodi Digit",
              onTap: () {},
              icon: Center(
                child: Text(
                  '✌🏻',
                  style: TextStyle(
                    fontSize: constraints.maxHeight * 0.05,
                  ),
                ),
              ),
            ),
            GameListCard(
              onTap: () {},
              text: "Single Panna",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Double Panna",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Tripple Panna",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Half Sangam",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Full Sangam",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Family Jodi",
              icon: Container(),
            ),
            GameListCard(
              onTap: () {},
              text: "Family Panel",
              icon: Container(),
            ),
          ],
        );
      }),
    );
  }
}
