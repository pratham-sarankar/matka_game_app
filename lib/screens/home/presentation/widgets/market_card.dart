import 'package:flutter/material.dart';
import 'package:matka_game_app/models/market.dart';

class MarketCard extends StatefulWidget {
  const MarketCard({
    super.key,
    required this.market,
    required this.onPlay,
    this.onTap,
  });

  final Market market;
  final VoidCallback? onTap;
  final VoidCallback onPlay;

  @override
  State<MarketCard> createState() => _MarketCardState();
}

class _MarketCardState extends State<MarketCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xfffcdfa1),
            width: 1.5,
          ),
        ),
        borderOnForeground: true,
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        shadowColor: const Color(0xffc6a179),
        child: Column(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.1,
              decoration: const BoxDecoration(
                color: Color(0xff770e66),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffcb1964),
                    Color(0xffab1865),
                    Color(0xff770e66),
                  ],
                ),
              ),
              padding: const EdgeInsets.only(
                top: 14,
                bottom: 14,
                right: 14,
                left: 5,
              ),
              child: Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                    left: 6,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/growth.png',
                      height: size.height * 0.08,
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          widget.market.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.022,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          '168-54-130',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.020,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.market.isOpen)
                          ElevatedButton(
                            onPressed: widget.onPlay,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              backgroundColor: const Color(0xff258435),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text("Play Now"),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Closed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
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
              decoration: const BoxDecoration(
                color: Color(0xffc6a179),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Open: ${widget.market.openTime.format(context)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.market.isOpen ? 'RUNNING' : 'CLOSED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Close: ${widget.market.closeTime.format(context)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
