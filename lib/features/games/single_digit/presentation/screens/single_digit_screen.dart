import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class SingleDigitScreen extends StatefulWidget {
  const SingleDigitScreen({super.key});

  @override
  State<SingleDigitScreen> createState() => _SingleDigitScreenState();
}

class _SingleDigitScreenState extends State<SingleDigitScreen> {
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
        title: const Text("Milan Day"),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 25,
        ),
        children: [
          const Center(
            child: Text(
              "MILAN DAY",
              style: TextStyle(
                color: Color(0xffcf1a65),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Text(
            "Date",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              hintText: DateFormat("dd-mm-yyyy").format(DateTime.now()),
              hintStyle: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
              ),
              contentPadding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff530b47),
                ),
                child: const Icon(
                  CupertinoIcons.calendar,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Choose Session",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              Radio(
                value: 'open',
                groupValue: 'open',
                onChanged: (value) {},
                activeColor: const Color(0xff530b47),
              ),
              const Text("Open"),
              Radio(
                value: 'close',
                groupValue: 'open',
                onChanged: (value) {},
                activeColor: const Color(0xff530b47),
              ),
              const Text("close"),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Bid Digit",
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade800,
                fontSize: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            decoration: InputDecoration(
              hintText: "Enter Bid Points",
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade800,
                fontSize: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GradientButton(
              child: const Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
