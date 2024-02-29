import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Controller/UserDetails.dart';
import '../Controller/UserFinancialData.dart';
import '../General Payment/BalancePage.dart';
import '../Success Screen/BankingSuccessPage.dart';
import '../User Model/user_financial_model.dart';

class UserFinancialService {
  final FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final BuildContext context;
  final Map<String, dynamic>? params;

  UserFinancialService(this.context, {this.params = const {}});

  Future<bool> getUserId(String code, String newPIN, String title) async {
    final Stream<UserFinancialModel?> userFinancialStream =
        firebaseService.streamUserFinancialData();

    await for (UserFinancialModel? userFinancialDetails
        in userFinancialStream) {
      final String? userId = userFinancialDetails?.bankInfoId;
      final String phoneNumber = userFinancialDetails?.phoneNumber ?? '';
      return await _checkPin(userId, code, newPIN, phoneNumber, title);
    }

    return false;
  }

  Future<bool> _checkPin(String? userId, String code, String newPIN,
      String phoneNumber, String title) async {
    if (userId != null && userId.isNotEmpty) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance
                .collection('bank_info')
                .doc(userId)
                .get();

        if (snapshot.exists) {
          final balanceData = snapshot.data();

          final double balance = balanceData?['balance']?.toDouble() ?? 0.0;

          final bankInfoData = BankInfo(
            pin: balanceData?['pin'],
            balance: balance,
            userId: balanceData?['userId'],
            isActive: balanceData?['isActive'],
          );

          if (code == bankInfoData.pin) {
            await _navigateBasedOnTitle(title, userId, newPIN);
            return true;
          } else {
            _showSnackBar(context, 'Incorrect PIN. Please try again.');
            return false;
          }
        }
      } catch (e) {
        _showSnackBar(context, 'Error fetching bank details: $e');
      }
    }
    _showSnackBar(context, 'Please Login and try again.');
    return false;
  }

  Future<void> _navigateBasedOnTitle(
      String title, String? userId, String newPIN) async {
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    switch (title) {
      case 'Balance':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BalancePage(userId: userId!),
          ),
        );
        break;
      case 'Amount':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(values: params ?? {}),
          ),
        );
        break;
      case 'ChangePIN':
        await _updateFirebaseWithPIN(newPIN, userId);
        break;
      default:
        break;
    }
  }

  Future<void> _updateFirebaseWithPIN(String newPIN, String? userId) async {
    final currentUser = await _auth.currentUser;
    try {
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('bank_info')
            .doc(userId)
            .update({'pin': newPIN});

        // Show success Snackbar
        _showSnackBar(context, 'Password Successfully Changed', success: true);
        finish(context);
      }
    } catch (error) {
      // Show error Snackbar
      _showSnackBar(context, 'An error occurred, please try again.',
          success: false);
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(
              color: success ? Colors.green : Colors.red,
              // Adjust color based on success
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
