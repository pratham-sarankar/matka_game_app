import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matka_game_app/models/wallet_transaction.dart';
import 'package:matka_game_app/repositories/user_wallets_repository.dart';
import 'package:matka_game_app/screens/users/user_form_screen.dart';
import 'package:matka_game_app/services/user_service.dart';
import 'package:photo_view/photo_view.dart';

class UserWallets extends StatefulWidget {
  const UserWallets({super.key});

  @override
  State<UserWallets> createState() => _UserWalletsState();
}

class _UserWalletsState extends State<UserWallets> {
  final _repository = UserWalletsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Wallets"),
      ),
      body: StreamBuilder(
        stream: _repository.streamWalletRequests(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return GestureDetector(
                  onTap: () async {
                    final result = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(transaction.userID)
                        .get();
                    final user = UserData.fromJson(result.data()!);
                    Get.to(UserFormScreen(Get.find(), user: user));
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                      right: 20,
                      left: 20,
                      top: 20,
                    ),
                    elevation: 5,
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rupee Symbol
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
                          if (transaction.mediaURL != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
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
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    side: BorderSide(
                                      color: Colors.green.shade800,
                                      width: 2,
                                    ),
                                  ),
                                  onPressed: () {
                                    _repository.updateTransactionStatus(
                                      transaction,
                                      WalletTransactionStatus.approved,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.check_mark,
                                        color: Colors.green.shade900,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Approve",
                                        style: TextStyle(
                                          color: Colors.green.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
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
                                  ),
                                  onPressed: () {
                                    _repository.updateTransactionStatus(
                                      transaction,
                                      WalletTransactionStatus.rejected,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.clear,
                                        color: Colors.red.shade900,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Reject",
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
                        ],
                      ),
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
