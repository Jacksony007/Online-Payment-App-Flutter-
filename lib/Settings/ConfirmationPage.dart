import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Auth Services/AuthServices.dart';
import '../Auth Services/FirestoreService.dart';
import '../Controller/UserDetails.dart';
import '../User Model/user_financial_model.dart';
import '../User Model/user_model.dart';

class ConfirmationPage extends StatefulWidget {
  // final SimCard? simCard;

  ConfirmationPage();

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  final AuthService _authService = AuthService();

  UserModel? userData;

  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    GetUserPhoneNumber();
  }

  Stream<UserModel?> streamUserData() {
    return FirebaseService().streamUserData();
  }

  Future<void> GetUserPhoneNumber() async {
    Stream<UserModel?> userDataStream = streamUserData();

    await for (UserModel? userModelDetails in userDataStream) {
      String? userPhoneNumber = userModelDetails?.phoneNumber;
      await checkAuthentication(userPhoneNumber);
    }
  }

  Future<void> checkAuthentication(String? userPhoneNumber) async {
    bool isAuthenticated = await _authService.isAuthenticated();

    if (isAuthenticated) {
      try {
        // Fetch bank details from Firestore
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection('bank_info')
            .where('phoneNumber', isEqualTo: userPhoneNumber)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Assuming there's only one document with the matching phoneNumber
          var bankData = snapshot.docs.first.data();

          // Get the ID of the retrieved document
          String bankInfoId = snapshot.docs.first.id;

          // Create a BankInfo object from the fetched data
          financialData = UserFinancialModel(
            bankInfoId: bankInfoId,
            phoneNumber: bankData['phoneNumber'],
            payflowId: bankData['payflowId'],
            bankName: bankData['bankName'],
            accountNumber: bankData['accountNumber'],
            accountName: bankData['accountName'],
            isActive: bankData['isActive'],
          );

          setState(() {
            financialData = financialData;
          });
        }
      } catch (e) {
        print('Error fetching bank details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: financialData != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.transparent,
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Colors.green,
                                    BlendMode.srcIn,
                                  ),
                                  child: Image.asset(
                                      "images/banking/verified-check-svgrepo-com.png"),
                                ),
                              ),
                              Text(
                                'Congratulation ',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                'Bank Details Successfully Verified',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 24.0),
                              Text(
                                'Account Number: ${financialData!.accountNumber}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'Account Name: ${financialData!.accountName}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                'Bank Name: ${financialData!.bankName}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              StreamBuilder<UserModel?>(
                                stream: firebaseService.streamUserData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    userData = snapshot.data!;
                                    return Text(
                                      'Phone Number: ${userData?.phoneNumber}',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    );
                                  } else {
                                    return Text(
                                      'Phone Number: ${userData?.phoneNumber}',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                },
                              ),
                              /////   Text(
                              //    'Carrier : ${widget.simCard?.carrierName ?? ''}',
                              //    style: const TextStyle(
                              //      fontSize: 18.0,
                              //      fontWeight: FontWeight.bold),
                              //   ),
                              const SizedBox(height: 20.0),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () async {
                            // Set a flag to indicate loading
                            setState(() {
                              isLoading = true;
                            });

                            // Simulate a delay using Future.delayed
                            await Future.delayed(Duration(seconds: 2));

                            // Reset the loading flag
                            setState(() {
                              isLoading = false;
                            });
                            // Generate the payflow ID automatically

                            // Call the processing method with the payflow ID
                            await processConfirmation();
                            // Dismiss the loading indicator
                            Navigator.pop(context);

                            // Navigate to the new page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Processing ...',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.payment,
                                              size: 24, color: Colors.white),
                                          const SizedBox(width: 8.0),
                                          Text(
                                            'Confirm',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(child: Text('Details not found')),
    );
  }

  Future<void> processConfirmation() async {
    try {
      // Get the current user ID
      User? user = await _authService.getCurrentUser();

      if (user != null) {
        // Add user financial details to Firebase using the FirestoreService class
        //  DocumentReference docRef =
        await FirestoreService().addFinancialDetails(financialData);
      }
    } catch (e) {
      print('Error processing confirmation: $e');
    }
  }
}
