import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/screens/home/presentation/widgets/home_button.dart';
import 'package:matka_game_app/screens/home/presentation/widgets/market_card.dart';
import 'package:matka_game_app/services/auth_service.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/drawer/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.authService, this.userService, {super.key});

  final AuthService authService;
  final UserService userService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xff530b47),
        key: _scaffoldKey,
        appBar: AppBar(
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
                  child: StreamBuilder<UserData>(
                    stream: _liveBalance(),
                    builder: (context, snapshot) {
                      return Text(
                        '${snapshot.data?.balance ?? 0}',
                        style: const TextStyle(
                          color: Color(0xFFecd7b4),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      );
                    },
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
          title: const Text('AK Online'),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.bars),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: AppDrawer(
          role: widget.userService.userData.value.role,
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
            const SizedBox(
              height: 20,
            ),
            MarketCard(
              market: Market.empty(),
              onPlay: () {},
              onTap: () {},
            ),
            const SizedBox(height: 18),
            MarketCard(
              market: Market.empty(),
              onPlay: () {},
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }

  Stream<UserData> _liveBalance() {
    final user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map(
      (event) {
        return UserData.fromJson(event.data()!);
      },
    );
  }
}
