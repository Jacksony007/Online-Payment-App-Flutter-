import 'package:flutter/material.dart';
import 'RechargeForMe.dart';
import 'RechargeForOthers.dart';

class MobileRechargeScreen extends StatefulWidget {
  final String title;

  const MobileRechargeScreen({Key? key, required this.title}) : super(key: key);

  @override
  _MobileRechargePageState createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargeScreen> {
  String mobileNumber = '';
  String selectedOperator = 'Select Operator';
  bool rechargeForSelf = true;
  bool rechargeForOthers = false;
  double price = 0.0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mobile Recharge ${widget.title}', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: [
            // Display an icon based on the recharge mode
            Icon(rechargeForSelf ? Icons.person : Icons.group, color: Colors.white,),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rechargeForSelf = true;
                          });
                        },
                        child: Text('For Myself'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rechargeForSelf ? Colors.blue : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rechargeForSelf = false;
                          });
                        },
                        child: Text('For Someone Else'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rechargeForSelf ? Colors.grey : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Conditionally display the bundles based on the recharge mode
                  Visibility(
                    visible: rechargeForSelf,
                    child: RechargeForMe(
                      rechargeForSelf: rechargeForSelf,
                    ),
                  ),
                  Visibility(
                    visible: !rechargeForSelf,
                    child: RechargeForOthers(
                      rechargeForOther: rechargeForOthers,
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Perform the recharge action
                        String message = rechargeForSelf
                            ? 'Recharge successful for $mobileNumber'
                            : 'Recharge successful for $mobileNumber on behalf of someone else';
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Recharge Status'),
                              content: Text(message),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      'Recharge',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      textStyle: TextStyle(
                        fontSize: 16,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
