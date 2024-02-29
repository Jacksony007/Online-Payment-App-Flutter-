import 'package:flutter/material.dart';
import '../Edit Screen/PinScreen.dart';
import '../utils/AppTextDecoration.dart';

class FeesPaymentPage extends StatefulWidget {
  final String universityName;
  final String location;
  final String accountNumber;

  const FeesPaymentPage({
    Key? key,
    required this.universityName,
    required this.location,
    required this.accountNumber,
  }) : super(key: key);

  @override
  _FeesPaymentPageState createState() => _FeesPaymentPageState();
}

class _FeesPaymentPageState extends State<FeesPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _enrollmentNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final String _paymentId = '007';

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
          'University Fees',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
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
                                  "images/banking/verified-check-svgrepo-com.png"),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'University Name: ${widget.universityName}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Location: ${widget.location}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Account Number: ${widget.accountNumber}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Student Full Name',
                        prefixIcon: Icons.person,
                        iconColor: Colors.blue,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _enrollmentNumberController,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Enrollment Number',
                        prefixIcon: Icons.confirmation_number,
                        iconColor: Colors.blue,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter enrollment number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Amount',
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: AppTextDecoration.defaultInputDecoration(
                        labelText: 'Description (Optional)',
                        prefixIcon: Icons.description,
                        iconColor: Colors.blue,
                      ),
                      // No validation for optional description
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          double? amount = parseAmount(_amountController.text);
                          if (amount != null) {
                            // Dismiss the keyboard
                            FocusScope.of(context).unfocus();

                            // Add a delay
                            await Future.delayed(Duration(milliseconds: 300));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PasswordView(
                                  params: {
                                    'TransactionId': _paymentId,
                                    "Receiver's Name": widget.universityName,
                                    'Location': widget.location,
                                    'Account Number': widget.accountNumber,
                                    'First Full Name': _nameController.text,
                                    'Enrollment Number':
                                        _enrollmentNumberController.text,
                                    'Amount': amount.toStringAsFixed(2),
                                    'Description': _descriptionController.text,
                                  },
                                ),
                              ),
                            );
                          } else {
                            // Handle invalid amount
                            showSnackBar('Invalid amount entered', context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Make Payment'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}
