import 'package:flutter/material.dart';


class PaymentController {
  String code = '';
  int selectedindex = 0;

  void addDigit(int digit, BuildContext context, Map<String, dynamic> values) {
    setState(() {
      if (code.length < 4) {
        code = code + digit.toString();
      }
      if (code.length == 4) {
        _showReceiptDialog(context, values);
      }
    });
  }

  void backspace() {
    if (code.isEmpty) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedindex = code.length;
    });
  }

  void _showReceiptDialog(BuildContext context, Map<String, dynamic> values) {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                'Payment Successful',
                style: TextStyle(color: Colors.blue, fontSize: 18.0),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildDialogContent(values),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildDialogContent(Map<String, dynamic> values) {
    List<Widget> content = [
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Image.asset(
            'images/banking/tick.png',
            height: 70,
            width: 70,
            color: Colors.green,
          ),
        ),
      ),
      const SizedBox(height: 10.0),
    ];

    values.forEach((key, value) {
      String capitalizedValue =
      _capitalizeFirstLetterEachWord(value.toString());
      content.add(Text('$key: $capitalizedValue'));
      content.add(const SizedBox(height: 10.0));
    });

    content.addAll([
      const SizedBox(height: 20.0),
      const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.thumb_up, size: 24, color: Colors.blue),
            SizedBox(width: 8.0),
            Text('Thank You!',
                style: TextStyle(fontSize: 18, color: Colors.blue)),
          ],
        ),
      ),
    ]);

    return content;
  }

  String _capitalizeFirstLetterEachWord(String input) {
    return input.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  void setState(VoidCallback fn) {
    // Implement the logic to update the state here.
  }
}
