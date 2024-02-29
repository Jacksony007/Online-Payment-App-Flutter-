import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Controller/UserDetails.dart';
import '../User Model/user_financial_model.dart';
import '../utils/AppTextDecoration.dart';
import '../utils/BankingColors.dart';

class ChangePayflowIdPage extends StatefulWidget {
  ChangePayflowIdPage({Key? key}) : super(key: key);

  @override
  _ChangePayflowIdPageState createState() => _ChangePayflowIdPageState();
}

class _ChangePayflowIdPageState extends State<ChangePayflowIdPage> {
  late TextEditingController newUpiController;
  late Stream<bool> isUpiAvailableStream;
  late Timer _debounce;
  final _formKey = GlobalKey<FormState>();
  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    newUpiController = TextEditingController();
    isUpiAvailableStream = Stream<bool>.value(true);
    _debounce = Timer(const Duration(milliseconds: 500), () {});
  }

  // Method to check UPI availability
  Stream<bool> checkUpiAvailability(String newUpi) async* {
    yield await isUpiAvailable(newUpi);
  }

  // Method to check if UPI is available in Firestore
  Future<bool> isUpiAvailable(String newUpi) async {
    newUpi += '@payflow';
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('user_financial_details')
        .where('payflowId', isEqualTo: newUpi)
        .get();

    return query.docs.isEmpty;
  }

  // Method to validate UPI format
  bool isValidUpi(String input) {
    final RegExp regex = RegExp(r'^[a-z0-9.]+$');
    return regex.hasMatch(input);
  }

  // Method to change UPI ID
  void changeUpi() async {
    String newUpi = newUpiController.text.trim();

    if (!isValidUpi(newUpi)) {
      showErrorMessage(
          'Invalid characters in UPI ID. Please use lowercase letters, numbers, and dots only.');
      return;
    }

    bool isAvailable = await isUpiAvailable(newUpi);

    if (isAvailable) {
      newUpi += '@payflow';
      await updateFirebaseWithNewUpi(newUpi);
      showSuccessMessage('UPI ID changed successfully!');
      Navigator.pop(context);
    } else {
      showErrorMessage('UPI ID is already in use. Please choose another one.');
    }
  }

  // Method to update Firebase with new UPI ID
  Future<void> updateFirebaseWithNewUpi(String newUpi) async {
    User? currentUser = await _auth.currentUser;

    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection('user_financial_details')
            .doc(currentUser.uid)
            .update({'payflowId': newUpi});
      } catch (error) {
        print("Error fetching user document from Firestore: $error");
      }
    }
  }

  // Method to show success message
  void showSuccessMessage(String message) {
    showToast(message, Colors.green);
  }

  // Method to show error message
  void showErrorMessage(String message) {
    showToast(message, Colors.red);
  }

  // Method to display Toast messages
  void showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  // UI Widget for UPI Input Field
  Widget buildUpiInputField() {
    return TextFormField(
      controller: newUpiController,
      decoration: AppTextDecoration.defaultInputDecoration(
        labelText: 'New UPI ID',
        prefixIcon: Icons.perm_identity,
        iconColor: Colors.blue,
        hintText: 'Enter new UPI ID',
        suffixText: '@payflow',
      ),
      onChanged: (newUpi) {
        _debounce.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () async {
          setState(() {
            if (newUpi.isNotEmpty && isValidUpi(newUpi)) {
              isUpiAvailableStream = checkUpiAvailability(newUpi);
            }
          });
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Payflow Id cannot be empty';
        }
        return null;
      },
    );
  }

  // UI Widget for UPI Availability Message
  Widget buildUpiAvailabilityMessage(bool isAvailable) {
    return Column(children: [
      isAvailable
          ? Text(
              'This UPI ID is available!',
              style: TextStyle(
                color: isAvailable ? Colors.green : Colors.green,
                fontSize: 16,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' This Payflow ID is already in use.',
                  style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please choose another one.',
                  style: TextStyle(
                    color: isAvailable ? Colors.green : Colors.red,
                    fontSize: 16,
                  ),
                )
              ],
            )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Banking_app_Background,
        appBar: AppBar(
          title: Text(
            'Change Payflow ID',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<UserFinancialModel?>(
                    stream: firebaseService.streamUserFinancialData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserFinancialModel financialData = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Current UPI ID:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  financialData.payflowId ?? 'No PayflowId ',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            buildUpiInputField(),
                            SizedBox(height: 16),
                            StreamBuilder<bool>(
                              stream: isUpiAvailableStream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  bool isAvailable = snapshot.data!;
                                  // Only show the message when the new UPI is not empty
                                  if (newUpiController.text.isNotEmpty) {
                                    return buildUpiAvailabilityMessage(
                                        isAvailable);
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  return Container(); // or any placeholder widget you want
                                }
                              },
                            ),
                            SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
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

                                  // Dismiss the loading indicator
                                  Navigator.pop(context);
                                  changeUpi();
                                }
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Verifying ...',
                                            style:
                                                TextStyle(color: Colors.white),
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
                                              Text(
                                                'Change UPI ID',
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
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Current UPI ID:',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'No PayflowId',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            buildUpiInputField(),
                            const SizedBox(height: 24),
                            ElevatedButton(
                                onPressed: () {
                                  showErrorMessage(
                                      'Please SignIn to your accounnt in order to change your ID');
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('Please Sign In'),
                                )),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
