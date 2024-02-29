import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../User Model/user_financial_model.dart';
import '../User Model/user_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData() async {
    try {
      User? currentUser = await _auth.currentUser;

      if (currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? cachedDataString = prefs.getString(currentUser.uid);

        if (cachedDataString != null && cachedDataString.isNotEmpty) {
          // Use cached data from SharedPreferences
          return UserModel.fromJson(Map<String, dynamic>.from(
              json.decode(cachedDataString) as Map<String, dynamic>));
        } else {
          // Fetch data from Firebase if not available in SharedPreferences
          DocumentSnapshot documentSnapshot =
              await _firestore.collection('users').doc(currentUser.uid).get();

          if (documentSnapshot.exists) {
            UserModel userModel = UserModel.fromJson(
                documentSnapshot.data() as Map<String, dynamic>);
            // Update SharedPreferences with the fetched data
            await updateUserDataInSharedPreferences(currentUser.uid, userModel);
            return userModel;
          } else {
            // No data found in both Firebase and SharedPreferences
            return null;
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle error, you might want to return a default UserModel or show an error message
      return null;
    }
    return null;
  }

  Stream<UserModel?> streamUserData() async* {
    final User? currentUser = await _auth.currentUser;

    if (currentUser != null) {
      yield* _firestore
          .collection('users')
          .doc(currentUser.uid) // Use currentUser.uid
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          UserModel userModel =
              UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
          // Update SharedPreferences with the fetched data
          updateUserDataInSharedPreferences(currentUser.uid, userModel);
          return userModel;
        } else {
          // Handle case when data is not available
          return null;
        }
      });
    }
  }

  Future<void> updateUserDataInSharedPreferences(
      String userId, UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userId, json.encode(userModel.toJson()));
  }

  Future<UserFinancialModel?> getUserFinancialData() async {
    try {
      User? currentUser = await _auth.currentUser;

      if (currentUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? cachedDataString = prefs.getString(currentUser.uid);

        if (cachedDataString != null && cachedDataString.isNotEmpty) {
          // Use cached data from SharedPreferences
          return UserFinancialModel.fromJson(json.decode(cachedDataString));
        } else {
          // Fetch data from Firebase if not available in SharedPreferences
          DocumentSnapshot documentSnapshot = await _firestore
              .collection('user_financial_details')
              .doc(currentUser.uid)
              .get();

          if (documentSnapshot.exists) {
            UserFinancialModel financialModel = UserFinancialModel.fromJson(
                documentSnapshot.data() as Map<String, dynamic>);
            // Update SharedPreferences with the fetched data
            await updateFinancialDataInSharedPreferences(
                currentUser.uid, financialModel);
            return financialModel;
          } else {
            // No data found in both Firebase and SharedPreferences
            return null;
          }
        }
      }
    } catch (e) {
      print("Error fetching financial data: $e");
      // Handle error, you might want to return a default UserFinancialModel or show an error message
      return null;
    }
    return null;
  }

  Stream<UserFinancialModel?> streamUserFinancialData() async* {
    final User? currentUser = await _auth.currentUser;

    if (currentUser != null) {
      yield* _firestore
          .collection('user_financial_details')
          .doc(currentUser.uid)
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          UserFinancialModel financialModel = UserFinancialModel.fromJson(
              snapshot.data() as Map<String, dynamic>);
          // Update SharedPreferences with the fetched data
          updateFinancialDataInSharedPreferences(
              currentUser.uid, financialModel);
          return financialModel;
        } else {
          // Handle case when financial data is not available
          return null;
        }
      });
    }
  }

  Future<void> updateFinancialDataInSharedPreferences(
      String userId, UserFinancialModel financialModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userId, json.encode(financialModel.toJson()));
  }
}
