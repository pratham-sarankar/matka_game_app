import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/repositories/wallet_repository.dart';
import 'package:matka_game_app/screens/my_wallet/transaction_form.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:photo_view/photo_view.dart';

import '../../models/wallet_transaction.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen(this.userService, {super.key});

  final UserService userService;

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  final _repository = WalletRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
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
      body: StreamBuilder(
        stream: _repository.streamTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 20,
                  ),
                  elevation:
                      transaction.status == WalletTransactionStatus.rejected
                          ? 0
                          : 5,
                  color: transaction.status == WalletTransactionStatus.rejected
                      ? Colors.grey.shade300
                      : Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Rupee Symbol
                        Row(
                          children: [
                            Text(
                              "${transaction.type.symbol} ₹${transaction.amount}",
                              style: TextStyle(
                                color: transaction.type ==
                                        WalletTransactionType.deposit
                                    ? Colors.green
                                    : Colors.red,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Chip(
                              label: Text(
                                transaction.status.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              color: WidgetStatePropertyAll(
                                  transaction.status.color),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ],
                        ),
                        if (transaction.mediaURL != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(
                                  PhotoView(
                                    imageProvider:
                                        NetworkImage(transaction.mediaURL!),
                                  ),
                                );
                              },
                              child: Image.network(
                                transaction.mediaURL!,
                                height: 80,
                              ),
                            ),
                          ),
                        const SizedBox(height: 5),
                        Text(
                          "Note : ${transaction.note}",
                          style: TextStyle(
                            color: Colors.grey.shade900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (transaction.status ==
                            WalletTransactionStatus.pending)
                          Center(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                side: BorderSide(
                                  color: Colors.red.shade800,
                                  width: 2,
                                ),
                                minimumSize: const Size(double.infinity, 0),
                              ),
                              onPressed: () {
                                _repository.deleteTransaction(transaction);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.delete,
                                    color: Colors.red.shade900,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Delete Request",
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
          }
        },
      ),
    );
  }
}
