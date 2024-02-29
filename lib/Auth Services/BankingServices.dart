import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Controller/UserDetails.dart';
import '../Controller/UserFinancialData.dart';
import '../General Payment/BalancePage.dart';
import '../User Model/user_financial_model.dart';

class UserFinancialService {
  FirebaseService firebaseService = FirebaseService();
  BuildContext context;

  // Provide a default value for params using const {}
  UserFinancialService(
    this.context,
  );

  Future<bool> GetUserId(String PIN, String Title) async {
    Stream<UserFinancialModel?> userFinancialStream =
        firebaseService.streamUserFinancialData();

    await for (UserFinancialModel? userFinancialDetails
        in userFinancialStream) {
      String? userId = userFinancialDetails?.bankInfoId;
      return await getBalance(userId, PIN, Title);
    }

    return false;
  }

  Future<bool> getBalance(String? userId, String PIN, String Title) async {
    if (userId != null && userId.isNotEmpty) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('bank_info')
                .doc(userId)
                .get();

        if (snapshot.exists) {
          var balanceData = snapshot.data();

          double balance = balanceData?['balance']?.toDouble() ?? 0.0;

          BankInfo bankInfoData = BankInfo(
            pin: balanceData?['pin'],
            balance: balance,
            userId: balanceData?['userId'],
            isActive: balanceData?['isActive'],
          );

          if (PIN == bankInfoData.pin) {
            await Future.delayed(Duration(seconds: 2));
            Navigator.pop(context);

            if (Title == 'Balance') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BalancePage(userId: userId),
                ),
              );
            }

            return true;
          } else {
            await Future.delayed(Duration(seconds: 2));
            showSnackBar('Incorrect PIN. Please try again.');
            return false;
          }
        }
      } catch (e) {
        showSnackBar('Error fetching bank details: $e');
      }
    }
    showSnackBar('Please Login and try again.');
    return false;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
