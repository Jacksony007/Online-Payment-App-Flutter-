import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../User Model/user_financial_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> streamUserDocument(String userId) {
    try {
      return _firestore.collection('users').doc(userId).snapshots();
    } catch (error) {
      print('Error streaming user document from Firestore: $error');
      throw error;
    }
  }

  Stream<DocumentSnapshot> streamFinancialDocument(String userId) {
    try {
      return _firestore
          .collection('user_financial_details')
          .doc(userId)
          .snapshots();
    } catch (error) {
      print('Error streaming financial document from Firestore: $error');
      throw error;
    }
  }

  Future<void> createUserDocument(String userId, String? email,
      String? displayName, String phoneNumber) async {
    String toTitleCase(String text) {
      return text.toLowerCase().split(' ').map((word) {
        if (word.isNotEmpty) {
          return word[0].toUpperCase() + word.substring(1);
        } else {
          return '';
        }
      }).join(' ');
    }

    String capitalizedAccountName = toTitleCase(displayName ?? '');

    try {
      // Get the existing user document
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      // Check if email, displayName, and phoneNumber are not empty before updating
      Map<String, dynamic> updateData = {};

      // Include existing data in the updateData map
      updateData.addAll(userDoc.data() as Map<String, dynamic>);

      if (email != null && email.isNotEmpty) {
        updateData['email'] = email;
      }

      if (displayName != null && displayName.isNotEmpty) {
        updateData['displayName'] = capitalizedAccountName;
      }

      if (phoneNumber.isNotEmpty) {
        updateData['phoneNumber'] = phoneNumber;
      }

      // Update the user document with the new values (if any)
      await _firestore.collection('users').doc(userId).set(updateData);
    } catch (error) {
      print('Error creating user document in Firestore: $error');
      throw error;
    }
  }

  String generatePayflowId(String? phoneNumber) {
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      return '${phoneNumber.replaceAll('+', '')}@payflow';
    }
    return '';
  }

  Future<DocumentReference> addFinancialDetails(
      UserFinancialModel? userBankDetails) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String payflowId = generatePayflowId(userBankDetails?.phoneNumber);

        CollectionReference financialDetailsCollection =
            FirebaseFirestore.instance.collection('user_financial_details');

        // Convert the user financial details to a Map
        Map<String, dynamic> userFinancialDetailsMap = {
          'bankInfoId': userBankDetails?.bankInfoId,
          'phoneNumber': userBankDetails?.phoneNumber,
          'payflowId': payflowId,
          'bankName': userBankDetails?.bankName ?? '',
          'accountNumber': userBankDetails?.accountNumber ?? '',
          'accountName': userBankDetails?.accountName ?? '',
          'isActive': userBankDetails?.isActive ?? false,
        };

        // Add the user financial details to Firebase
        await financialDetailsCollection
            .doc(user.uid)
            .set(userFinancialDetailsMap);

        // Return the DocumentReference
        return financialDetailsCollection.doc(user.uid);
      }
      throw Exception("User not authenticated.");
    } catch (error) {
      print("Error adding financial details to Firebase: $error");
      throw error;
    }
  }
}
