import 'package:flutter/material.dart';
import '../Auth Services/AuthServices.dart';
import '../utils/AppTextDecoration.dart';
import 'CountryCodes.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _displayNameController = TextEditingController();

  String _selectedCountryCode = '+91'; // Default country code
  bool _isLoading = false;

  bool _isChecked = false;

  Future<void> _registerWithPhoneNumber(String phoneNumber, String? email,
      String? displayName, String Title, BuildContext context) async {
    await AuthService().registerWithPhoneNumber(
        phoneNumber, email ?? '', displayName ?? '', Title, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign In to your Account',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          AssetImage("images/banking/user_avatar.png"),
                      // Use AssetImage to provide an ImageProvider for the background image
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      // Dropdown for country codes
                      Container(
                        height: 55, // Set the height as needed
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCountryCode = newValue!;
                            });
                          },
                          items: CountryCodes.getCountryCodes()
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                height: 55,
                                // Match the height of the TextFormField
                                child: Center(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                          elevation: 3,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 32,
                          underline: Container(
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Mobile number input
                      Expanded(
                        child: TextFormField(
                          controller: _mobileNumberController,
                          decoration: AppTextDecoration.defaultInputDecoration(
                            labelText: 'Mobile Number',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Mobile Number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'Display Name (optional)',
                      prefixIcon: Icons.person,
                      iconColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: AppTextDecoration.defaultInputDecoration(
                      labelText: 'Email ID (optional)',
                      prefixIcon: Icons.email,
                      iconColor: Colors.blue,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CheckboxListTile(
                    title: Text(
                      'Agree to our privacy policy and terms of use.',
                      style: TextStyle(fontSize: 14),
                    ),
                    value: _isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Set the width as needed
                    height: 50.0, // Set the height as needed
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _isChecked &&
                            !_isLoading) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Combine country code and mobile number
                          String phoneNumber =
                              '$_selectedCountryCode${_mobileNumberController.text}';
                          String? email = _emailController.text;
                          String? displayName = _displayNameController.text;
                          String Title = "Registration";

                          try {
                            // Perform registration logic here
                            await _registerWithPhoneNumber(phoneNumber, email,
                                displayName, Title, context);
                          } catch (error) {
                            // Handle any errors during registration
                            print('Registration failed: $error');
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
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
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _isLoading
                              ? Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink(),
                          _isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : SizedBox.shrink(),
                          _isLoading
                              ? SizedBox.shrink()
                              : Text('Send verification OTP'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to Payflow Reliable and Secure money exhange Platform',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
