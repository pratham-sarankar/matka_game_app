import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  final String userId;
  const BalanceWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            width: 50,
            height: 30,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFecd7b4),
              ),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final balance = data?['balance']?.toString() ?? '0';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: const Color(0xff29031c),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xfffcdfa1),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 5,
              ),
              child: Text(
                "₹ $balance",
                style: const TextStyle(
                  color: Color(0xFFecd7b4),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            Positioned(
              top: -5,
              bottom: -5,
              left: -18,
              child: Image.asset(
                "assets/images/coin.png",
              ),
            ),
          ],
        );
      },
    );
  }
}
