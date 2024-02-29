import 'package:flutter/material.dart';
import 'package:free_flutter_ui_kits/model/UniversityInfo.dart';

import '../utils/AppTextDecoration.dart';
import '../utils/AutoComplete.dart';
import 'FeesPaymentPage.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Select University',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
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
                          const Text(
                            'Choose a University:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Autocomplete<UniversityInfo>(
                              displayStringForOption: (UniversityInfo option) =>
                                  option.name,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '' ||
                                    textEditingValue.text ==
                                        'Select university name') {
                                  return universityList;
                                }
                                return universityList
                                    .where((UniversityInfo option) {
                                  return option.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              },
                              onSelected: (UniversityInfo selection) {
                                setState(() {
                                  selectedUniversity = selection;
                                });
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<UniversityInfo>
                                      onSelected,
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
                                    errorText: _buttonClicked &&
                                            selectedUniversity == null
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
                                  decoration:
                                      AppTextDecoration.defaultInputDecoration(
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
                                  decoration:
                                      AppTextDecoration.defaultInputDecoration(
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
                                  decoration:
                                      AppTextDecoration.defaultInputDecoration(
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
                            onPressed: () async {
                              setState(() {
                                _buttonClicked = true;
                              });

                              if (selectedUniversity?.name == "Others") {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  // Simulate a delay using Future.delayed
                                  await Future.delayed(Duration(seconds: 2));

                                  setState(() {
                                    _isLoading = false;
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FeesPaymentPage(
                                        universityName:
                                            _universityNameController.text,
                                        location: _stateController.text,
                                        accountNumber:
                                            _accountNumberController.text,
                                      ),
                                    ),
                                  );
                                } else {}
                              } else if (selectedUniversity != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FeesPaymentPage(
                                      universityName: selectedUniversity!.name,
                                      location: selectedUniversity!.location,
                                      accountNumber:
                                          selectedUniversity!.accountNumber,
                                    ),
                                  ),
                                );
                              } else {
                                // Handle the case when no university is selected (optional)
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
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors.white), // Customize color
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          'Verifying ...',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  selectedUniversity?.name ==
                                                          "Others"
                                                      ? 'Verify'
                                                      : 'Submit',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))));
  }
}
