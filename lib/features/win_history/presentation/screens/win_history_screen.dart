import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/widgets/gradient_button.dart';

class WinHistoryScreen extends StatefulWidget {
  const WinHistoryScreen({super.key});

  @override
  State<WinHistoryScreen> createState() => _WinHistoryScreenState();
}

class _WinHistoryScreenState extends State<WinHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Win History"),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
            top: 20,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Start Date",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.calendar),
                              const SizedBox(width: 15),
                              Text(
                                "17-08-2024",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "End Date",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.calendar),
                              const SizedBox(width: 15),
                              Text(
                                "17-08-2024",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              GradientButton(
                onTap: () {},
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text("No Data Found"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientButton(
                    onTap: () {},
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.chevron_left_2,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text("0/0"),
                  GradientButton(
                    onTap: null,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    child: const Row(
                      children: [
                        Icon(
                          CupertinoIcons.chevron_right_2,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
