import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/utils/AppTextDecoration.dart';

import '../Edit Screen/PinScreen.dart';

class PaymentPage extends StatefulWidget {
  final String title;
  final String state;
  final String meterNumber;

  const PaymentPage({
    Key? key,
    required this.title,
    required this.state,
    required this.meterNumber,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _amountController;
  late TextEditingController _pinController;
  double _units = 0.0;
  final String _paymentId = '007';
  final String _name = 'John Doe';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountController.addListener(_calculateUnits);
    _pinController = TextEditingController();
  }

  void _calculateUnits() {
    setState(() {
      final double? parsedValue = double.tryParse(_amountController.text);
      if (widget.title.toLowerCase() == 'electricity bill') {
        _units = parsedValue != null ? parsedValue / 2.345 : 0.0;
      } else if (widget.title.toLowerCase() == 'water bill') {
        _units = parsedValue != null ? parsedValue / 1.345 : 0.0;
      } else {
        _units = 0.0;
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  double? parseAmount(String input) {
    try {
      return double.parse(input);
    } catch (e) {
      return null;
    }
  }

  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Pay ${widget.title}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                // Add any additional actions or information here
              },
            ),
          ],
        ),
        body: Padding(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Reusable header widget with the same style and image as AmountPage
                        Column(
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
                            const SizedBox(width: 8.0),
                            Text(
                              'Verified Name: William Armah',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'State: ${widget.state}',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'Meter Number: ${widget.meterNumber}',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        TextFormField(
                          controller: _amountController,
                          decoration: AppTextDecoration.defaultInputDecoration(
                            labelText: 'Enter Amount',
                            prefixIcon: Icons.attach_money,
                            iconColor: Colors.blue,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Calculated Units: ${_units.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 24.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              double? amount =
                                  parseAmount(_amountController.text);
                              if (amount != null) {
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

                                // Navigate to the new page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordView(
                                      params: {
                                        'TransactionId': _paymentId,
                                        'Name of Owner': _name,
                                        'Meter Number': widget.meterNumber,
                                        'Location': widget.state,
                                        'Amount': amount.toStringAsFixed(2),
                                        'Units': _units.toStringAsFixed(2),
                                        "Receiver's Name": widget.title,
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                showSnackBar('Invalid amount entered', context);
                              }
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
                                            'Pay Now',
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
            )));
  }
}
