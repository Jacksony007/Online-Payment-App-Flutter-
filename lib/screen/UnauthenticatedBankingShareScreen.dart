import 'package:flutter/material.dart';

class UnauthenticatedBankingShareScreen extends StatelessWidget {
  static const String routeName = "/unauthenticated_banking_share";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Payflow!',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'To access exclusive features and personalized services, please log in.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              // text color
              elevation: 5,
              // shadow elevation
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/registration');
            },
            child: Text('Login', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
