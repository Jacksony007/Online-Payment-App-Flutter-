import 'package:cloud_firestore/cloud_firestore.dart';

class BankInfo {
  late String? pin;
  late String? userId;
  late double balance;
  late bool isActive;

  BankInfo(
      {required this.userId,
      required this.balance,
      this.pin,
      required this.isActive});

  // Factory method to create BankInfo instance from Firestore document snapshot
  factory BankInfo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return BankInfo(
      userId: data['userId'] ?? '',
      pin: data['pin'] ?? '',
      balance: data['balance'] ?? 0.0,
      isActive: data['isActive'] ?? false,
    );
  }
}
