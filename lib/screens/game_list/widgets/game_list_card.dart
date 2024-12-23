import 'package:flutter/material.dart';

class GameListCard extends StatefulWidget {
  const GameListCard({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final String text;
  final Widget icon;
  final VoidCallback onTap;
  @override
  State<GameListCard> createState() => _GameListCardState();
}

class _GameListCardState extends State<GameListCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff770e66),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xfffcdfa1),
            width: 1,
          ),
          gradient: const RadialGradient(
            center: Alignment.center,
            radius: 0.5,
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
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: constraints.maxWidth * 0.45,
                child: AspectRatio(
                  aspectRatio: 100 / 110,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffeecf87),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: widget.icon,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
