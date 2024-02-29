import 'package:flutter/material.dart';

import '../Edit Screen/PinScreen.dart';


class AmountEntryScreen extends StatefulWidget {
  final String companyName;

  const AmountEntryScreen({Key? key, required this.companyName}) : super(key: key);

  @override
  _AmountEntryScreenState createState() => _AmountEntryScreenState();
}

class _AmountEntryScreenState extends State<AmountEntryScreen> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  bool _amountError = false;

  @override
  void initState() {
    super.initState();
    // Set the initial value of the _companyController using the widget.companyName
    _companyController.text = widget.companyName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Amount'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Amount',
                errorText: _amountError ? 'Enter a valid amount' : null,
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                double amount;
                try {
                  amount = double.parse(_amountController.text);
                  setState(() {
                    _amountError = false;
                  });
                } catch (e) {
                  // Handle the case where the input is not a valid number
                  setState(() {
                    _amountError = true;
                  });
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordView(
                      params: {
                        'Amount': amount.toStringAsFixed(2),
                        'Company Name': _companyController.text,
                      },
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                textStyle: TextStyle(fontSize: 18.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
