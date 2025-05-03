import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/screens/home/presentation/widgets/home_button.dart';
import 'package:matka_game_app/screens/home/presentation/widgets/market_card.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/utils/user_role.dart';
import 'package:matka_game_app/widgets/active_user_check.dart';
import 'package:matka_game_app/widgets/balance_widget.dart';
import 'package:matka_game_app/widgets/drawer/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.userService, {super.key});

  final UserService userService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ActiveUserCheck(
      child: Obx(() {
        return Scaffold(
          backgroundColor: const Color(0xff530b47),
          key: _scaffoldKey,
          appBar: AppBar(
            actions: [
              BalanceWidget(userId: widget.userService.currentUserId),
            ],
            title: const Text('AK Online'),
            leading: IconButton(
              icon: const Icon(CupertinoIcons.bars),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: AppDrawer(
            role: widget.userService.userData.value?.role ?? UserRole.user,
            mode: widget.userService.mode.value,
            onSwitchMode: widget.userService.switchMode,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            children: [
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 100 / 50,
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xff770e66),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xfffcdfa1),
                      width: 2,
                    ),
                    gradient: const RadialGradient(
                      center: Alignment.center,
                      radius: 1,
                      colors: [
                        Color(0xffcb1964),
                        Color(0xffab1865),
                        Color(0xff770e66),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GridView.count(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 100 / 30,
                crossAxisSpacing: width * 0.035,
                mainAxisSpacing: width * 0.03,
                children: [
                  HomeButton(
                    text: 'Whatsapp',
                    icon: Image.asset('assets/images/whatsapp.png'),
                    onPressed: () {},
                  ),
                  HomeButton(
                    text: 'Add Money',
                    icon: Image.asset('assets/images/plus_coin.png'),
                    onPressed: () {},
                  ),
                  HomeButton(
                    text: 'Withdraw',
                    icon: Image.asset('assets/images/minus_coin.png'),
                    onPressed: () {},
                  ),
                  HomeButton(
                    text: 'How to play',
                    onPressed: () {},
                    icon: const Icon(
                      CupertinoIcons.info_circle_fill,
                      size: 28,
                      color: Color(0xfffce8b2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FirestoreListView<Map<String, dynamic>>(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                query: FirebaseFirestore.instance.collection('markets'),
                itemBuilder: (context, snapshot) {
                  final market = Market.fromDoc(snapshot);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 18),
                    child: MarketCard(
                      market: market,
                      onPlay: () {
                        // TODO: Implement play functionality
                      },
                      onTap: () {
                        // TODO: Implement market details navigation
                      },
                    ),
                  );
                },
                loadingBuilder: (context) => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFecd7b4),
                  ),
                ),
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Text(
                    'Error loading markets: $error',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                emptyBuilder: (context) => const Center(
                  child: Text(
                    'No markets available',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
