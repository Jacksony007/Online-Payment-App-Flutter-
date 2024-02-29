import 'package:flutter/material.dart';
import '../Auth Services/UserFinancialService.dart';
import '../Controller/UserDetails.dart';
import '../utils/BankingDigitHolder.dart';

class PasswordView extends StatefulWidget {
  final Map<String, dynamic> params;

  const PasswordView({Key? key, required this.params}) : super(key: key);

  @override
  _PasswordViewState createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  var selectedindex = 0;
  String code = '';
  bool isLoading = false;
  int maxCodeLength = 4;

  FirebaseService firebaseService = FirebaseService();
  late UserFinancialService userFinancialService;

  @override
  void initState() {
    super.initState();
    userFinancialService = UserFinancialService(context, params: widget.params);
  }

  @override
  Widget build(BuildContext context) {
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
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              "Enter your PIN",
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.black.withBlue(100),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              // Use the extracted values from params
                              "Pay ${widget.params['Amount']} Cedi  to ${widget.params["Receiver's Name"]}",
                              style: TextStyle(
                                fontSize: 18,
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
                                  child: SizedBox(
                                    height: double.maxFinite,
                                    child: TextButton(
                                      onPressed: () async {
                                        await handlePinVerification();
                                      },
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                Colors.black.withBlue(40),
                                              ),
                                            )
                                          : Icon(
                                              Icons.check,
                                              color: Colors.black.withBlue(40),
                                              size: 30,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
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
      if (code.length == maxCodeLength) {
        //   await handlePinVerification();
      }
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

  // Function to handle PIN verification
  Future<void> handlePinVerification() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Call the asynchronous method
      String Title = 'Amount';
      String PIN = code;
      bool isPinVerified =
          await userFinancialService.getUserId(code, Title, PIN);

      setState(() {
        if (!isPinVerified) {
          // Only reset code if PIN verification fails
          code = '';
        }
        isLoading = false;
      });
    } catch (error) {
      // Handle any errors that occur during the asynchronous operation
      print("Error: $error");
      setState(() {
        isLoading = false;
      });
    }
  }
}
