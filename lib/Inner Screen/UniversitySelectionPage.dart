import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/model/UniversityInfo.dart';
import 'package:free_flutter_ui_kits/utils/AutoComplete.dart';

import '../Pay Bills/FeesPaymentPage.dart';
import '../utils/AppTextDecoration.dart';
import '../utils/CustomAppBar.dart';

class UniversitySelectionPage extends StatefulWidget {
  const UniversitySelectionPage({Key? key}) : super(key: key);

  @override
  _UniversitySelectionPageState createState() =>
      _UniversitySelectionPageState();
}

class _UniversitySelectionPageState extends State<UniversitySelectionPage> {
  UniversityInfo? selectedUniversity;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _universityNameController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  bool _isLoading = false;
  bool _buttonClicked = false;

  List<UniversityInfo> universityList = UniversityList.getUniversities();

  Future<void> verifyUniversity() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request.
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Successful'),
        content: Text(
          'University Name: ${_universityNameController.text}\n'
          'Account Number: ${_accountNumberController.text}\n'
          'State: ${_stateController.text}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the verification dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeesPaymentPage(
                    universityName: _universityNameController.text,
                    location: _stateController.text,
                    accountNumber: _accountNumberController.text,
                  ),
                ),
              );
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Select University',
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 0.0,
        textTheme: Theme.of(context).textTheme.copyWith(
              titleLarge: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose a University:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.topLeft,
              child: Autocomplete<UniversityInfo>(
                displayStringForOption: (UniversityInfo option) => option.name,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '' ||
                      textEditingValue.text == 'Select university name') {
                    return universityList;
                  }
                  return universityList.where((UniversityInfo option) {
                    return option.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (UniversityInfo selection) {
                  setState(() {
                    selectedUniversity = selection;
                  });
                },
                optionsViewBuilder: (BuildContext context,
                    AutocompleteOnSelected<UniversityInfo> onSelected,
                    Iterable<UniversityInfo> options) {
                  return AutocompleteOptionsWidget(
                    options: options.toList(),
                    onSelected: onSelected,
                  );
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    decoration: InputDecoration(
                      labelText: 'Select University',
                      prefixIcon: const Icon(
                        Icons.school,
                        color: Colors.blue,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorText: _buttonClicked && selectedUniversity == null
                          ? 'Please select a valid university'
                          : null,
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: selectedUniversity?.name == "Others",
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _universityNameController,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'University Name',
                      prefixIcon: Icons.school,
                      iconColor: Colors.blue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter university name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _accountNumberController,
                    keyboardType: TextInputType.number,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'University Account Number',
                      prefixIcon: Icons.account_balance_wallet,
                      iconColor: Colors.blue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _stateController,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'University State',
                      prefixIcon: Icons.location_on,
                      iconColor: Colors.blue,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter state';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _buttonClicked = true;
                });

                if (selectedUniversity?.name == "Others") {
                  // For "Others" option, validate and call verifyUniversity
                  if (_formKey.currentState!.validate()) {
                    verifyUniversity();
                  }
                } else {
                  // For other options, perform actions based on the selected university
                  if (selectedUniversity != null) {
                    Navigator.of(context)
                        .pop(); // Close the verification dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeesPaymentPage(
                          universityName: selectedUniversity!.name,
                          location: selectedUniversity!.location,
                          accountNumber: selectedUniversity!.accountNumber,
                        ),
                      ),
                    );
                  } else {}
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
                padding: const EdgeInsets.all(16.0),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        selectedUniversity?.name == "Others"
                            ? 'Verify'
                            : 'Submit',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
