import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/screens/game_list/widgets/game_list_card.dart';
import 'package:matka_game_app/screens/games/jodi_digit/presentation/screens/jodi_digit_screen.dart';
import 'package:matka_game_app/screens/games/single_digit/presentation/screens/single_digit_screen.dart';
import 'package:matka_game_app/screens/games/single_panna/presentation/screens/single_panna_screen.dart';
import 'package:matka_game_app/screens/games/double_panna/presentation/screens/double_panna_screen.dart';
import 'package:matka_game_app/screens/games/triple_panna/presentation/screens/triple_panna_screen.dart';
import 'package:matka_game_app/screens/games/half_sangam/presentation/screens/half_sangam_screen.dart';
import 'package:matka_game_app/screens/games/full_sangam/presentation/screens/full_sangam_screen.dart';
import 'package:matka_game_app/screens/games/family_jodi/presentation/screens/family_jodi_screen.dart';
import 'package:matka_game_app/screens/games/family_panel/presentation/screens/family_panel_screen.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:matka_game_app/widgets/balance_widget.dart';

class GameListScreen extends StatefulWidget {
  final Market market;
  final UserService userService;

  const GameListScreen({
    super.key,
    required this.market,
    required this.userService,
  });

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  bool get _isMarketOpen {
    return widget.market.isOpen && widget.market.canPlaceBid;
  }

  void _showMarketClosedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Market Closed',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This market is currently closed. Please try again during market hours.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToGame(String gameType) {
    if (!_isMarketOpen) {
      _showMarketClosedDialog();
      return;
    }

    switch (gameType) {
      case 'Single Digit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleDigitScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Jodi Digit':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JodiDigitScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Single Panna':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinglePannaScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Double Panna':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoublePannaScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Triple Panna':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TriplePannaScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Half Sangam':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalfSangamScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Full Sangam':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullSangamScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Family Jodi':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FamilyJodiScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
      case 'Family Panel':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FamilyPanelScreen(
              market: widget.market,
              userService: widget.userService,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.market.name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BalanceWidget(userId: widget.userService.currentUserId),
        ],
      ),
      body: Column(
        children: [
          if (!_isMarketOpen)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.red.withOpacity(0.1),
              child: Center(
                child: Text(
                  'Market Closed',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
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
                    onTap: () => _navigateToGame('Single Digit'),
                    icon: Icon(
                      CupertinoIcons.number_circle_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    text: "Jodi Digit",
                    onTap: () => _navigateToGame('Jodi Digit'),
                    icon: Icon(
                      CupertinoIcons.number_circle_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Single Panna'),
                    text: "Single Panna",
                    icon: Icon(
                      CupertinoIcons.number_square_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Double Panna'),
                    text: "Double Panna",
                    icon: Icon(
                      CupertinoIcons.number_square_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Triple Panna'),
                    text: "Triple Panna",
                    icon: Icon(
                      CupertinoIcons.number_square_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Half Sangam'),
                    text: "Half Sangam",
                    icon: Icon(
                      CupertinoIcons.circle_lefthalf_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Full Sangam'),
                    text: "Full Sangam",
                    icon: Icon(
                      CupertinoIcons.circle_grid_3x3_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Family Jodi'),
                    text: "Family Jodi",
                    icon: Icon(
                      CupertinoIcons.person_2_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                  GameListCard(
                    onTap: () => _navigateToGame('Family Panel'),
                    text: "Family Panel",
                    icon: Icon(
                      CupertinoIcons.person_3_fill,
                      size: constraints.maxHeight * 0.08,
                      color: const Color(0xff530b47),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
