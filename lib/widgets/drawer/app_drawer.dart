import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/screens/auth/login_screen.dart';
import 'package:matka_game_app/utils/user_role.dart';
import 'package:matka_game_app/screens/game_rates/presentation/screens/game_rates_screen.dart';
import 'package:matka_game_app/screens/notice_board/presentation/screens/notice_board_screen.dart';
import 'package:matka_game_app/screens/notification/presentation/screens/notification_screen.dart';
import 'package:matka_game_app/screens/win_history/presentation/screens/win_history_screen.dart';
import 'package:matka_game_app/navigation/routes.dart';
import 'package:matka_game_app/widgets/drawer/drawer_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.role,
    required this.mode,
    required this.onSwitchMode,
  });

  final UserType role;
  final UserType mode;
  final VoidCallback onSwitchMode;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFcd1b65),
                  Color(0xFFab1666),
                  Color(0xFF7c1067),
                ],
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: width * 0.025,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: width * 0.08,
                  backgroundColor: const Color(0xFF520a46),
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.white,
                    size: width * 0.08,
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mode.isAdmin ? "Admin" : "User",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          FirebaseAuth.instance.currentUser?.email ?? "",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (role.isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: onSwitchMode,
                child:
                    Text("Switch to ${mode.isAdmin ? "User" : "Admin"} Mode"),
              ),
            ),
          if (mode.isAdmin) ...[
            DrawerTile(
              text: "Markets",
              icon: Icons.shopify,
              onTap: () {
                Get.toNamed(Routes.markets);
              },
            ),
            DrawerTile(
              text: "Users",
              icon: Icons.person,
              onTap: () {
                Get.toNamed(Routes.users);
              },
            ),
            DrawerTile(
              text: "User Wallets",
              icon: Icons.person,
              onTap: () {
                Get.toNamed(Routes.userWallets);
              },
            ),
          ] else ...[
            DrawerTile(
              text: "Home",
              icon: CupertinoIcons.home,
              onTap: () {},
            ),
            DrawerTile(
              text: "My Profile",
              icon: CupertinoIcons.person_fill,
              onTap: () {
                Get.toNamed(Routes.myProfile);
              },
            ),
            DrawerTile(
              text: "My Wallet",
              icon: CupertinoIcons.calendar,
              onTap: () {
                Get.toNamed(Routes.myWallet);
              },
            ),
            DrawerTile(
              text: "Bid History",
              icon: CupertinoIcons.calendar,
              onTap: () {},
            ),
            DrawerTile(
              text: "Win History",
              icon: CupertinoIcons.calendar,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const WinHistoryScreen()),
                );
              },
            ),
            DrawerTile(
              text: "Notification",
              icon: CupertinoIcons.bell,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
            ),
            DrawerTile(
              text: "Game Rates",
              icon: CupertinoIcons.exclamationmark_circle,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const GameRatesScreen()),
                );
              },
            ),
            DrawerTile(
              text: "Notice Board/Rules",
              icon: Icons.rule,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const NoticeBoardScreen()),
                );
              },
            ),
            DrawerTile(
              text: "Change Password",
              icon: CupertinoIcons.lock_fill,
              onTap: () {
                Get.toNamed(Routes.changePassword);
              },
            ),
            DrawerTile(
              text: "Log Out",
              icon: Icons.exit_to_app,
              onTap: showSignOutConfirmationDialog,
            ),
          ],
        ],
      ),
    );
  }

  void showSignOutConfirmationDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              signOut();
            },
            child: const Text("Sign Out"),
          ),
        ],
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    while (Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
    }
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }
}
