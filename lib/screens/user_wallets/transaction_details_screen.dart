import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final WalletTransaction transaction;

  const TransactionDetailsScreen({
    super.key,
    required this.transaction,
  });

  Future<void> _updateTransactionStatus(
    BuildContext context,
    WalletTransaction transaction,
    WalletTransactionStatus newStatus,
  ) async {
    try {
      final batch = FirebaseFirestore.instance.batch();

      // Update transaction status
      final transactionRef = FirebaseFirestore.instance
          .collection('wallet_transactions')
          .doc(transaction.id);
      batch.update(transactionRef, {
        'status': newStatus.name,
        'respondedAt': Timestamp.now(),
      });

      // If approved, update user's wallet balance
      if (newStatus == WalletTransactionStatus.approved) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(transaction.userID);

        final userDoc = await userRef.get();
        final currentBalance = userDoc.data()?['balance'] ?? 0.0;

        double newBalance = currentBalance;
        if (transaction.type == WalletTransactionType.deposit) {
          newBalance += transaction.amount;
        } else if (transaction.type == WalletTransactionType.withdrawal) {
          newBalance -= transaction.amount;
        }

        batch.update(userRef, {'balance': newBalance});
      }

      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Transaction ${newStatus.name.toLowerCase()} successfully'),
            backgroundColor: newStatus == WalletTransactionStatus.approved
                ? Colors.green
                : Colors.red,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaction Details',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: transaction.type == WalletTransactionType.deposit
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    transaction.type == WalletTransactionType.deposit
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: transaction.type == WalletTransactionType.deposit
                        ? Colors.green
                        : Colors.red,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${transaction.type.symbol} ₹${transaction.amount}",
                          style: GoogleFonts.poppins(
                            color: transaction.type ==
                                    WalletTransactionType.deposit
                                ? Colors.green
                                : Colors.red,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                transaction.status.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            transaction.status.name,
                            style: GoogleFonts.poppins(
                              color: transaction.status.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Type', transaction.type.name),
            _buildDetailRow('Note', transaction.note),
            if (transaction.mediaURL != null) ...[
              const SizedBox(height: 24),
              Text(
                'Payment Proof',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  transaction.mediaURL!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            if (transaction.status == WalletTransactionStatus.pending) ...[
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _updateTransactionStatus(
                          context,
                          transaction,
                          WalletTransactionStatus.rejected,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Reject',
                        style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _updateTransactionStatus(
                          context,
                          transaction,
                          WalletTransactionStatus.approved,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Approve',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
