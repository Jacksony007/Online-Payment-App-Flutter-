import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:free_flutter_ui_kits/model/BankInfo.dart';
import 'package:free_flutter_ui_kits/utils/BankLinkTextField.dart';
import 'package:nb_utils/nb_utils.dart';
import '../utils/BankingColors.dart';
import '../utils/BankingContants.dart';
import '../utils/BankingImages.dart';

class BankLinkPage extends StatefulWidget {
  const BankLinkPage({Key? key}) : super(key: key);

  @override
  _BankLinkPageState createState() => _BankLinkPageState();
}

class _BankLinkPageState extends State<BankLinkPage> {
  bool _isVerifying = false;
  bool _verificationSuccess = false;

  String _accountName = '';
  String _accountNumber = '';
  BankInfo? _selectedBank;
  String _expireDate = '';
  String _bankName = '';
  bool _verifyButtonPressed = false;

  final TextEditingController _typeAheadController =
      TextEditingController(text: 'Select bank name');

  String toTitleCase(String text) {
    return text.toLowerCase().split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return '';
      }
    }).join(' ');
  }

  String formatCardNumber(String cardNumber) {
    List<String> parts = [];
    for (int i = 0; i < cardNumber.length; i += 4) {
      int endIndex = (i + 4 < cardNumber.length) ? i + 4 : cardNumber.length;
      parts.add(cardNumber.substring(i, endIndex));
    }
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    String capitalizedAccountName = toTitleCase(_accountName);
    String capitalizedBankName = toTitleCase(_bankName);
    String _cardNumber = formatCardNumber(_accountNumber);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Link Bank', style: TextStyle(color: Colors.white)),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display card details or verification section
                        _verificationSuccess
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16.0,
                                      top: 8.0,
                                      bottom: 16.0),
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        Banking_ic_CardImage,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  capitalizedAccountName,
                                                  style: boldTextStyle(
                                                    color:
                                                        Banking_whitePureColor,
                                                    size: 18,
                                                    fontFamily: fontMedium,
                                                  ),
                                                ).paddingOnly(
                                                  top: spacing_large,
                                                  left: spacing_standard_new,
                                                ),
                                                Text(
                                                  "PayFlow App",
                                                  style: boldTextStyle(
                                                    color:
                                                        Banking_whitePureColor,
                                                    size: 16,
                                                    fontFamily: fontMedium,
                                                  ),
                                                ).paddingOnly(
                                                  top: spacing_large,
                                                  right: spacing_standard_new,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              _bankName.isNotEmpty
                                                  ? capitalizedBankName
                                                  : 'Select Bank',
                                              style: boldTextStyle(
                                                color: Banking_whitePureColor,
                                                size: 18,
                                                fontFamily: fontMedium,
                                              ),
                                            ).paddingOnly(
                                              top: spacing_large,
                                              left: spacing_standard_new,
                                            ),
                                            Text(
                                              _cardNumber,
                                              style: boldTextStyle(
                                                color: Banking_whitePureColor,
                                                size: 18,
                                                fontFamily: fontMedium,
                                              ),
                                            ).paddingOnly(
                                              left: spacing_standard_new,
                                              top: spacing_control,
                                            ),
                                            Text(
                                              _expireDate,
                                              style: boldTextStyle(
                                                color: Banking_whitePureColor,
                                                size: 18,
                                                fontFamily: fontMedium,
                                              ),
                                            ).paddingOnly(
                                              top: spacing_standard,
                                              left: spacing_standard_new,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        // Empty container if verification is not successful

                        // Verification form
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(
                                child: Text(
                                  'Enter Your Bank Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              BankLinkTextField(
                                onChanged: (value) {
                                  setState(() {
                                    _accountName = value;
                                  });
                                },
                                labelText: 'Account Name',
                                icon: Icons.person,
                                errorText:
                                    _verifyButtonPressed && _accountName.isEmpty
                                        ? 'Please enter your account name'
                                        : null,
                              ),
                              const SizedBox(height: 10),

                              BankLinkTextField(
                                onChanged: (value) {
                                  setState(() {
                                    _accountNumber = value;
                                  });
                                },
                                labelText: 'Card Number',
                                icon: Icons.credit_card,
                                errorText: _verifyButtonPressed &&
                                        _accountNumber.isEmpty
                                    ? 'Please enter your card number'
                                    : null,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Restrict to digits
                              ),

                              const SizedBox(height: 10),

                              Autocomplete<BankInfo>(
                                displayStringForOption: (BankInfo option) =>
                                    option.name,
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '' ||
                                      textEditingValue.text ==
                                          'Select bank name') {
                                    return BankList.getBanks();
                                  }
                                  return BankList.getBanks()
                                      .where((BankInfo option) {
                                    return option.name.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                optionsViewBuilder: (
                                  BuildContext context,
                                  AutocompleteOnSelected<BankInfo> onSelected,
                                  Iterable<BankInfo> options,
                                ) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      child: SizedBox(
                                        height: 300.0,
                                        // Change as per your requirement
                                        child: ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          // Ensure scrollability
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final BankInfo option =
                                                options.elementAt(index);
                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      option.logoPath),
                                                  radius: 15,
                                                ),
                                                title: Text(option.name),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },

                                onSelected: (BankInfo selection) {
                                  _typeAheadController.text = selection.name;
                                  _selectedBank =
                                      selection; // Update the selected bank
                                  _bankName = selection.name;
                                },
                                // Style customization
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
                                      labelText: 'Select Bank',
                                      prefixIcon: const Icon(
                                        Icons.account_balance,
                                        color: Colors.blue,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorText: _verifyButtonPressed &&
                                              (_selectedBank == null ||
                                                  _bankName.isEmpty)
                                          ? 'Please select a valid bank'
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller:
                                    TextEditingController(text: _expireDate),
                                decoration: InputDecoration(
                                  labelText: 'Expire Date',
                                  prefixIcon: const Icon(Icons.calendar_today,
                                      color: Colors.blue),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  errorText: _verifyButtonPressed &&
                                          _expireDate.isEmpty
                                      ? 'Please select the expiration date'
                                      : null,
                                ),
                                readOnly: true,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2099),
                                    // Allow selection of dates up to year 2099
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return Theme(
                                        data: ThemeData.light().copyWith(
                                          primaryColor: Colors.blue,
                                          buttonTheme: const ButtonThemeData(
                                            textTheme: ButtonTextTheme.primary,
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                          colorScheme: const ColorScheme.light(
                                                  primary: Colors.blue)
                                              .copyWith(secondary: Colors.blue),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );

                                  if (pickedDate != null) {
                                    // Format pickedDate to show only month and year
                                    String formattedDate =
                                        "${pickedDate.month.toString().padLeft(2, '0')}/${(pickedDate.year % 100).toString().padLeft(2, '0')}";

                                    setState(() {
                                      _expireDate = formattedDate;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16.0),

                              // Verification button with loading indicator
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _verifyButtonPressed = true;
                                  });

                                  // Check if any required field is empty
                                  if (_accountName.isEmpty ||
                                      _accountNumber.isEmpty ||
                                      _selectedBank == null ||
                                      _bankName.isEmpty ||
                                      _expireDate.isEmpty) {
                                    return;
                                  }

                                  // Perform verification logic here
                                  setState(() {
                                    _isVerifying = true;
                                  });

                                  // Simulate verification
                                  await Future.delayed(
                                      const Duration(seconds: 2));

                                  setState(() {
                                    _isVerifying = false;
                                    _verificationSuccess =
                                        true; // Set to true for successful verification
                                  });

                                  // If verification successful, add user details accordingly
                                  if (_verificationSuccess) {
                                    // Add user details logic here, including _selectedBank details
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                  // Text color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: const Size(double.infinity,
                                      48), // Adjusted height and width
                                ),
                                child: _isVerifying
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                                Icon(Icons.link,
                                                    size: 24,
                                                    color: Colors.white),
                                                const SizedBox(width: 8.0),
                                                Text(
                                                  'Add Card',
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
                      ],
                    ),
                  ),
                ))));
  }
}
