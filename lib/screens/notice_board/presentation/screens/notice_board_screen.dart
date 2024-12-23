import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({super.key});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Notice Board/Rules"),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 40,
        ),
        children: [
          for (int i = 0; i < 5; i++)
            Container(
              height: 100,
              margin: const EdgeInsets.only(
                bottom: 15,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffcf1a65),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment:
                  i % 2 == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xfff2f1ec),
                      // color: Color(0xffcf1a65),
                    ),
                    child: Text(
                      (i + 1).toString().padLeft(2, '0'),
                      style: GoogleFonts.poppins(
                        color: const Color(0xff520a46),
                        fontSize: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
