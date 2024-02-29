import 'package:flutter/material.dart';

import '../model/FamilyInsuranceModel.dart';
import '../utils/AppTextDecoration.dart';
import 'InsuranceAmountPage.dart';

class FamilyInsurancePage extends StatefulWidget {
  const FamilyInsurancePage({Key? key}) : super(key: key);

  @override
  _FamilyInsurancePageState createState() => _FamilyInsurancePageState();
}

class _FamilyInsurancePageState extends State<FamilyInsurancePage> {
  // Controllers for text fields
  TextEditingController companyController = TextEditingController();
  TextEditingController insuranceIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Loading indicator state
  bool isLoading = false;

  // Function to simulate loading and navigate to details page
  void navigateToDetailsPage() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InsuranceAmountPage(
            selectedCompany: companyController.text,
            insuranceId: insuranceIdController.text,
          ),
        ),
      );
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Family Insurance',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Autocomplete for insurance companies
                            Autocomplete<FamilyInsurance>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                return companies
                                    .where((company) => company.name
                                        .toLowerCase()
                                        .contains(textEditingValue.text
                                            .toLowerCase()))
                                    .toList();
                              },
                              onSelected: (FamilyInsurance selectedCompany) {
                                companyController.text = selectedCompany.name;
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController fieldController,
                                  FocusNode fieldFocusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextFormField(
                                  controller: fieldController,
                                  focusNode: fieldFocusNode,
                                  decoration:
                                      AppTextDecoration.defaultInputDecoration(
                                    labelText: 'Choose an Insurance Company',
                                    prefixIcon: Icons.business,
                                    iconColor: Colors.blue,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an Insurance Company';
                                    }
                                    return null;
                                  },
                                );
                              },
                              displayStringForOption:
                                  (FamilyInsurance company) => company.name,
                            ),
                            SizedBox(height: 16),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: insuranceIdController,
                              decoration:
                                  AppTextDecoration.defaultInputDecoration(
                                labelText: 'Insurance Id Number',
                                prefixIcon: Icons.credit_card,
                                iconColor: Colors.blue,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Insurance Id Number';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 32),
                            // Button to navigate to details page
                            ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    navigateToDetailsPage();
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
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text('Verify'),
                                )),
                            SizedBox(height: 16),
                            // Circular loading indicator
                            isLoading
                                ? Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      Text('Verifying Details.....'),
                                    ],
                                  )
                                : Container(), // Empty container if not loading
                          ],
                        ),
                      ),
                    )))));
  }
}
