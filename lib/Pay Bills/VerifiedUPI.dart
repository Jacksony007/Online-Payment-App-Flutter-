import 'package:flutter/material.dart';

import '../General Payment/AmountPage.dart';
import '../User Model/user_financial_model.dart';

class VerifiedUpiIdPage extends StatelessWidget {
  final UserFinancialModel? financialData;

  VerifiedUpiIdPage({Key? key, this.financialData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.check_circle, color: Colors.green, size: 50),
        Text('PayflowId is Valid', style: TextStyle(fontSize: 20)),
        SizedBox(height: 15),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Verified Name', style: TextStyle(fontSize: 16)),
          SizedBox(
            width: 20,
          ),
          Text(financialData?.accountName ?? '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AmountPage(
                        financialData: financialData))); // Close the page
          },
          child: Text(
            'Proceed',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
      ],
    );
  }
}
