import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matka_game_app/features/notification/presentation/widgets/notification_tile.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          NotificationTile(
            text: """
PAYMENT NUMBER 
Phone pe

7499984789

G pay
9168583136

Sidha payment karke screen whats app kardo add ho jayenga points

March 7, 2024 12:43 AM
          """,
          ),
          const SizedBox(height: 15),
          NotificationTile(text: """
          Let’s Play
Paly big Win big 
December 4 , 2023 3:15 PM
          """)
        ],
      ),
    );
  }
}
