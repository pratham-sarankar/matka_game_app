import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matka_game_app/models/bid.dart';
import 'package:matka_game_app/repositories/bid_repository.dart';
import 'package:matka_game_app/services/user_service.dart';

class BidHistoryScreen extends StatelessWidget {
  final UserService userService;
  final _bidRepository = BidRepository();

  BidHistoryScreen({
    super.key,
    required this.userService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bid History",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.arrow_left,
            size: 25,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FirestoreListView<Bid>(
        query: _bidRepository.getUserBidsQuery(userService.currentUserId),
        itemBuilder: (context, snapshot) {
          final bid = snapshot.data();
          return BidCard(bid: bid);
        },
        emptyBuilder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.doc_text_search,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No bids found",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Center(
          child: Text(
            'Error: $error',
            style: GoogleFonts.poppins(
              color: Colors.red,
            ),
          ),
        ),
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class BidCard extends StatelessWidget {
  final Bid bid;

  const BidCard({
    super.key,
    required this.bid,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFcd1b65),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          bid.gameType,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          dateFormat.format(bid.timestamp),
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(bid.status),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: _buildInfoBox(
                      "Digit",
                      bid.digit,
                      const Color(0xFFcd1b65),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildInfoBox(
                      "Amount",
                      "₹${bid.amount}",
                      const Color(0xFFcd1b65),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    CupertinoIcons.clock,
                    timeFormat.format(bid.timestamp),
                  ),
                  Container(
                    height: 18,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),
                  _buildInfoItem(
                    CupertinoIcons.time,
                    bid.session.toUpperCase(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey.shade700,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BidStatus status) {
    Color color;
    IconData icon;
    switch (status) {
      case BidStatus.pending:
        color = Colors.orange;
        icon = CupertinoIcons.clock;
        break;
      case BidStatus.won:
        color = Colors.green;
        icon = CupertinoIcons.checkmark_circle;
        break;
      case BidStatus.lost:
        color = Colors.red;
        icon = CupertinoIcons.xmark_circle;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 5),
          Text(
            status.name,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
