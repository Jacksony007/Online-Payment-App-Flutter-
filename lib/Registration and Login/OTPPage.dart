import 'package:flutter/material.dart';
import '../Auth Services/AuthServices.dart';
import '../utils/BankingDigitHolder.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  String? email;
  String? displayName;
  String? Title;

  OtpPage(
      {Key? key,
      required this.phoneNumber,
      this.email,
      this.displayName,
      this.Title})
      : super(key: key);

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var selectedindex = 0;
  String code = '';
  bool isLoading = false;
  String errorMessage = '';
  int maxCodeLength = 6;

  @override
  Widget build(BuildContext context) {
    // Extract the arguments
    final String phoneNumber = widget.phoneNumber;
    final String? email = widget.email ?? '';
    final String? displayName = widget.displayName ?? '';
    final String? Title = widget.Title ?? '';

    TextStyle textStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w500,
      color: Colors.black.withBlue(40),
    );
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black.withBlue(40),
      body: Column(
        children: [
          Container(
            height: height * 0.15,
            width: width,
            color: Colors.black.withBlue(40),
            alignment: Alignment.center,
            child: SafeArea(
              child: SizedBox(
                height: height * 0.06,
                width: height * 0.06,
                child: Image.asset(
                  "images/banking/lock-alt-svgrepo-com.png",
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Container(
            height: height * 0.85,
            width: width,
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Verification Code",
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black.withBlue(100),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Please enter the OTP sent to ${phoneNumber}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black.withBlue(100),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int index = 0; index < maxCodeLength; index++)
                          DigitHolder(
                            width: width,
                            index: index,
                            selectedIndex: selectedindex,
                            code: code,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                        alignment: Alignment.center,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  code = '';
                                  AuthService().resendOTP(phoneNumber, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text('Resend OTP'),
                              ),
                              SizedBox(height: 16),
                              SizedBox(height: 16),
                            ]))),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(1);
                                      },
                                      child: Text('1', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(2);
                                      },
                                      child: Text('2', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(3);
                                      },
                                      child: Text('3', style: textStyle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(4);
                                      },
                                      child: Text('4', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(5);
                                      },
                                      child: Text('5', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(6);
                                      },
                                      child: Text('6', style: textStyle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(7);
                                      },
                                      child: Text('7', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(8);
                                      },
                                      child: Text('8', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(9);
                                      },
                                      child: Text('9', style: textStyle),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        backspace();
                                      },
                                      child: Icon(
                                        Icons.backspace_outlined,
                                        color: Colors.black.withBlue(40),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () {
                                        addDigit(0);
                                      },
                                      child: Text('0', style: textStyle),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(
                                            height: double.maxFinite,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  // Show loading indicator
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  // Verify OTP
                                                  await AuthService().verifyOTP(
                                                      code,
                                                      email,
                                                      displayName,
                                                      Title,
                                                      context);
                                                  // Registration successful
                                                  // You can navigate to a success page or handle it as needed
                                                  // For example, you can use the Navigator to push a new route
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context, '/');
                                                } catch (error) {
                                                  // Verification failed
                                                  setState(() {
                                                    isLoading = false;
                                                    errorMessage =
                                                        'Incorrect OTP. Please try again.';
                                                  });
                                                }
                                              },
                                              child: isLoading
                                                  ? CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                        Colors.black
                                                            .withBlue(40),
                                                      ),
                                                    )
                                                  : Icon(
                                                      Icons.check,
                                                      color: Colors.black
                                                          .withBlue(40),
                                                      size: 30,
                                                    ),
                                              style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (errorMessage.isNotEmpty)
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addDigit(int digit) {
    setState(() {
      if (code.length < maxCodeLength) {
        code = code + digit.toString();
      }
      if (code.length == maxCodeLength) {}
    });
  }

  void backspace() {
    if (code.isEmpty) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedindex = code.length;
    });
  }
}
