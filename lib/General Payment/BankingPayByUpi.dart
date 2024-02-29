import 'package:flutter/material.dart';
import '../Controller/UserDetails.dart';
import '../Pay Bills/VerifiedUPI.dart';
import '../Settings/PhoneNumberVerifier.dart';
import '../User Model/user_financial_model.dart';
import '../utils/AppTextDecoration.dart';
import '../utils/BankingColors.dart';

class PayToUpiPage extends StatefulWidget {
  const PayToUpiPage({Key? key}) : super(key: key);

  @override
  _PayToUpiPageState createState() => _PayToUpiPageState();
}

class _PayToUpiPageState extends State<PayToUpiPage> {
  late TextEditingController _upiIdController;
  bool _isVerified = false;
  bool _isLoading = false;
  bool _verificationFailed = false;

  PhoneNumberVerifier phoneNumberVerifier = PhoneNumberVerifier();

  UserFinancialModel? financialData;
  FirebaseService firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _upiIdController = TextEditingController();
  }

  @override
  void dispose() {
    _upiIdController.dispose();
    super.dispose();
  }

  Future<void> verifyPhoneNumber(String userUpiId) async {
    setState(() {
      _isVerified = false;
      _isLoading = true;
      _verificationFailed = false;
    });

    if (_formKey.currentState!.validate()) {
      financialData =
          await phoneNumberVerifier.getPhoneNumber(context, userUpiId);

      setState(() {
        _isLoading = false;
      });

      if (financialData != null) {
        setState(() {
          _isVerified = true;
        });
      } else {
        setState(() {
          _verificationFailed = true;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Banking_app_Background,
        appBar: AppBar(
          title: Text(
            'Pay by UPI',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _upiIdController,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'Enter Payflow ID',
                      hintText: 'example@payflow',
                      prefixIcon: Icons.person,
                      iconColor: Colors.blue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'PayflowId cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isVerified = false;
                        _isLoading = true;
                        _verificationFailed =
                            false; // Reset verification failure status
                      });

                      if (_formKey.currentState!.validate()) {
                        String UpiId = _upiIdController.text;
                        await verifyPhoneNumber(UpiId);
                      }

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Verify Payflow ID',
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  if (_isLoading) ...[
                    Text(
                      'Verifying Payflow ID...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                    CircularProgressIndicator(),
                    SizedBox(height: 16.0),
                  ],
                  if (_isVerified) ...[
                    Text(
                      'Payflow ID Verified!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    VerifiedUpiIdPage(financialData: financialData),
                  ],
                  SizedBox(height: 16.0),
                  if (_verificationFailed) ...[
                    Text(
                      'Verification Failed.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Please check the Payflow ID and try again.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                  Text(
                    'Recent Contacts..',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
