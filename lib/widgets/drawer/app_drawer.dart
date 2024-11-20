import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/core/utils/user_role.dart';
import 'package:matka_game_app/features/change_password/presentation/screens/change_password_screen.dart';
import 'package:matka_game_app/features/game_rates/presentation/screens/game_rates_screen.dart';
import 'package:matka_game_app/features/login/presentation/screens/login_screen.dart';
import 'package:matka_game_app/features/markets/presentation/screens/market_screen.dart';
import 'package:matka_game_app/features/my_profile/presentation/screens/my_profile_screen.dart';
import 'package:matka_game_app/features/notice_board/presentation/screens/notice_board_screen.dart';
import 'package:matka_game_app/features/notification/presentation/screens/notification_screen.dart';
import 'package:matka_game_app/features/win_history/presentation/screens/win_history_screen.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/drawer/drawer_tile.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      final UserService userService = Get.find();
      final UserRole role = userService.role.value;
      final isAdminMode = userService.adminMode.value;
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                //add linear gradient
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
              margin: const EdgeInsets.only(
                bottom: 5,
              ),
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
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAdminMode ? "Admin" : "User",
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
                  )
                ],
              ),
            ),
            if (role == UserRole.admin)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: () {
                    userService.setAdminMode(!isAdminMode);
                  },
                  child:
                      Text("Switch to ${isAdminMode ? "User" : "Admin"} Mode"),
                ),
              ),
            if (!isAdminMode) ...[
              DrawerTile(
                text: "Home",
                icon: CupertinoIcons.home,
                onTap: () {},
              ),
              DrawerTile(
                text: "My Profile",
                icon: CupertinoIcons.person_fill,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const MyProfileScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Bid History",
                icon: CupertinoIcons.calendar,
                onTap: () {},
              ),
              DrawerTile(
                text: "Transaction History",
                icon: CupertinoIcons.calendar,
                onTap: () {},
              ),
              DrawerTile(
                text: "Win History",
                icon: CupertinoIcons.calendar,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const WinHistoryScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Notification",
                icon: CupertinoIcons.bell,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const NotificationScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Game Rates",
                icon: CupertinoIcons.exclamationmark_circle,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const GameRatesScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Notice Board/Rules",
                icon: Icons.rule,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const NoticeBoardScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Change Password",
                icon: CupertinoIcons.lock_fill,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) {
                        return const ChangePasswordScreen();
                      },
                    ),
                  );
                },
              ),
              DrawerTile(
                text: "Log Out",
                icon: Icons.exit_to_app,
                onTap: showSignOutConfirmationDialog,
              ),
            ] else ...[
              DrawerTile(
                text: "Markets",
                icon: Icons.shopify,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return const MarketScreen();
                      },
                    ),
                  );
                },
              ),
            ]
          ],
        ),
      );
    });
  }

  void showSignOutConfirmationDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                signOut();
              },
              child: const Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    while (Navigator.canPop(Get.context!)) {
      Navigator.pop(Get.context!);
    }
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }
}
