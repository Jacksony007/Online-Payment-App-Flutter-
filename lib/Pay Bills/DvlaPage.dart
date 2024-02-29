import 'package:flutter/material.dart';

import '../utils/AppTextDecoration.dart';
import 'DvlaService.dart';
import 'VerificationDetails.dart';
import 'VerificationDetailsPage.dart';

class DvlaPage extends StatefulWidget {
  const DvlaPage({Key? key}) : super(key: key);

  @override
  _DvlaPageState createState() => _DvlaPageState();
}

class _DvlaPageState extends State<DvlaPage> {
  DvlaService? selectedService;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _registrationNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'DVLA Services',
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
                          const Text(
                            'Choose a DVLA Service:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Autocomplete<DvlaService>(
                            displayStringForOption: (DvlaService option) =>
                                option.name,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return DvlaServiceList.getServices();
                              }
                              return DvlaServiceList.getServices()
                                  .where((DvlaService option) {
                                return option.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (DvlaService selection) {
                              setState(() {
                                selectedService = selection;
                              });
                            },
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return TextFormField(
                                controller: textEditingController,
                                focusNode: focusNode,
                                onFieldSubmitted: (String value) {
                                  onFieldSubmitted();
                                },
                                decoration:
                                    AppTextDecoration.defaultInputDecoration(
                                  labelText: 'Select DVLA Service',
                                  prefixIcon: Icons.local_library,
                                  iconColor: Colors.blue,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Registration Number';
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _registrationNumberController,
                            decoration:
                                AppTextDecoration.defaultInputDecoration(
                              labelText: 'Enter Vehicle Registration Number',
                              prefixIcon: Icons.directions_car,
                              iconColor: Colors.blue,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Registration Number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              // Simulate a network request for verification
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });

                                // Simulate a delay
                                Future.delayed(Duration(seconds: 2), () {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  // Proceed with verification logic
                                  Navigator.of(context)
                                      .pop(); // Close the verification dialog

                                  // Navigate to VerificationDetailsPage with the details
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VerificationDetailsPage(
                                        details: VerificationDetails(
                                          serviceName:
                                              selectedService?.name ?? 'N/A',
                                          registrationNumber:
                                              _registrationNumberController
                                                  .text,
                                          name:
                                              'User Name', // Replace with actual user name
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: isLoading
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircularProgressIndicator(),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Verifying ...',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text('Verify'),
                                      )),
                          ),
                        ],
                      ),
                    ),
                  ))),
        ));
  }
}
