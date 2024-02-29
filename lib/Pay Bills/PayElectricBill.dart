import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/Pay%20Bills/PaymentPage.dart';
import '../utils/AppTextDecoration.dart';
import '../utils/CustomAppBar.dart';

class MeterVerificationPage extends StatefulWidget {
  final String title;

  const MeterVerificationPage({required this.title, Key? key})
      : super(key: key);

  @override
  _MeterVerificationPageState createState() => _MeterVerificationPageState();
}

class _MeterVerificationPageState extends State<MeterVerificationPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _stateController;
  late TextEditingController _meterNumberController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _stateController = TextEditingController();
    _meterNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _stateController.dispose();
    _meterNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Meter Verification',
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _showHelpDialog,
            ),
          ],
          textTheme: Theme.of(context).textTheme.copyWith(
                titleLarge: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
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
                          TextFormField(
                            controller: _stateController,
                            decoration:
                                AppTextDecoration.defaultInputDecoration(
                              labelText: 'Enter State',
                              prefixIcon: Icons.location_on,
                              iconColor: Colors.blue,
                              helperText: 'State abbreviation or name',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Meter Number cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _meterNumberController,
                            decoration:
                                AppTextDecoration.defaultInputDecoration(
                              labelText: 'Enter Meter Number',
                              prefixIcon: Icons.electrical_services,
                              iconColor: Colors.blue,
                              helperText: 'Numeric meter identifier',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Meter Number cannot be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
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

                                // Navigate to the payment class if verification is successful
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      title: widget.title,
                                      state: _stateController.text,
                                      meterNumber: _meterNumberController.text,
                                    ),
                                  ),
                                );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Verifying ...',
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
                                            Text(
                                              'Verify',
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
                ))));
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help'),
          content: const Text(
              'Enter the state and meter number to verify the meter. Make sure both fields are filled before verification.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
