import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/repositories/wallet_repository.dart';
import 'package:matka_game_app/screens/my_wallet/transaction_form.dart';
import 'package:matka_game_app/screens/my_wallet/widgets/my_wallet_card.dart';
import 'package:matka_game_app/screens/my_wallet/widgets/my_wallet_filter_dialog.dart';
import 'package:matka_game_app/services/user_service.dart';
import '../../models/wallet_transaction.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen(this.userService, {super.key});

  final UserService userService;

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  final WalletRepository _walletRepository = WalletRepository();
  double? minAmount;
  double? maxAmount;
  DateTime? fromDate;
  DateTime? toDate;
  WalletTransactionType? selectedType;
  WalletTransactionStatus? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const TransactionForm());
        },
        label: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(width: 5),
            Text("Add Request"),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
            return MyWalletCard(
              transaction: transaction,
              onDelete: transaction.status == WalletTransactionStatus.pending
                  ? () => _deleteTransaction(transaction)
                  : null,
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
                  const Text(
                    'No Transactions Yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your transaction history will appear here',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => const TransactionForm());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Transaction'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
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

  void _showFilterDialog() {
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
  }

  void _deleteTransaction(WalletTransaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _walletRepository.deleteTransaction(transaction);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
