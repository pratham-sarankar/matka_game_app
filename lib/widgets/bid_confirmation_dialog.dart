import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/bid.dart';
import 'package:matka_game_app/models/market.dart';

class BidConfirmationDialog extends StatelessWidget {
  final Market market;
  final Bid bid;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const BidConfirmationDialog({
    super.key,
    required this.market,
    required this.bid,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirm Bid',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please confirm your bid details:',
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          _buildConfirmationRow('Market', market.name),
          _buildConfirmationRow('Game Type', bid.gameType),
          _buildConfirmationRow(
            'Digit',
            bid.gameType == 'Jodi Digit'
                ? bid.digit.padLeft(2, '0')
                : bid.digit,
          ),
          _buildConfirmationRow('Amount', '₹${bid.amount}'),
          _buildConfirmationRow('Session', bid.session.toUpperCase()),
          const SizedBox(height: 8),
          Text(
            'This action will deduct ₹${bid.amount} from your wallet and cannot be undone.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Confirm Bid',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
