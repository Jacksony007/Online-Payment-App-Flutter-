import 'package:flutter/material.dart';
import '../Edit Screen/PinScreen.dart';
import 'VerificationDetails.dart';

class VerificationDetailsPage extends StatefulWidget {
  final VerificationDetails details;

  const VerificationDetailsPage({Key? key, required this.details})
      : super(key: key);

  @override
  _VerificationDetailsPageState createState() =>
      _VerificationDetailsPageState();
}

class _VerificationDetailsPageState extends State<VerificationDetailsPage> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final String _paymentId = '007';

  final _formKey = GlobalKey<FormState>();

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
          title: Text('Verification Details', style: TextStyle(color: Colors.white ), ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              child: ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  Colors.green,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                    "images/banking/car-svgrepo-com.png"),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Registerd Name: ${widget.details.name}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Service Applied: ${widget.details.serviceName}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Registration Number: ${widget.details.registrationNumber}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Enter Amount',
                          prefixIcon:
                              Icon(Icons.monetization_on, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Enter Description',
                          prefixIcon: Icon(Icons.note, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            double? amount =
                                parseAmount(_amountController.text);
                            if (amount != null) {
                              // Dismiss the keyboard
                              FocusScope.of(context).unfocus();
                              // Add a delay
                              await Future.delayed(
                                  const Duration(milliseconds: 300));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PasswordView(
                                    params: {
                                      'TransactionId': _paymentId,
                                      "Owrner's Name": widget.details.name,
                                      'Registration Number':
                                          widget.details.registrationNumber,
                                      'Amount': amount.toStringAsFixed(2),
                                      "Receiver's Name": widget.details.serviceName,
                                      'Description':
                                          _descriptionController.text,
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.payment,
                                  size: 24, color: Colors.white),
                              const SizedBox(width: 8.0),
                              Text(
                                'Pay Now',
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
              )),
        )));
  }
}
