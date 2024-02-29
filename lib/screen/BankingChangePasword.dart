import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Auth Services/UserFinancialService.dart';
import '../Controller/UserDetails.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingWidget.dart';

class BankingChangePassword extends StatefulWidget {
  static var tag = "/BankingChangePassword";

  const BankingChangePassword({Key? key}) : super(key: key);

  @override
  _BankingChangePasswordState createState() => _BankingChangePasswordState();
}

class _BankingChangePasswordState extends State<BankingChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController comfirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  int maxCodeLength = 4;

  FirebaseService firebaseService = FirebaseService();
  late UserFinancialService userFinancialService;

  @override
  void initState() {
    super.initState();
    userFinancialService = UserFinancialService(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    30.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Icon(Icons.chevron_left,
                                size: 25, color: Banking_blackColor)
                            .onTap(
                          () {
                            finish(context);
                          },
                        ),
                        20.height,
                        Text("Change\nPayflow PIN",
                            style: boldTextStyle(
                                size: 30, color: Banking_TextColorPrimary)),
                      ],
                    ),
                    20.height,
                    EditText(
                      text: "Old Password",
                      mController: oldPasswordController,
                      isPassword: true,
                      isSecure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Old cannot be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    16.height,
                    EditText(
                      text: "New Password",
                      mController: newPasswordController,
                      isPassword: true,
                      isSecure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'New Password cannot be empty';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    16.height,
                    EditText(
                      text: "Confirm New Password",
                      mController: comfirmPasswordController,
                      isPassword: true,
                      isSecure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        } else if (comfirmPasswordController.text !=
                            newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    30.height,
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await handlePinVerification();

                          //  toasty(context, 'Password Successfully Changed');
                          //  finish(context);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        // Background color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        // Padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15.0), // Border radius
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Colors.black.withBlue(40),
                              ),
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              'Payflow App'.toUpperCase(),
              style: primaryTextStyle(
                  color: Banking_TextColorSecondary,
                  size: 18,
                  fontFamily: fontRegular),
            ),
          ).paddingBottom(16),
        ],
      ),
    );
  }

  // Function to handle PIN verification
  Future<void> handlePinVerification() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      String Title = 'ChangePIN';
      bool isPinVerified = await userFinancialService.getUserId(
        oldPasswordController.text,
        newPasswordController.text,
        Title,
      );

      if (mounted) {
        setState(() {
          if (!isPinVerified) {
            // Only reset code if PIN verification fails
          }
          isLoading = false;
        });
      }
    } catch (error) {
      print("Error: $error");

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
