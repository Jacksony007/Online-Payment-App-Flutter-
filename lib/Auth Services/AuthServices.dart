import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Mapping/AppRoutes.dart';
import '../User Model/user_model.dart';
import 'FirestoreService.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? verificationId;
  static int? resendToken;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<bool> isAuthenticated() async {
    User? user = await getCurrentUser();
    return user != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> registerWithPhoneNumber(String phoneNumber, String? email,
      String? displayName, String Title, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorSnackbar(context, e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? newResendToken) async {
          AuthService.verificationId = verificationId;
          AuthService.resendToken = newResendToken;

          Navigator.pushReplacementNamed(context, AppRoutes.otp, arguments: {
            'phoneNumber': phoneNumber,
            'email': email ?? '',
            'displayName': displayName ?? '',
            'Title': Title,
          });
          print('object2');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP sent successfully'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: Duration(seconds: 120),
      );
    } catch (error) {
      print(error);
      _showErrorSnackbar(
          context, 'Error registering with phone number: $error');
      throw error;
    }
  }

  Future<void> sendOTPForPINChange(String phoneNumber, String newPIN,
      String Title, BuildContext context) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            _showErrorSnackbar(context, e.message ?? 'Verification failed');
          },
          codeSent: (String otpVerificationId, int? newResendToken) async {
            AuthService.verificationId = otpVerificationId;
            AuthService.resendToken = newResendToken;

            Navigator.pushReplacementNamed(context, AppRoutes.otp, arguments: {
              'phoneNumber': phoneNumber,
              'email': '',
              'displayName': newPIN,
              'Title': Title,
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('OTP sent successfully'),
                duration: Duration(seconds: 3),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
          timeout: Duration(seconds: 120),
        );
      }
      return;
    } catch (error) {
      print(error);
      _showErrorSnackbar(context, 'Error sending OTP for PIN change: $error');
      throw error;
    }
  }

  Future<void> verifyOTP(String smsCode, String? email, String? displayName,
      String? Title, BuildContext context) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      User? user = _auth.currentUser;

      if (user != null) {
        if (Title == 'Registration') {
          await user.updateDisplayName(displayName ?? '');

          await FirestoreService().createUserDocument(
              user.uid, email ?? '', displayName ?? '', user.phoneNumber ?? '');

          UserModel userModel = UserModel(
            email: user.email ?? '',
            displayName: user.displayName ?? '',
            phoneNumber: user.phoneNumber,
          );

          // Save user data and avatarHOW
          await saveUserToSharedPreferences(userModel);
        }
      }
    } catch (error) {
      print("Error title : $error");
      throw error;
    }
  }

  Future<void> saveUserToSharedPreferences(UserModel userModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> userMap = userModel.toJson();

      prefs.setString('user_data', json.encode(userMap));

      // Save user avatar image to file
    } catch (error) {
      print('Error saving user data: $error');
      throw error;
    }
  }

  Future<void> resendOTP(String phoneNumber, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showErrorSnackbar(context, e.message ?? 'Verification failed');
        },
        codeSent: (String newVerificationId, int? newResendToken) async {
          AuthService.verificationId = newVerificationId;
          AuthService.resendToken = newResendToken;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP resent successfully'),
              duration: Duration(seconds: 3),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String newVerificationId) {},
        forceResendingToken: AuthService.resendToken,
      );
    } catch (error) {
      _showErrorSnackbar(context, 'Error resending OTP: $error');
      throw error;
    }
  }

  void _showErrorSnackbar(BuildContext context, String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
