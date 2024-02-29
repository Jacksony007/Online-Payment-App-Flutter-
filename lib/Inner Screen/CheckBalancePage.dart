// ... (your existing imports)

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';

class CheckBalancePage extends StatefulWidget {
  static var tag = "/CheckBalancePage";

  const CheckBalancePage({Key? key}) : super(key: key);

  @override
  _CheckBalancePageState createState() => _CheckBalancePageState();
}

class _CheckBalancePageState extends State<CheckBalancePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController passwordController;
  late AnimationController _shakeController;
  bool isPasswordCorrect = false;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Banking_app_Background,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            if (!isPasswordCorrect)
              Row(
                children: [
                  Icon(
                    Icons.account_balance,
                    color: Banking_TextColorPrimary,
                    size: 38,
                  ),
                  16.width,
                  Text(
                    'Check Balance',
                    style: boldTextStyle(
                      color: Banking_TextColorPrimary,
                      size: 35,
                    ),
                  ),
                ],
              ),
            if (isPasswordCorrect)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        isPasswordCorrect = false;
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Account Balance',
                    style: boldTextStyle(
                      color: Banking_TextColorPrimary,
                      size: 24,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            20.height,
            if (!isPasswordCorrect)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: boxDecorationWithShadow(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter PIN',
                      style: boldTextStyle(
                        color: Banking_TextColorPrimary,
                        size: 20,
                      ),
                    ),
                    16.height,
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'PIN',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    16.height,
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPasswordCorrect = false;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            isPasswordCorrect = true;
                            _shakeController.forward(from: 0.0);
                          });
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Banking_Primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 24,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check),
                          8.width,
                          Text('Submit'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (isPasswordCorrect)
              Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Banking_Primary,
                        size: 150,
                      ),
                      16.height,
                      Text(
                        'Account Balance Fetched',
                        style: boldTextStyle(
                          color: Banking_TextColorPrimary,
                          size: 24,
                        ),
                      ),
                      Text(
                        'Successful',
                        style: boldTextStyle(
                          color: Banking_TextColorPrimary,
                          size: 20,
                        ),
                      ),
                      16.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance,
                            color: Colors.blue,
                            size: 20,
                          ),
                          8.width,
                          Text(
                            "Canara Bank",
                            style: primaryTextStyle(
                              color: Banking_TextColorPrimary,
                              size: 16,
                              fontFamily: fontRegular,
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Text(
                        '\$1,000.00',
                        style: boldTextStyle(
                          color: Banking_Primary,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isPasswordCorrect && passwordController.text.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Banking_Primary,
                    ),
                  ),
                  16.height,
                  Center(
                    child: Text(
                      'Checking Your PIN...',
                      style: primaryTextStyle(
                        color: Banking_TextColorSecondary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
