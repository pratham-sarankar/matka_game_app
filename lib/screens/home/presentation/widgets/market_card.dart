import 'package:flutter/material.dart';
import 'package:matka_game_app/models/market.dart';
import 'package:matka_game_app/screens/game_list/presentation/game_list_screen.dart';
import 'package:matka_game_app/services/user_service.dart';

class MarketCard extends StatefulWidget {
  const MarketCard({
    super.key,
    required this.market,
    required this.userService,
    this.onTap,
  });

  final Market market;
  final UserService userService;
  final VoidCallback? onTap;

  @override
  State<MarketCard> createState() => _MarketCardState();
}

class _MarketCardState extends State<MarketCard> {
  void _navigateToGameList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameListScreen(
          market: widget.market,
          userService: widget.userService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xfffcdfa1),
            width: 1.5,
          ),
        ),
        borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        elevation: 8,
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.1,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffcb1964),
                    Color(0xffab1865),
                    Color(0xff770e66),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffcb1964).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                    left: 5,
                    top: 5,
                    bottom: 5,
                    child: Image.asset(
                      'assets/images/growth.png',
                    ),
                  ),
                  Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.market.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.bold,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '168-54-130',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: size.height * 0.020,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    bottom: 5,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.market.isOpen)
                          ElevatedButton(
                            onPressed: _navigateToGameList,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                              backgroundColor: const Color(0xff258435),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor:
                                  const Color(0xff258435).withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            child: const Text("Play Now"),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              'Closed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: size.width,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: const Color(0xffc6a179),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffc6a179).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeInfo(
                    'Open: ${widget.market.openTime.format(context)}',
                    size,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: widget.market.isOpen
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.market.isOpen
                            ? Colors.green.withOpacity(0.5)
                            : Colors.red.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.market.isOpen ? 'RUNNING' : 'CLOSED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildTimeInfo(
                    'Close: ${widget.market.closeTime.format(context)}',
                    size,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String text, Size size) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: size.height * 0.015,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
