import 'package:flutter/material.dart';
import '../utils/AppTextDecoration.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/registration');
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              child: Text("Create Account"),
            ),
          ],
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
                      TextFormField(
                        controller: _mobileNumberController,
                        decoration: AppTextDecoration.defaultInputDecoration(
                          labelText: 'Enter your PayFlow mobile number',
                          prefixIcon: Icons.email,
                          iconColor: Colors.blue,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Mobile Number or Email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: AppTextDecoration.defaultInputDecoration(
                          labelText: 'PayFlow Password',
                          prefixIcon: Icons.lock,
                          iconColor: Colors.blue,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your PayFlow Password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text(
                        'PLEASE NOTE: Payflow and Payflow for Business Dashboard password are the same.',
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Call the signInWithPhoneOrEmail method from LoginController
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            child: Text('Sign In Securely'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/forget_password');
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              foregroundColor: Colors.blue,
                            ),
                            child: Text("Forget Password"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'By signing in, you agree to our privacy policy and terms of use.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
