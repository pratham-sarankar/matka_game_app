import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/repositories/wallet_repository.dart';
import 'package:matka_game_app/screens/my_wallet/widgets/my_wallet_filter_dialog.dart';
import 'package:matka_game_app/screens/user_wallets/transaction_details_screen.dart';

class UserWallets extends StatefulWidget {
  const UserWallets({super.key});

  @override
  State<UserWallets> createState() => _UserWalletsState();
}

class _UserWalletsState extends State<UserWallets> {
  final WalletRepository _walletRepository = WalletRepository();
  double? minAmount;
  double? maxAmount;
  DateTime? fromDate;
  DateTime? toDate;
  WalletTransactionType? selectedType;
  WalletTransactionStatus? selectedStatus;

  Future<void> _updateTransactionStatus(
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Transaction ${newStatus.name.toLowerCase()} successfully'),
            backgroundColor: newStatus == WalletTransactionStatus.approved
                ? Colors.green
                : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Wallets",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => MyWalletFilterDialog(
                  initialMinAmount: minAmount,
                  initialMaxAmount: maxAmount,
                  initialFromDate: fromDate,
                  initialToDate: toDate,
                  initialType: selectedType,
                  initialStatus: selectedStatus,
                  onReset: () {
                    setState(() {
                      minAmount = null;
                      maxAmount = null;
                      fromDate = null;
                      toDate = null;
                      selectedType = null;
                      selectedStatus = null;
                    });
                  },
                  onApply: ({
                    double? minAmount,
                    double? maxAmount,
                    DateTime? fromDate,
                    DateTime? toDate,
                    WalletTransactionType? type,
                    WalletTransactionStatus? status,
                  }) {
                    setState(() {
                      this.minAmount = minAmount;
                      this.maxAmount = maxAmount;
                      this.fromDate = fromDate;
                      this.toDate = toDate;
                      selectedType = type;
                      selectedStatus = status;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: FirestoreListView<Map<String, dynamic>>(
          query: _walletRepository.query(
            minAmount: minAmount,
            maxAmount: maxAmount,
            fromDate: fromDate,
            toDate: toDate,
            selectedType: selectedType,
            selectedStatus: selectedStatus,
          ),
          itemBuilder: (context, snapshot) {
            final transaction = WalletTransaction.fromDoc(snapshot);
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: transaction.status == WalletTransactionStatus.rejected
                  ? 0
                  : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionDetailsScreen(
                        transaction: transaction,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        transaction.status == WalletTransactionStatus.rejected
                            ? Colors.grey.shade200
                            : Colors.white,
                        transaction.status == WalletTransactionStatus.rejected
                            ? Colors.grey.shade300
                            : Colors.grey.shade50,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: transaction.type ==
                                      WalletTransactionType.deposit
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              transaction.type == WalletTransactionType.deposit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction.type ==
                                      WalletTransactionType.deposit
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${transaction.type.symbol} ₹${transaction.amount}",
                                  style: TextStyle(
                                    color: transaction.type ==
                                            WalletTransactionType.deposit
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transaction.note,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: transaction.status.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              transaction.status.name,
                              style: TextStyle(
                                color: transaction.status.color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (transaction.mediaURL != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            transaction.mediaURL!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
          loadingBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text('Error: ${error.toString()}'),
          ),
          emptyBuilder: (context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty-wallet.png',
                    height: 200,
                    opacity: const AlwaysStoppedAnimation(0.8),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Transactions Found',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
