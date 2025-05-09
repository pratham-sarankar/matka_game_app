import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/repositories/user_repository.dart';
import 'package:matka_game_app/services/user_service.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final WalletTransaction transaction;
  final UserRepository _userRepository = Get.find<UserRepository>();
  final _dateFormat = DateFormat('MMM dd, yyyy hh:mm a');

  TransactionDetailsScreen({
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

  Future<void> _showConfirmationDialog(
    BuildContext context,
    WalletTransaction transaction,
    WalletTransactionStatus newStatus,
  ) {
    final isApproving = newStatus == WalletTransactionStatus.approved;
    final amount = transaction.amount;
    final type = transaction.type.name;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              isApproving ? Icons.check_circle : Icons.cancel,
              color: isApproving ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isApproving ? 'Confirm Approval' : 'Confirm Rejection',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isApproving
                  ? 'Are you sure you want to approve this transaction?'
                  : 'Are you sure you want to reject this transaction?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    (isApproving ? Colors.green : Colors.red).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Details:',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Amount: ₹$amount',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    'Type: $type',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _updateTransactionStatus(context, transaction, newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApproving ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isApproving ? 'Approve' : 'Reject',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _copyBankDetails(
      BuildContext context, BankDetails details) async {
    final formattedText = '''Bank Name: ${details.bankName}
Account Number: ${details.accountNumber}
IFSC Code: ${details.ifscCode}
Account Holder: ${details.accountHolderName}''';

    await Clipboard.setData(ClipboardData(text: formattedText));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank details copied to clipboard'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _copyUpiId(BuildContext context, String upiId) async {
    await Clipboard.setData(ClipboardData(text: upiId));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('UPI ID copied to clipboard'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: transaction.type == WalletTransactionType.deposit
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
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
                                color: transaction.status.color
                                    .withValues(alpha: 0.1),
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
                Text(
                  'User Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: FutureBuilder(
                    future: _userRepository.getUserByUid(transaction.userID),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final user = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Name', user.fullName),
                          _buildDetailRow('Phone', user.phoneNumber),
                          _buildDetailRow('Email', user.email),
                          _buildDetailRow(
                            'Balance',
                            '₹${user.balance.toString()}',
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Payment Details',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (user.bankDetails.accountNumber.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.blue.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_balance,
                                            color: Colors.blue.shade700,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Bank Details',
                                            style: GoogleFonts.poppins(
                                              color: Colors.blue.shade700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy, size: 20),
                                        onPressed: () => _copyBankDetails(
                                            context, user.bankDetails),
                                        tooltip: 'Copy all bank details',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: Colors.blue.shade700,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                      'Bank Name', user.bankDetails.bankName),
                                  _buildDetailRow('Account Number',
                                      user.bankDetails.accountNumber),
                                  _buildDetailRow(
                                      'IFSC Code', user.bankDetails.ifscCode),
                                  _buildDetailRow('Account Holder',
                                      user.bankDetails.accountHolderName),
                                ],
                              ),
                            ),
                          ],
                          if (user.upiId.isNotEmpty) ...[
                            if (user.bankDetails.accountNumber.isNotEmpty)
                              const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone_android,
                                            color: Colors.green.shade700,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'UPI Details',
                                            style: GoogleFonts.poppins(
                                              color: Colors.green.shade700,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy, size: 20),
                                        onPressed: () =>
                                            _copyUpiId(context, user.upiId),
                                        tooltip: 'Copy UPI ID',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        color: Colors.green.shade700,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow('UPI ID', user.upiId),
                                ],
                              ),
                            ),
                          ],
                          if (user.bankDetails.accountNumber.isEmpty &&
                              user.upiId.isEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange.shade700,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'No payment details available',
                                      style: GoogleFonts.poppins(
                                        color: Colors.orange.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Transaction Details',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Type', transaction.type.name),
                      _buildDetailRow('Note', transaction.note),
                      if (transaction.requestedAt != null)
                        _buildDetailRow(
                          'Requested At',
                          _dateFormat.format(transaction.requestedAt!.toDate()),
                        ),
                      if (transaction.respondedAt != null)
                        _buildDetailRow(
                          'Responded At',
                          _dateFormat.format(transaction.respondedAt!.toDate()),
                        ),
                    ],
                  ),
                ),
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
                if (transaction.status == WalletTransactionStatus.pending)
                  const SizedBox(height: 100),
              ],
            ),
          ),
          if (transaction.status == WalletTransactionStatus.pending)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            transaction,
                            WalletTransactionStatus.rejected,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.red),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.close, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Reject',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            transaction,
                            WalletTransactionStatus.approved,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Approve',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
