import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WalletTransaction {
  final String id;
  final String userID;
  num amount;
  WalletTransactionType type;
  String note;
  WalletTransactionStatus status;
  String? mediaURL;
  String? mode;
  String? gateway;
  String? gatewayHost;
  Timestamp? requestedAt;
  Timestamp? respondedAt;

  WalletTransaction({
    required this.id,
    required this.userID,
    required this.amount,
    required this.type,
    required this.note,
    required this.status,
    this.mediaURL,
    this.mode,
    this.gateway,
    this.gatewayHost,
    this.requestedAt,
    this.respondedAt,
  });

  factory WalletTransaction._fromMap(Map data) {
    return WalletTransaction(
      id: data["id"],
      userID: data["userID"],
      amount: data["amount"],
      type: WalletTransactionTypeExtension.fromString(data["type"]),
      note: data["note"],
      status: WalletTransactionStatusExtension.fromString(data["status"]),
      mediaURL: data["mediaURL"],
      mode: data["mode"],
      gateway: data["gateway"],
      gatewayHost: data["gatewayHost"],
      requestedAt: data["requestedAt"],
      respondedAt: data["respondedAt"],
    );
  }

  factory WalletTransaction.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    data["id"] = doc.id;
    return WalletTransaction._fromMap(data);
  }

  Map<String,dynamic> toMap() {
    return {
      "userID": userID,
      "amount": amount,
      "type": type.name,
      "note": note,
      "status": status.name,
      "mediaURL": mediaURL,
      "mode": mode,
      "gateway": gateway,
      "gatewayHost": gatewayHost,
      "requestedAt": requestedAt,
      "respondedAt": respondedAt,
    };
  }
}

enum WalletTransactionType {
  deposit,
  withdrawal,
}

extension WalletTransactionTypeExtension on WalletTransactionType {
  String get name {
    switch (this) {
      case WalletTransactionType.deposit:
        return "Deposit";
      case WalletTransactionType.withdrawal:
        return "Withdrawal";
    }
  }

  String get symbol {
    switch (this) {
      case WalletTransactionType.deposit:
        return "+";
      case WalletTransactionType.withdrawal:
        return "-";
    }
  }

  static WalletTransactionType fromString(String value) {
    switch (value) {
      case "Deposit":
        return WalletTransactionType.deposit;
      case "Withdrawal":
        return WalletTransactionType.withdrawal;
      default:
        return WalletTransactionType.deposit;
    }
  }


  static List<DropdownMenuItem<String>> get dropDownItems {
    return WalletTransactionType.values.map(
      (e) {
        return DropdownMenuItem(
          value: e.name,
          child: Text(e.name),
        );
      },
    ).toList();
  }
}

enum WalletTransactionStatus {
  pending,
  approved,
  rejected,
}

extension WalletTransactionStatusExtension on WalletTransactionStatus {
  String get name {
    switch (this) {
      case WalletTransactionStatus.pending:
        return "Pending";
      case WalletTransactionStatus.approved:
        return "Approved";
      case WalletTransactionStatus.rejected:
        return "Rejected";
    }
  }

  Color get color{
    switch (this) {
      case WalletTransactionStatus.pending:
        return Colors.orange.shade700;
      case WalletTransactionStatus.approved:
        return Colors.green.shade700;
      case WalletTransactionStatus.rejected:
        return Colors.red.shade700;
    }
  }

  static WalletTransactionStatus fromString(String value) {
    switch (value) {
      case "Pending":
        return WalletTransactionStatus.pending;
      case "Approved":
        return WalletTransactionStatus.approved;
      case "Rejected":
        return WalletTransactionStatus.rejected;
      default:
        return WalletTransactionStatus.pending;
    }
  }

  static List<DropdownMenuItem<String>> get dropDownItems {
    return WalletTransactionStatus.values.map(
          (e) {
        return DropdownMenuItem(
          value: e.name,
          child: Text(e.name),
        );
      },
    ).toList();
  }
}
