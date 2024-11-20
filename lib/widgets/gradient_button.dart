import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
    this.contentPadding,
  });
  final Widget child;
  final EdgeInsets? contentPadding;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      onTapDown: (details) {
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (details) {
        setState(() {
          isPressed = false;
        });
      },
      child: AnimatedContainer(
        padding: widget.contentPadding ??
            const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          color: Colors.grey.shade400,
          gradient: widget.onTap == null
              ? null
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    if (!isPressed)
                      const Color(0xffcb1964)
                    else
                      const Color(0xff770e66),
                    if (!isPressed)
                      const Color(0xffab1865)
                    else
                      const Color(0xff770e66),
                    const Color(0xff770e66),
                  ],
                ),
        ),
        child: Opacity(
          opacity: widget.onTap == null ? 0.7 : 1,
          child: widget.child,
        ),
      ),
    );
  }
}
