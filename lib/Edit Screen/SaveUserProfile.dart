import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/Controller/UserDetails.dart';
import 'package:nb_utils/nb_utils.dart';

class SaveUserProfile{
  final FirebaseService firebaseService = FirebaseService();

   final BuildContext context;

   SaveUserProfile(this.context);

  Future<void> _updateUserProfile(String displayName,String email) async {

    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({'displayName': displayName, 'email':email, 'photoURL':photoURL});

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