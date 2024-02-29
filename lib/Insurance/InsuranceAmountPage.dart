import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Edit Screen/PinScreen.dart';
import '../utils/AppTextDecoration.dart';

class SuggestedAmounts {
  static const List<double> amounts = [50.0, 100.0, 500.0];
}

class InsuranceAmountPage extends StatefulWidget {
  final String selectedCompany;
  final String insuranceId;

  const InsuranceAmountPage(
      {Key? key, required this.selectedCompany, required this.insuranceId})
      : super(key: key);

  @override
  _InsuranceAmountPageState createState() => _InsuranceAmountPageState();
}

class _InsuranceAmountPageState extends State<InsuranceAmountPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\₵');
  bool _isProcessingPayment = false;
  String name = 'Jackson';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter Amount for ${widget.selectedCompany}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Column(
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
                                  "images/banking/family-insurance-symbol-svgrepo-com.png"),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            'Insurance Company: ${widget.selectedCompany}',
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Verified Name: ${name}',
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Insurance Number: ${widget.insuranceId}',
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Enter Amount',
                        prefixIcon: Icons.money,
                        iconColor: Colors.blue,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Amount cannot be empty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Enter Description',
                        prefixIcon: Icons.description,
                        iconColor: Colors.blue,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24.0),
                    // Display suggested amounts as circular buttons
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.center,
                      children: SuggestedAmounts.amounts.map((amount) {
                        return ElevatedButton(
                          onPressed: _isProcessingPayment
                              ? null
                              : () {
                                  _amountController.text = amount.toString();
                                },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(26.0),
                            backgroundColor: Colors.blue,
                          ),
                          child: Text(
                            _currencyFormat.format(amount),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: _isProcessingPayment
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessingPayment = true;
                                });

                                try {
                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  String enteredAmount = _amountController.text;
                                  String formattedAmount = _currencyFormat
                                      .format(double.parse(enteredAmount));

                                  FocusScope.of(context).unfocus();
                                  await Future.delayed(
                                      const Duration(milliseconds: 300));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PasswordView(
                                        params: {
                                          'TransactionId': '12345',
                                          "Insurance Holder Name": name,
                                          "Receiver's Name":
                                              widget.selectedCompany,
                                          "Receiver's Number":
                                              widget.insuranceId,
                                          'Amount': formattedAmount,
                                          'Description':
                                              _descriptionController.text,
                                        },
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  _showSnackBar(
                                      'Payment failed. Please Enter Valid Amount.');
                                } finally {
                                  setState(() {
                                    _isProcessingPayment = false;
                                  });
                                }
                              } else {
                                return;
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.payment,
                                size: 24, color: Colors.white),
                            const SizedBox(width: 8.0),
                            _isProcessingPayment
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'Make Payment',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.white),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
