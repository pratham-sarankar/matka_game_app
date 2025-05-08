import 'package:flutter/material.dart';

class HomeButton extends StatefulWidget {
  const HomeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  State<HomeButton> createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
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
            radius: 1.5,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.icon,
            const SizedBox(width: 10),
            Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                // fontSize: 1,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
