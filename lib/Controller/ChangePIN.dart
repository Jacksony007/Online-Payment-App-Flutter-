import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../User Model/user_financial_model.dart';
import 'UserDetails.dart';

class ChangePIN {
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  BuildContext context;

  // Provide a default value for params using const {}
  ChangePIN(this.context);

  // Method to update Firebase with new PIN
  Future<void> updateFirebaseWithPIN(String newPIN) async {
    User? currentUser = await _auth.currentUser;
    try {
      Stream<UserFinancialModel?> userFinancialStream =
          firebaseService.streamUserFinancialData();

      await for (UserFinancialModel? userFinancialDetails
          in userFinancialStream) {
        String? userId = userFinancialDetails?.bankInfoId;

        if (currentUser != null) {
          await FirebaseFirestore.instance
              .collection('bank_info')
              .doc(userId)
              .update({'pin': newPIN});
        }
      }
    } catch (error) {
      print("Error fetching user document from Firestore: $error");
    }
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
