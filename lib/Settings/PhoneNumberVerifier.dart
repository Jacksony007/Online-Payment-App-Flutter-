import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Auth Services/AuthServices.dart';
import '../User Model/user_financial_model.dart';

class PhoneNumberVerifier {
  final AuthService _authService = AuthService();

  Future<UserFinancialModel?> getPhoneNumber(
      BuildContext context, String? userUpiId) async {
    final bool isAuthenticated = await _authService.isAuthenticated();

    if (!isAuthenticated) {
      showSnackBar("Please SignIn to your Account.", context);
      return null;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user_financial_details')
          .where('payflowId', isEqualTo: userUpiId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var bankData = snapshot.docs.first.data();
        String bankInfoId = snapshot.docs.first.id;

        return UserFinancialModel(
          bankInfoId: bankInfoId,
          phoneNumber: bankData['phoneNumber'],
          payflowId: bankData['payflowId'],
          bankName: bankData['bankName'],
          accountNumber: bankData['accountNumber'],
          accountName: bankData['accountName'],
          isActive: bankData['isActive'],
        );
      } else {
        return null; // No matching document found
      }
    } catch (e) {
      print('Error fetching bank details: $e');
      return null;
    }
  }

  Future<UserFinancialModel?> verifyPhoneNumber(
      BuildContext context, String? phoneNumber) async {
    final bool isAuthenticated = await _authService.isAuthenticated();

    if (!isAuthenticated) {
      showSnackBar("Please SignIn to your Account.", context);
      return null;
    }

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user_financial_details')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var bankData = snapshot.docs.first.data();
        String bankInfoId = snapshot.docs.first.id;

        return UserFinancialModel(
          bankInfoId: bankInfoId,
          phoneNumber: bankData['phoneNumber'],
          payflowId: bankData['payflowId'],
          bankName: bankData['bankName'],
          accountNumber: bankData['accountNumber'],
          accountName: bankData['accountName'],
          isActive: bankData['isActive'],
        );
      } else {
        showSnackBar(
            "Verification Failed: Mobile number not registered", context);
      }
    } catch (e) {
      print('Error fetching bank details: $e');

      return null;
    }
    return null;
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
