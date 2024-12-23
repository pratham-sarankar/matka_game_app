import 'package:get/get.dart';
import 'package:matka_game_app/screens/change_password/presentation/screens/change_password_screen.dart';
import 'package:matka_game_app/screens/home/presentation/screens/home_screen.dart';
import 'package:matka_game_app/screens/login/presentation/screens/login_screen.dart';
import 'package:matka_game_app/screens/markets/market_screen.dart';
import 'package:matka_game_app/navigation/routes.dart';
import 'package:matka_game_app/screens/my_profile/presentation/screens/my_profile_screen.dart';
import 'package:matka_game_app/screens/my_wallet/my_wallet_screen.dart';
import 'package:matka_game_app/screens/user_wallets/user_wallets.dart';
import 'package:matka_game_app/screens/users/users_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.home,
      page: () => HomeScreen(Get.find(), Get.find()),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.markets,
      page: () => const MarketScreen(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => ChangePasswordScreen(Get.find()),
    ),
    GetPage(
      name: Routes.myProfile,
      page: () => MyProfileScreen(Get.find()),
    ),
    GetPage(
      name: Routes.myWallet,
      page: () => MyWalletScreen(Get.find()),
    ),
    GetPage(
      name: Routes.users,
      page: () => UsersScreen(Get.find()),
    ),
    GetPage(
      name: Routes.userWallets,
      page: () => const UserWallets(),
    ),
  ];
}
